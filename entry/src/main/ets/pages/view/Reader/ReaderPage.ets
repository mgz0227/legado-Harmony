import battery from 'ets/componets/common/battery';
import Dialog from 'ets/componets/common/Dialog';
import { router } from '@kit.ArkUI';
import sourceView from './sourceView';
import { readFile } from 'ets/common/utils/readFile';
import { AddDownloadDialog } from 'ets/componets/Reader/AddDownloadDialog';
import { NetworkInput } from 'ets/componets/Reader/NetworkInput';

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
  @State isShowSource: boolean = false

  onPageShow(): void {
    let temp = router.getParams()
    console.log('router' + JSON.stringify(temp))
    readFile()
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
      if (this.isShowSetting) {
        Column() {
          Row({ space: 8 }) {
            Image($r("app.media.ic_public_return_left"))
              .width(24)
              .onClick(() => {
                router.back()
              })
            Text("第一章 牢狱之灾")
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
      Column() {
        Row() {
        }
        .width("100%")
        .height(40)

        Row() {
          Text("第一章 牢狱之灾")
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

              Row() {
                Text("上一章")
                Blank(1)
                Progress({ value: 50 }).width("50%")
                Blank(1)
                Text("下一章")
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
                .bindContentCover($$this.isShowListen, this.listenBuilder(), {
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
            .zIndex(2)
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

  onBackPress() {
    this.dialogController.open();
    return true
  }

  @Builder
  listenBuilder() {
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

      Column({ space: 24 }) {
        Row() {

        }

        Row() {

        }

        Row() {

        }

        Row() {

        }
      }
    }
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight,
      left: 20,
      right: 20
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
