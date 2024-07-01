import battery from 'ets/componets/common/battery';
import Dialog from 'ets/componets/common/Dialog';
import { router } from '@kit.ArkUI';
import sourceView from './sourceView';
import { FileHandler } from 'ets/common/utils/FileHandler';
import { NetworkInput } from 'ets/componets/Reader/NetworkInput';
import { LengthMetrics } from '@ohos.arkui.node';
import DownloadSettingDialog from './DownloadSettingDialog';
import { MusicPlayer } from 'ets/componets/MusicPlayer';
import purificationView from './purificationView';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { BookList } from 'ets/componets/dataList/bookList';

@Entry
@Component
struct ReaderPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State isShowSetting: boolean = true
  @State isShowDownload: boolean = false
  @State isShowListen: boolean = false
  @State isShowContentSetting: boolean = false
  @State CurrentChapters: number = 0
  @State TotalChapters: number = 0
  @State CurrentLuminance: number = 0 // 亮度
  @State CurrentFontSize: number = 20 // 字号
  @State LineHeight: string = "180%"
  @State ParagraphSpacing: number = -2
  @State isShowSource: boolean = false
  @State isShowPurification: boolean = false
  @State txtFile: chaptersItem[] = [];
  scroller: Scroller = new Scroller()

  async onPageShow() {
    let temp = router.getParams() as BookList
    console.log('router ReaderPage:' + temp.fileLink)
    this.txtFile = await FileHandler.readFile(temp.fileLink) //txt小说
    this.TotalChapters = this.txtFile.length
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
              Text(`${this.txtFile[this.CurrentChapters]?.chapterTitleNumber} ${this.txtFile[this.CurrentChapters]?.title}`.replace(new RegExp('\\s{1,}','g'),' ').replaceAll('=',''))
                .layoutWeight(1)
                .maxLines(1)
                .textOverflow({overflow:TextOverflow.Ellipsis})
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
                    this.CurrentChapters = value
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
                    max: 30,
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
                      this.LineHeight = "160%"
                      this.ParagraphSpacing = -4
                    })
                  Button('适中')
                    .onClick(() => {
                      this.LineHeight = "180%"
                      this.ParagraphSpacing = -2
                    })
                  Button('宽松')
                    .onClick(() => {
                      this.LineHeight = "200%"
                      this.ParagraphSpacing = 0
                    })
                  Row() {
                    Button('更多')
                  }
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
                  Image($r("app.media.my_center_set_icon")).width(24)
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
      Column() {
        Row() {
        }
        .width("100%")
        .height(40)

        Scroll(this.scroller) {
          Column() {
            Row() {
              Text(`${this.txtFile[this.CurrentChapters]?.chapterTitleNumber} ${this.txtFile[this.CurrentChapters]?.title}`.replace(new RegExp('\\s{1,}','g'),' ').replaceAll('=',''))
                .lineHeight(20)
                .font({
                  size: 15,
                  weight: 700
                })
                .fontColor("rgba(0, 0, 0, 0.88)")
            }
            .padding({
              top: 16,
              bottom: 16,
              left: 24,
              right: 24
            })
            .width("100%")

            Text(this.txtFile[this.CurrentChapters]?.content)
              .lineHeight(this.LineHeight)
              .font({
                size: this.CurrentFontSize, // 用px感觉太小了，用vp算了
                weight: 400
              })
              .lineSpacing(LengthMetrics.vp(this.CurrentFontSize + this.ParagraphSpacing))
              .fontColor("rgba(0, 0, 0, 0.88)")
              .width("100%")
          }
          .padding({
            left: 24,
            right: 24
          })
        }
        .layoutWeight(1)


        Blank(1)
        Row({ space: 4 }) {
          Text("1/14  0.1%")
          Blank(1)
          TextClock({ timeZoneOffset: -8 })
            .format('hh:mm')
            .fontSize(12)
            .fontWeight(400)
          battery()
        }
        .padding({
          top: 16,
          bottom: 16,
          left: 24,
          right: 24
        })
        .width("100%")

      }
      .height("100%")
      .onClick(() => {
        this.isShowSetting = true
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

  onBackPress() {
    this.dialogController.open();
    return true
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
}
