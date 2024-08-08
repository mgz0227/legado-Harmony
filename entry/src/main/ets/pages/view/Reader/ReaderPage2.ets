import battery from 'ets/componets/common/battery';
import Dialog from 'ets/componets/common/Dialog';
import { display, promptAction, router, window } from '@kit.ArkUI';
import sourceView from './sourceView';
import { NetworkInput } from 'ets/componets/Reader/NetworkInput';
import DownloadSettingDialog from '../../../componets/Reader/DownloadSettingDialog';
import LayoutMoreDialog from '../../../componets/Reader/LayoutMoreDialog';
import { TxtContentHandler } from '../../../componets/Reader/TxtContentHandler';
import { MusicPlayer } from 'ets/componets/Reader/MusicPlayer';
import purificationView from './purificationView';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { BookList } from 'ets/componets/dataList/bookList';
import { CoverFlipView } from '@ohos/readerLibrary';
import {
  BGColorType,
  BG_COLOR_ARRAY,
  Constants,
  FlipPageType
} from '@ohos/readerLibrary/src/main/ets/common/constants/Constants';
import { SlideFlipView } from '@ohos/readerLibrary/src/main/ets/view/SlideFlipView';
import { UpDownFlipView } from '@ohos/readerLibrary/src/main/ets/view/UpDownFlipView';
import { BusinessError } from '@kit.BasicServicesKit';
import { SimulateCurlView } from '@ohos/readerLibrary/src/main/ets/view/SimulateCurlView';
import { NovelContentParseHelper } from '@ohos/readerLibrary/src/main/ets/common/helper/NovelContentParseHelper';
import {
  ReaderChapterItem,
  ReaderChapterPageItem
} from '@ohos/readerLibrary/src/main/ets/common/constants/ReaderChaptersItem';


interface ParamsObj {
  bookData: BookList,
  clickBookChapter: number,
  txtFile: chaptersItem[]
}

