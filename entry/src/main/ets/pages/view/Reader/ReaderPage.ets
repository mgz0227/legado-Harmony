import battery from 'ets/componets/common/battery';
import Dialog from 'ets/componets/common/Dialog';
import { router } from '@kit.ArkUI';
import sourceView from './sourceView';
import { FileHandler } from 'ets/common/utils/FileHandler';
import { AddDownloadDialog } from 'ets/componets/Reader/AddDownloadDialog';
import { NetworkInput } from 'ets/componets/Reader/NetworkInput';

import { MusicPlayer } from 'ets/componets/MusicPlayer';
import purificationView from './purificationView';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { BookList } from 'ets/componets/dataList/bookList'

@Entry
@Component
struct ReaderPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State isShowSetting: boolean = true
  @State isShowDownload: boolean = false
  @State isShowListen: boolean = false
  @State StartText: string = "1"
  @State EndText: string = "2"
  @State CurrentChapters: number = 0
  @State TotalChapters: number = 0
  controller: TextInputController = new TextInputController()
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
  // 加入下载列表Dialog
  DownloadDialogController: CustomDialogController = new CustomDialogController({
    builder: AddDownloadDialog(),
    cornerRadius: 8,
    offset: { dx: 0, dy: -100 }
  })
  scroller: Scroller = new Scroller()
  @State isShowSource: boolean = false
  @State isShowPurification: boolean = false
  @State txtFile: chaptersItem[] = [];

  async onPageShow() {
    let temp = router.getParams() as BookList
    console.log('router ReaderPage:' + temp.fileLink)
    this.txtFile = await FileHandler.readFile(temp.fileLink) //txt小说
    this.TotalChapters = this.txtFile.length
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

  build() {
    Stack() {
      // 阅读器-上方弹框
      if (this.isShowSetting) {
        Column() {
          Row({ space: 8 }) {
            Image($r("app.media.ic_public_return_left"))
              .width(24)
              .onClick(() => {
                router.back()
              })
            Text(`第${this.txtFile[this.CurrentChapters]?.chapterTitleNumber}章 ${this.txtFile[this.CurrentChapters]?.title}`)
            Blank(1)
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
                .bindSheet($$this.isShowDownload, this.ExportSettingDialog(), {
                  height: 326,
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
        .zIndex(2)
        .backgroundColor("white")
        .transition(TransitionEffect.move(TransitionEdge.TOP).animation({ duration: 500 }))
      }

      // 阅读器-小说内容
      Column() {
        Row() {
        }
        .width("100%")
        .height(40)

        Scroll(this.scroller) {
          Column() {
            Row() {
              Text(this.txtFile[this.CurrentChapters]?.title)
                .lineHeight(20)
                .font({
                  size: 12,
                  weight: 400
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
              .lineHeight(20)
              .font({
                size: 12,
                weight: 400
              })
              .fontColor("rgba(0, 0, 0, 0.88)")
          }
          .padding({
            left: 24,
            right: 24
          })
        }
        // .scrollable(ScrollDirection.Horizontal)
        .layoutWeight(1)


        Blank(1)
        Stack() {
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

          // 阅读器-下方弹框
          if (this.isShowSetting) {
            Column({ space: 20 }) {
              Divider()
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

                Blank(1)
                Progress({ value: this.CurrentChapters, total: this.TotalChapters - 1 }).layoutWeight(1)
                Blank(1)

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
            // .zIndex(2)
            .onClick(() => {
              // 这里必须有onclick，不然点击弹窗会消失，走下面的onclick逻辑
            })
          }
        }
        .alignContent(Alignment.Bottom)
      }
      .height("100%")
      .onClick(() => {
        this.isShowSetting = !this.isShowSetting
      })
    }
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight
    })
    .alignContent(Alignment.TopStart)
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

  onBackPress() {
    this.dialogController.open();
    return true
  }

  @Builder
  BookListen() {
    Column() {
      Row() {
        Image($r("app.media.direction_down")).width(24)
          .onClick(() => {
            this.isShowListen = false
          })
        Blank(1)
        Text("大奉打更人")
          .lineHeight(24)
          .fontColor("#FFFFFF")
          .font({
            size: 16,
            weight: 500
          })
        Blank(1)
        Image($r("app.media.more")).width(24)
      }
      .height(48)
      .width("100%")


      Blank(1)
      Column() {
        Row() {
          Text("第1章 牢狱之灾")
        }

        Row() {
          Text("卖报小郎君")
          Button("搜作者")
        }

        Row() {
          Text("许七安幽幽醒来，嗅到了空气中潮湿的腐臭")
        }
      }

      MusicPlayer({ WidthMinus: 118 })
    }
    .width("100%")
    .height("100%")
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight,
      left: 24,
      right: 24
    })
  }

  @Builder
  ExportSettingDialog() {
    Column() {
      Grid() {
        GridItem() {
          Row() {
            Text("缓存后50章")
            Blank(1)
            Checkbox()
          }
          .width("100%")
        }

        GridItem() {
          Row() {
            Text("缓存后面全部章节")
            Blank(1)
            Checkbox()
          }
          .width("100%")
        }

        GridItem() {
          Row() {
            Text("缓存全部")
            Blank(1)
            Checkbox()
          }
          .width("100%")
        }

        GridItem() {
          Row() {
            Text("自定义缓存")
            Blank(1)
            Checkbox()
          }
          .width("100%")
        }

        GridItem() {
          Row({ space: 16 }) {
            TextInput({ text: this.StartText, controller: this.controller })
              .type(InputType.Number)
              .width(107)
              .height(38)
              .borderRadius(8)
              .fontSize(20)
              .fontWeight(400)
              .lineHeight(22)
              .textAlign(TextAlign.Center)
              .backgroundColor("white")
              .border({
                width: 1,
                color: "gray"
              })
              .onChange((value: string) => {
                this.StartText = value
              })

            Text("至")

            TextInput({ text: this.EndText, controller: this.controller })
              .type(InputType.Number)
              .width(107)
              .height(38)
              .borderRadius(8)
              .fontSize(20)
              .fontWeight(400)
              .lineHeight(22)
              .textAlign(TextAlign.Center)
              .backgroundColor("white")
              .border({
                width: 1,
                color: "gray"
              })
              .onChange((value: string) => {
                this.EndText = value
              })
          }
          .width("100%")
        }
      }
      .padding({
        top: 16
      })
      .height("80%")
      .columnsTemplate("1fr")
      .rowsTemplate("1fr 1fr 1fr 1fr 1fr")

      Blank(1)
      Grid() {
        GridItem() {
          Button() {
            Text("取消")
              .lineHeight(24)
              .fontColor($r('app.string.ThemeColor'))
              .font({
                size: 16,
                weight: 500
              })
          }
          .width("80%")
          .height(40)
          .backgroundColor($r('app.string.BackgroundThemeColor'))
        }

        GridItem() {
          Button() {
            Text("确定")
              .fontColor("white")
              .lineHeight(24)
              .font({
                size: 16,
                weight: 500
              })
          }
          .width("80%")
          .height(40)
          .backgroundColor($r('app.string.ThemeColor'))
          .onClick(() => {
            this.isShowDownload = false
            this.isShowSetting = false
            this.DownloadDialogController.open()
            setTimeout(() => {
              this.DownloadDialogController.close()
            }, 1000)
          })
        }
      }
      .height(64)
      .columnsTemplate("1fr 1fr")
      .rowsTemplate("1fr")
      .width("100%")
      .onClick(() => {
        this.isShowDownload = false
      })
      .padding({
        top: 12,
        bottom: 12
      })
    }
    .height("100%")
    .padding({
      left: 20,
      right: 20
    })
  }
}
