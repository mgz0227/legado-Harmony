
import { display, promptAction, router, SwipeRefresher, window } from '@kit.ArkUI';
import sourceView from './sourceView';
import { NetworkInput } from 'ets/componets/Reader/NetworkInput';
import DownloadSettingDialog from '../../../componets/Reader/DownloadSettingDialog';
import LayoutMoreDialog from '../../../componets/Reader/LayoutMoreDialog';
import { MusicPlayer } from 'ets/componets/Reader/MusicPlayer';
import purificationView from './purificationView';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { BookList } from 'ets/componets/dataList/bookList';
import { CoverFlipView, } from '@ohos/readerLibrary';
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
import {
  ReaderChapterItem,
} from '@ohos/readerLibrary/src/main/ets/common/entity/ReaderChaptersItem';
import { ReaderProvider } from '@ohos/readerLibrary/src/main/ets/provider/configProvider';
import CommonConstants from '../../../common/constants/CommonConstants';
import { ThemeItem } from '../../../common/model/Theme';
import { ThemeStorageKey } from '../../../common/constants/Theme';
import NoteIndex from '../../../componets/bookDetail/note/NoteIndex';
import { BookHistory } from '../../../database/entities/BookHistory';
import bookHistoryUtils from '../../../common/utils/BookHistoryUtils';
import { Books } from '../../../database/entities/Books';
import { FileHandler } from '../../../common/utils/FileHandler';
import ChaptersDataSource from '../../../common/LazyIDataSource/ChaptersDataSource';


interface ParamsObj {
  bookData: Books,
  clickBookChapter: number,
  txtFile: chaptersItem[]
}

@Entry
@Component
struct ReaderPage2 {
  currentChapters: number = 0
  chapterList: ReaderChapterItem[] = [];
  bookData?: Books;
  async aboutToAppear() {
    //详情页加了个目录序号参数，所以修改了一下params的类型，不影响之前的bookData，但需要多‘.’一次。看看大佬们可以怎么优化一下，上个页面BookDetailPage
    let temp = router.getParams() as ParamsObj
    this.bookData = temp.bookData
    // console.log('router ReaderPage2:' + temp.bookData.fileLink)
    this.chapterList = temp.txtFile.map((value) => {
      return new ReaderChapterItem(value.number, value.title, value.chapterTitleNumber, value.content);
    }) //txt小说

    if (this.chapterList.length != 0) {
      this.chapterList[0].paragraphList = this.chapterList[0].content.split('\n').map((value) => value + '\n');
    }

    if (this.chapterList.length >= 2) {
      for (let index = 1; index < this.chapterList.length; index++) {
        this.chapterList[index].paragraphList = this.chapterList[index].content.split('\n').map((value) => value + '\n');
      }
    }
    this.currentChapters = temp.clickBookChapter

    this.changeSystemBarStatue();
  }