@Entry
@Component
struct ReaderPage2 {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State ReaderPadding: number = 24 // 边距
  @State isShowSetting: boolean = true
  @State isShowDownload: boolean = false
  @State isShowListen: boolean = false
  @State isShowContentSetting: boolean = false
  @State isShowMoreLayout: boolean = false
  @State CurrentChapters: number = 0
  @State CurrentPage: number = 0
  @State TotalChapters: number = 0
  @State CurrentLuminance: number = 0 // 亮度
  @State CurrentFontSize: number = 20 // 字号
  @State LineHeight: number = 1.8
  @State ParagraphSpacing: number = -2
  @State isShowSource: boolean = false
  @State isShowPurification: boolean = false
  @Provide('chapterList') chapterList: ReaderChapterItem[] = [];
  @Provide('turnStyle') turnStyle: FlipPageType = FlipPageType.COVER_FLIP_PAGE;
  @Provide('fontSize') @Watch('onFontSizeChange') fontSize: number = Constants.INIT_FONT_SIZE;
  @Provide('lineHeightRatio') @Watch('onFontSizeChange') lineHeightRatio: number = Constants.INIT_LINE_HEIGHT_RATIO;
  @Provide('bgColorIndex') @Watch('onBgColorChanged') bgColorIndex: BGColorType = BGColorType.WHITE;
  @Provide('bgColor') bgColor: string = BG_COLOR_ARRAY[BGColorType.WHITE];
  // @Provide('offsetX') offsetX: number = 0
  @Provide('offsetY') offsetY: number = 0;
  @Provide('screenH') screenH: number = 0;
  @Provide('screenW') screenW: number = 0;
  @Provide('sumRow') sumRow: number = 0;
  @Provide('rowWord') rowWord: number = 0;
  @Provide('rotateAngleOne') rotateAngleOne: number = Constants.INIT_ROTATE_ANGLE_ONE;
  @Provide('rotateAngleTwo') rotateAngleTwo: number = 0.0;
  @Provide('curPosition') curPosition: number = 0;
  @Provide('currentPageNum') @Watch('onFlush') currentPageNum: number = 0;
  @Provide('pageWordSum') pageWordSum: number = 0;
  @Provide('light') light: number = Constants.INIT_SCREEN_LIGHT;
  @Provide('isSystemLight') isSystemLight: boolean = false;
  @Provide('rowGap') rowGap: number = Constants.INIT_ROW_GAP;
  @Provide('displaySize') @Watch('calChapterContent') displaySize: number[] = [0, 0];
  @State currentChapterNum: number = 0;
  @State isFontChanged: boolean = false;
  // @State txtFile: chaptersItem[] = [];
  // 网址导入Dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: Dialog({
      title: '加入书架',
      CancelString: "暂不加入",
      ConfirmString: "加入书架",
      child: () => {
        this.DialogString()
      },
    }),
    cornerRadius: 16,
    gridCount: 4,
    offset: { dx: 0, dy: -300 }
  })

  async aboutToAppear() {
    //详情页加了个目录序号参数，所以修改了一下params的类型，不影响之前的bookData，但需要多‘.’一次。看看大佬们可以怎么优化一下，上个页面BookDetailPage
    let temp = router.getParams() as ParamsObj
    console.log('router ReaderPage2:' + temp.bookData.fileLink)
    this.chapterList = temp.txtFile.map((value) => {
      return new ReaderChapterItem(value.number, value.title, value.chapterTitleNumber, value.content);
    }) //txt小说

    if (this.chapterList.length != 0) {
      this.chapterList[0].chapterList = this.chapterList[0].content.split('\n').map((value) => value + '\n');
    }

    if (this.chapterList.length >= 2) {
      for (let index = 1; index < this.chapterList.length; index++) {
        this.chapterList[index].chapterList = this.chapterList[index].content.split('\n').map((value) => value + '\n');
      }
    }
    this.TotalChapters = this.chapterList.length
    this.CurrentChapters = temp.clickBookChapter
    this.screenW = px2vp(display.getDefaultDisplaySync().width);
    this.screenH = px2vp(display.getDefaultDisplaySync().height - (AppStorage.get('avoidHeight') as number));
    this.sumRow = Math.floor((this.screenH) / (this.fontSize + this.rowGap));
    this.rowWord = Math.floor((this.screenW - Constants.SCREEN_MARGIN_LEFT * 2) / this.fontSize);
    this.simulatePageContent();
    this.changeSystemBarStatue();
  }

  calChapterContent() {
    let width = this.displaySize[0];
    let height = this.displaySize[1];

    if (width !== 0 && height !== 0) {
      NovelContentParseHelper.calculateChapterContent(this.chapterList[this.CurrentChapters].chapterList, this.fontSize,
        this.fontSize * this.lineHeightRatio, width, height).then((chapterList) => {
        let startIndex = 0
        this.chapterList[this.CurrentChapters].chapterPageList = chapterList.map((item) => {
          let contentLength = item.reduce((accumulator, currentString) => {
            return accumulator + currentString.length;
          }, 0)
          let result = new ReaderChapterPageItem(startIndex, startIndex + contentLength, item);
          startIndex += contentLength;
          return result
        })
        this.chapterList = Array.from(this.chapterList)
      }).catch((reason: string) => {
        console.log(reason);
      });
    }

  }

  onFontSizeChange() {
    this.sumRow = Math.floor((this.screenH) / (this.fontSize + this.rowGap));
    this.rowWord = Math.floor((this.screenW - Constants.SCREEN_MARGIN_LEFT * 2) / this.fontSize);
    let pageWordSum = this.sumRow * this.rowWord;

    if (this.currentChapterNum > pageWordSum) {
      this.currentPageNum = Math.floor(this.currentChapterNum / (pageWordSum)) +
        (this.currentChapterNum > 1 && this.currentChapterNum % pageWordSum > 0 ? 2 : 1);
    } else if (this.currentChapterNum > 0) {
      this.currentPageNum = 2;
    } else {
      console.info('currentStartIndex = ' + this.currentChapterNum);
    }
    this.isFontChanged = true;
    this.simulatePageContent();
  }

  changeSystemBarStatue(): void {
    window.getLastWindow(getContext(this), (err, data) => {
      const errCode = err.code;
      if (errCode) {
        return;
      }
      let SystemBarProperties: window.SystemBarProperties = {
        statusBarColor: BG_COLOR_ARRAY[this.bgColorIndex],
        navigationBarColor: BG_COLOR_ARRAY[this.bgColorIndex],
        navigationBarContentColor: Constants.TRANSPARENT
      };
      try {
        data.setWindowSystemBarProperties(SystemBarProperties, (err: BusinessError) => {
          const errCode: number = err.code;
          if (errCode) {
            console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
            return;
          }
          data.setWindowBackgroundColor(BG_COLOR_ARRAY[this.bgColorIndex]);
        });
      } catch (exception) {
        console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(exception));
      }
    });
  }

  onBgColorChanged() {
    this.changeSystemBarStatue();
  }

  onFlush() {
    console.info('currentPageNum=' + this.currentPageNum + ', isFontChanged=' + this.isFontChanged);
    if (this.isFontChanged && this.currentPageNum === 1) {
      this.isFontChanged = false;
      this.currentChapterNum = 0;
    }
  }

  simulatePageContent() {
    this.offsetY = 0;
    this.rotateAngleTwo = 0.0;
    this.rotateAngleOne = Constants.INIT_ROTATE_ANGLE_ONE;
  }

  private clickAnimateTo(isLeft: Boolean) {
    // if (this.turnStyle === FlipPageType.COVER_FLIP_PAGE) {
    //   animateTo({
    //     duration: Constants.COVER_DURATION,
    //     curve: Curve.EaseOut,
    //     onFinish: () => {
    //       if (this.offsetX > 0) {
    //         this.currentPageNum > 0 ? this.currentPageNum - 1 : this.currentPageNum;
    //         this.currentChapterNum -= this.sumRow * this.rowWord;
    //       } else if (this.offsetX < 0) {
    //         this.currentPageNum += 1;
    //         this.currentChapterNum += this.sumRow * this.rowWord;
    //       }
    //       this.offsetX = 0;
    //       this.simulatePageContent();
    //     }
    //   }, () => {
    //     if (isLeft) {
    //       this.offsetX = this.screenW;
    //     } else {
    //       this.offsetX = -this.screenW;
    //     }
    //   });
    // } else if (this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE) {
    //   animateTo({
    //     duration: Constants.SIMULATE_DURATION,
    //     curve: Curve.EaseOut,
    //     onFinish: () => {
    //       this.simulatePageContent();
    //       if (isLeft) {
    //         this.currentChapterNum -= this.sumRow * this.rowWord;
    //       } else {
    //         this.currentChapterNum += this.sumRow * this.rowWord;
    //       }
    //     }
    //   }, () => {
    //     if (isLeft) {
    //       this.rotateAngleOne = 0;
    //       this.currentPageNum > 0 ? this.currentPageNum - 1 : this.currentPageNum;
    //     } else {
    //       this.rotateAngleTwo = Constants.INIT_ROTATE_ANGLE_ONE;
    //       this.currentPageNum += 1;
    //     }
    //   })
    // } else if (this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE) {
    //   animateTo({
    //     duration: Constants.SLIDE_DURATION,
    //     curve: Curve.EaseOut,
    //     onFinish: () => {
    //       if (this.offsetX > 0) {
    //         this.currentPageNum > 0 ? this.currentPageNum - 1 : this.currentPageNum;
    //         this.currentChapterNum -= this.sumRow * this.rowWord;
    //       }
    //       if (this.offsetX < 0) {
    //         this.currentPageNum += 1;
    //         this.currentChapterNum += this.sumRow * this.rowWord;
    //       }
    //       console.info(this.currentChapterNum.toString());
    //       this.offsetX = 0;
    //       this.simulatePageContent();
    //     }
    //   }, () => {
    //     if (isLeft) {
    //       this.offsetX = this.screenW;
    //     } else {
    //       this.offsetX = -this.screenW;
    //     }
    //   })
    // }
  }

  build() {
    Stack() {
      Column() {
        if (this.isShowSetting) {
          // 阅读器-上方弹框
          Column() {
            Row({ space: 8 }) {
              Image($r("app.media.ic_public_return_left"))
                .width(24)
                .onClick(() => {
                  router.back()
                })
              Text(`${this.chapterList[this.CurrentChapters]?.chapterTitleNumber} ${this.chapterList[this.CurrentChapters]?.title}`
                .replace(new RegExp('\\s{1,}', 'g'), ' ')
                .replaceAll('=', ''))
                .layoutWeight(1)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Row({ space: 16 }) {
                Image($r("app.media.refresh"))
                  .width(24)
                  .onClick(() => {

                  })
                Image($r("app.media.down"))
                  .width(24)
                  .onClick(() => {
                    this.isShowDownload = true
                  })
                  .bindSheet($$this.isShowDownload, this.DownloadDialog(), {
                    height: 500,
                    showClose: false,
                    dragBar: false,
                    blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
                    onDisappear: () => {
                      // this.clickBookType = ''
                    }
                  })
                Image($r("app.media.more"))
                  .width(24)
                  .onClick(() => {

                  })
              }
            }
            .padding({
              top: 12,
              left: 20,
              right: 20,
              bottom: 12
            })
            .width("100%")

            Row() {
              NetworkInput()
            }
            .padding({
              top: 8,
              left: 20,
              right: 20,
              bottom: 12
            })
            .width("100%")

            Divider()
          }
          .backgroundColor("white")
          .transition(TransitionEffect.move(TransitionEdge.TOP).animation({ duration: 500 }))

          Blank(1)
            .onClick(() => {
              this.isShowSetting = false
            })

          // 阅读器-下方弹框
          Column({ space: 20 }) {
            Divider()
            if (!this.isShowContentSetting) {
              Row() {
                Button({ type: ButtonType.Normal }) {
                  Row({
                    space: 4
                  }) {
                    Image($r("app.media.change_source_icon")).width(16).height(16)
                    Text("换源").fontColor($r('app.string.color_black_65'))
                      .font({
                        size: 14,
                        weight: 400
                      })
                  }
                }
                .borderRadius(8)
                .height(40)
                .width("45%")
                .backgroundColor("rgba(0, 0, 0, 0.06)")
                .bindSheet($$this.isShowSource, this.sourceView(), {
                  height: '95%',
                  showClose: false,
                  dragBar: false,
                  maskColor: 'rgba(0,0,0,0.6)',
                  onDisappear: () => {
                    console.log('隐藏')
                  }
                })
                .onClick(() => {
                  this.isShowSource = true
                })

                Button({ type: ButtonType.Normal }) {
                  Row({
                    space: 4
                  }) {
                    Image($r("app.media.purify_icon")).width(16).height(16)
                    Text("净化").fontColor($r('app.string.color_black_65'))
                      .font({
                        size: 14,
                        weight: 400
                      })
                  }
                  .bindSheet($$this.isShowPurification, this.purificationView(), {
                    height: '40%',
                    showClose: false,
                    dragBar: false,
                    maskColor: 'rgba(0,0,0,0.6)',
                    onDisappear: () => {
                      console.log('隐藏')
                    }
                  })
                  .onClick(() => {
                    this.isShowPurification = true
                  })
                }
                .borderRadius(8)
                .height(40)
                .width("45%")
                .backgroundColor("rgba(0, 0, 0, 0.06)")
              }
              .padding({
                top: 12,
                left: 24,
                right: 24
              })
              .justifyContent(FlexAlign.SpaceBetween)
              .width("100%")

              Row({ space: 16 }) {
                Text("上一章").onClick(() => {
                  if (this.CurrentChapters > 0) {
                    this.CurrentChapters--
                  }
                })

                Slider({
                  value: this.CurrentChapters,
                  max: this.TotalChapters - 1,
                  min: 0,
                  step: 1,
                  style: SliderStyle.InSet
                })
                  .selectedColor('rgba(0, 0, 0, 0.04)')
                  .blockSize({ width: 30, height: 30 })
                  .layoutWeight(1)
                  .onChange((value) => {
                    this.CurrentChapters = Number(value.toFixed(0))
                  })

                Text("下一章").onClick(() => {
                  if (this.CurrentChapters < this.TotalChapters - 1) {
                    this.CurrentChapters++
                  }
                })
              }
              .padding({
                left: 24,
                right: 24
              })
              .width("100%")
            } else {
              // 下方-设置
              Column({ space: 24 }) {
                Row({ space: 16 }) {
                  Text('亮度')
                  Slider({
                    value: this.CurrentLuminance,
                    max: 100,
                    min: 0,
                    step: 1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.CurrentLuminance = value
                    })
                  Row() {
                    Text('跟随系统')
                  }
                }

                Row({ space: 16 }) {
                  Text('字号')
                  Slider({
                    value: this.CurrentFontSize,
                    max: 48,
                    min: 12,
                    step: 1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.CurrentFontSize = value
                    })
                  Row() {
                    Button('字体')
                  }
                }

                Row({ space: 16 }) {
                  Text('排版')
                  Button('紧凑')
                    .onClick(() => {
                      this.LineHeight = 1.6
                      this.ParagraphSpacing = -4
                    })
                  Button('适中')
                    .onClick(() => {
                      this.LineHeight = 1.8
                      this.ParagraphSpacing = -2
                    })
                  Button('宽松')
                    .onClick(() => {
                      this.LineHeight = 2
                      this.ParagraphSpacing = 0
                    })
                  Row() {
                    Button('更多')
                      .bindSheet($$this.isShowMoreLayout, this.LayoutMoreDialog(), {
                        height: 500,
                        showClose: false,
                        dragBar: false,
                        blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
                        onDisappear: () => {
                          // this.clickBookType = ''
                        }
                      })
                      .onClick(() => {
                        this.isShowMoreLayout = true
                      })
                  }
                }

                Row({ space: 16 }) {
                  Text('背景')
                  Blank(1)
                  Row() {
                    Button('更多')
                  }
                }

                Row({ space: 16 }) {
                  Button('自动阅读')
                  Button('仿真翻页').onClick(() => {
                    this.turnStyle = FlipPageType.SIMULATE_FLIP_PAGE
                  })
                  Button('更多设置')
                }
              }
              .padding({
                left: 20,
                right: 20
              })

            }
            Grid() {
              GridItem() {
                Column() {
                  Image($r("app.media.ic_public_return_left")).width(24)
                  Text("目录")
                }
              }

              GridItem() {
                Column() {
                  Image($r("app.media.listen")).width(24)
                  Text("听书")
                }
              }
              .bindContentCover($$this.isShowListen, this.BookListen(), {
                modalTransition: ModalTransition.DEFAULT,
                backgroundColor: "rgba(51, 106, 128, 0.75)"
              })
              .onClick(() => {
                this.isShowListen = true
              })

              GridItem() {
                Column() {
                  Image($r("app.media.night_icon")).width(24)
                  Text("夜间")
                }
              }

              GridItem() {
                Column() {
                  Image($r(this.isShowContentSetting ? "app.media.my_center_set_icon_fill" :
                    "app.media.my_center_set_icon"))
                    .width(24)
                  Text("设置")
                }
                .onClick(() => {
                  this.isShowContentSetting = !this.isShowContentSetting
                })
              }
            }
            .padding({
              left: 24,
              right: 24
            })
            .columnsTemplate("1fr 1fr 1fr 1fr")
            .width("100%")
            .height(60)
          }
          .backgroundColor("white")
          .transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 500 }))
        }
      }
      .width("100%")
      .height("100%")
      .zIndex(2)
      .enabled(this.isShowSetting)

      // 阅读器-小说内容
      Row() {
        Row() {
          if (this.turnStyle === FlipPageType.COVER_FLIP_PAGE) {
            CoverFlipView({
              currentChapterNum: this.currentChapterNum,
              currentPageNum: this.currentPageNum,
            })
          }
          if (this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE) {
            SimulateCurlView({
              currentChapterNum: this.currentChapterNum,
              currentPageNum: this.currentPageNum,
            })
          }
          if (this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE) {
            SlideFlipView({
              currentChapterNum: this.currentChapterNum,
              currentPageNum: this.currentPageNum,
            })
          }
          if (this.turnStyle === FlipPageType.UP_DOWN_FLIP_PAGE) {
            UpDownFlipView({
              currentChapterNum: this.currentChapterNum,
              currentPageNum: this.currentPageNum,
            })
          }
        }.width(Constants.FULL_PERCENT)
        .height(Constants.FULL_PERCENT)
      }
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
      .backgroundColor(this.bgColor)
      .padding({
        top: 16,
        bottom: 16,
      })
      .onClick((event?: ClickEvent) => {
        if (event) {
          if (event.x > this.screenW / 3 * 2) {
            if (this.turnStyle != FlipPageType.UP_DOWN_FLIP_PAGE) {
              promptAction.showToast({
                message: Constants.MSG_FLIP_RIGHT,
                duration: Constants.PROMPT_DURATION
              });
              this.clickAnimateTo(false);
            }
          } else if (event.x < this.screenW / 3) {
            if (this.turnStyle != FlipPageType.UP_DOWN_FLIP_PAGE) {
              if (this.CurrentChapters == 0 && this.CurrentPage == 0) {
                promptAction.showToast({
                  message: Constants.MSG_FLIP_OVER,
                  duration: Constants.PROMPT_DURATION
                })
              } else {
                promptAction.showToast({
                  message: Constants.MSG_FLIP_LEFT,
                  duration: Constants.PROMPT_DURATION
                });
                this.clickAnimateTo(true);
              }
            }
          } else {
            this.isShowSetting = true
          }
        }
      })

    }
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight
    })
    .height('100%')
    .width('100%')
  }

  @Builder
  sourceView() {
    Column() {
      Column() {
        Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
      }
      .padding({ top: 12 })

      sourceView()
    }
  }

  @Builder
  purificationView() {
    Column() {
      purificationView({
        isShowPurification: this.isShowPurification
      })
    }
  }

  @Builder
  DialogString() {
    Row() {
      Text("喜欢就加入书架吧")
        .lineHeight(22)
        .font({
          size: 14,
          weight: 400
        })
        .fontColor($r("app.string.color_black_45"))
    }
    .margin({
      top: 12,
      bottom: 16
    })
  }

  onBackPress() {
    // this.dialogController.open();
    return false
  }

  @Builder
  BookListen() {
    MusicPlayer({ WidthMinus: 118, isShowListen: this.isShowListen })
      .width("100%")
      .height("100%")
  }

  @Builder
  DownloadDialog() {
    Column() {
      DownloadSettingDialog({
        isShowDownload: this.isShowDownload,
        isShowSetting: this.isShowSetting,
      })
    }
  }

  @Builder
  LayoutMoreDialog() {
    LayoutMoreDialog({ ReaderPadding: this.ReaderPadding })
      .height(500)
      .width("100%")
  }
}