  changeSystemBarStatue(): void {
    window.getLastWindow(getContext(this), (err, data) => {
      const errCode = err.code;
      if (errCode) {
        return;
      }
      let SystemBarProperties: window.SystemBarProperties = {
        statusBarColor: BG_COLOR_ARRAY[BGColorType.WHITE],
        navigationBarColor: BG_COLOR_ARRAY[BGColorType.WHITE],
        navigationBarContentColor: Constants.TRANSPARENT
      };
      try {
        data.setWindowSystemBarProperties(SystemBarProperties, (err: BusinessError) => {
          const errCode: number = err.code;
          if (errCode) {
            console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
            return;
          }
          data.setWindowBackgroundColor(BG_COLOR_ARRAY[BGColorType.WHITE]);
        });
      } catch (exception) {
        console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(exception));
      }
    });
  }

  onBgColorChanged() {
    this.changeSystemBarStatue();
  }

  build() {
    Row() {
      ReaderProvider({
        chapterList: this.chapterList,
        child: this.contentBuilder,
        bookData: this.bookData,
        currentChapterIndex: this.currentChapters
      })
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  contentBuilder() {
    Row() {
      ContentContainer()
    }
  }
}

// 好像因为层级结构的关系，这块需要包裹一个控件，ReaderPageContent才可以获取到Provider提供的部分。
// todo：研究确认一下
@Component
struct ContentContainer {
  build() {
    Row() {
      ReaderPageContent()
    }
  }
}

@Component
struct ReaderPageContent {
  @State isShowCatalogue: boolean = false;
  @State currentIndex: number = 0;
  @State isShowSetting: boolean = true
  @State isShowContentSetting: boolean = false
  @State isShowDownload: boolean = false
  @State isShowListen: boolean = false
  @State isShowMoreLayout: boolean = false
  @State isFontChanged: boolean = false
  @State isShowSource: boolean = false
  @State isShowPurification: boolean = false
  @State screenH: number = 0
  @State screenW: number = 0
  @State readerPadding: number = 24 // 边距
  @Consume('fontSize') fontSize: number
  @Consume('lineHeightRatio') lineHeightRatio: number
  @Consume('bgColor') bgColor: string
  @Consume('chapterList') chapterList: ReaderChapterItem[]
  @Consume('turnStyle') turnStyle: FlipPageType
  @Consume('currentPageIndex') @Watch('onFlush') currentPageIndex: number
  @Consume('paragraphSpacing') paragraphSpacing: number
  @Consume('currentChapterIndex') currentChapterIndex: number
  @Consume('currentLuminance') currentLuminance: number
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State txtFile: ChaptersDataSource = new ChaptersDataSource()
  @Consume('bookData') bookData: Books
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  aboutToAppear(): void {
    this.screenW = px2vp(display.getDefaultDisplaySync().width);
    this.screenH = px2vp(display.getDefaultDisplaySync().height - (AppStorage.get('avoidHeight') as number));
    this.txtFile.pushAllData(this.chapterList)
  }

  get totalChapter(): number {
    return this.chapterList.length;
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
              Text(`${this.chapterList[this.currentChapterIndex]?.chapterTitleNumber} ${this.chapterList[this.currentChapterIndex]?.title}`
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
              if (this.isShowCatalogue) {
                this.isShowCatalogue = false
                return
              }
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
                  if (this.currentChapterIndex > 0) {
                    this.currentChapterIndex--
                  }
                })

                Slider({
                  value: this.currentChapterIndex,
                  max: this.totalChapter - 1,
                  min: 0,
                  step: 1,
                  style: SliderStyle.InSet
                })
                  .selectedColor('rgba(0, 0, 0, 0.04)')
                  .blockSize({ width: 30, height: 30 })
                  .layoutWeight(1)
                  .onChange((value) => {
                    this.currentChapterIndex = Number(value.toFixed(0))
                  })

                Text("下一章").onClick(() => {
                  if (this.currentChapterIndex < this.totalChapter - 1) {
                    this.currentChapterIndex++
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
                    value: this.currentLuminance,
                    max: 100,
                    min: 0,
                    step: 1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.currentLuminance = value
                    })
                  Row() {
                    Text('跟随系统')
                  }
                }

                Row({ space: 16 }) {
                  Text('字号')
                  Slider({
                    value: this.fontSize,
                    max: 48,
                    min: 12,
                    step: 1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.fontSize = value
                    })
                  Row() {
                    Button('字体')
                  }
                }

                Row({ space: 16 }) {
                  Text('排版')
                  Button('紧凑')
                    .onClick(() => {
                      this.lineHeightRatio = 1.6
                      this.paragraphSpacing = 0
                    })
                  Button('适中')
                    .onClick(() => {
                      this.lineHeightRatio = 1.8
                      this.paragraphSpacing = 2
                    })
                  Button('宽松')
                    .onClick(() => {
                      this.lineHeightRatio = 2
                      this.paragraphSpacing = 4
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
                  Image($r("app.media.catalogue")).width(24)
                  Text("目录")
                }
              }
              .onClick(() => {
                this.isShowCatalogue = true
              })

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
              currentChapterIndex: this.currentChapterIndex,
              currentPageIndex: this.currentPageIndex,
            })
          }
          if (this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE) {
            SimulateCurlView({
              currentChapterIndex: this.currentChapterIndex,
              currentPageIndex: this.currentPageIndex,
            })
          }
          if (this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE) {
            SlideFlipView({
              currentChapterNum: this.currentChapterIndex,
              currentPageNum: this.currentPageIndex,
            })
          }
          if (this.turnStyle === FlipPageType.UP_DOWN_FLIP_PAGE) {
            UpDownFlipView({
              currentChapterNum: this.currentChapterIndex,
              currentPageNum: this.currentPageIndex,
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
              if (this.currentChapterIndex == 0 && this.currentPageIndex == 0) {
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
    .bindSheet($$this.isShowCatalogue, this.catalogPanel(), {
      detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
      backgroundColor: '#FFFFFF',
      showClose: false,
      dragBar: true,
      enableOutsideInteractive: true,
    })

  }

  private clickAnimateTo(isLeft: Boolean) {
    // if (this.turnStyle === FlipPageType.COVER_FLIP_PAGE) {
    //   animateTo({
    //     duration: Constants.COVER_DURATION,
    //     curve: Curve.EaseOut,
    //     onFinish: () => {
    //       if (this.offsetX > 0) {
    //         this.currentPageNum > 0 ? this.currentPageNum - 1 : this.currentPageNum;
    //         this.currentChapterIndex -= this.sumRow * this.rowWord;
    //       } else if (this.offsetX < 0) {
    //         this.currentPageNum += 1;
    //         this.currentChapterIndex += this.sumRow * this.rowWord;
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
    //         this.currentChapterIndex -= this.sumRow * this.rowWord;
    //       } else {
    //         this.currentChapterIndex += this.sumRow * this.rowWord;
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
    //         this.currentChapterIndex -= this.sumRow * this.rowWord;
    //       }
    //       if (this.offsetX < 0) {
    //         this.currentPageNum += 1;
    //         this.currentChapterIndex += this.sumRow * this.rowWord;
    //       }
    //       console.info(this.currentChapterIndex.toString());
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

  onFlush() {
    console.info('currentPageNum=' + this.currentPageIndex + ', isFontChanged=' + this.isFontChanged);
    if (this.isFontChanged && this.currentPageIndex === 0) {
      this.isFontChanged = false;
      this.currentPageIndex = 0;
    }
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
    LayoutMoreDialog({ ReaderPadding: this.readerPadding })
      .height(500)
      .width("100%")
  }

  /**
   * tab页签
   */
  @Builder
  catalogTab(index: number, name: string, count: number) {
    Column() {
      Row() {
        Text(name)
          .fontSize(16)
          .fontColor(this.currentIndex === index ? '#e0000000' : '#73000000')
          .fontWeight(500)
          .lineHeight(24)
        Text(count.toString())
          .fontSize(12)
          .lineHeight(20)
          .fontColor(this.currentIndex === index ? '#e0000000' : '#73000000')
          .fontWeight(500)
      }

      Divider()
        .width(10)
        .strokeWidth(3)
        .lineCap(LineCapStyle.Round)
        .color(this.theme.mainColor)
        .opacity(this.currentIndex === index ? 1 : 0)
    }
    .padding({ top: 8, bottom: 8 })
    .width(59)
    .height(40)
  }

  /**
   * Panel
   */
  @Builder
  catalogPanel() {
    Column() {
      Search({ placeholder: '搜索目录' })
        .height(34)
        .padding({ top: 8, bottom: 8 })
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Column() {
            if (this.chapterList.length === 0 || undefined) {
              SwipeRefresher({
                content: '目录加载中...',
                isLoading: true
              })
            } else {
              List() {
                LazyForEach(this.txtFile, (item: ReaderChapterItem, index: number) => {
                  ListItem() {
                    Button({ type: ButtonType.Normal }) {
                      Row() {
                        Text(`${item.chapterTitleNumber} ${item.title}`
                          .replace(new RegExp('\\s{1,}', 'g'), ' ')
                          .replaceAll('=', ''))
                          .layoutWeight(1)
                      }
                      .width('100%')
                      .padding({
                        left: 20,
                        right: 20,
                        top: 12,
                        bottom: 12
                      })
                    }
                    .borderRadius(10)
                    .width('100%')
                    .backgroundColor(Color.White)
                    .onClick(() => {
                      // 跳转到阅读器
                      router.replaceUrl({
                        url: 'pages/view/Reader/ReaderPage2',
                        //跳转到对应的章节，传index过去，对面TotalChapters接收
                        params: {
                          bookData: this.bookData,
                          clickBookChapter: index,
                          txtFile: this.chapterList.map((value) => new chaptersItem(value.number, value.title, value.chapterTitleNumber, value.content))
                        }
                      })
                      if (this.chapterList && this.chapterList[index]) {
                        this.jumpReadPage(`${item.chapterTitleNumber} ${item.title}`,index, this.bookData)
                      }
                    })
                  }
                })

              }
              .chainAnimation(true)
              .edgeEffect(EdgeEffect.Fade)
              .divider({
                strokeWidth: 0.8,
                color: '#cccccc',
                startMargin: 12,
                endMargin: 12
              })
            }
          }
        }
        .tabBar(this.catalogTab(0, '目录', this.chapterList.length))

        TabContent() {
          Column() {
            SwipeRefresher({
              content: '书源加载中...',
              isLoading: true
            })
          }
        }
        .tabBar(this.catalogTab(1, '书源', 24))

        TabContent() {
          NoteIndex()
        }
        .tabBar(this.catalogTab(2, '笔记', 7))
      }
      .layoutWeight(1)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .padding({ left: 20, right: 20, bottom: 12 })
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .borderRadius(16)
  }

  // @StorageLink('BOOK_IS_BOOK_HISTORY_REFRESHING') isBookHistoryRefreshing: number = 0
  //跳转阅读界面更新或者添加阅读历史记录方法
  async jumpReadPage(durChapterTitle:string,durChapterIndex:number, bookData: Books) {
    let bookHistory = new BookHistory()
    bookHistory.id = bookData.id
    bookHistory.bookName = bookData.bookName
    bookHistory.author = bookData.author
    bookHistory.durChapterTime = Date.now()
    bookHistory.bookType = bookData.bookType
    bookHistory.bookUrl = bookData.bookUrl??''
    bookHistory.coverUrl = bookData.coverUrl??''
    bookHistory.originBookId = bookData.id
    bookHistory.durChapterTitle = durChapterTitle
    bookHistory.durChapterIndex = durChapterIndex
    bookHistoryUtils.addBooks(bookHistory)
  }
}