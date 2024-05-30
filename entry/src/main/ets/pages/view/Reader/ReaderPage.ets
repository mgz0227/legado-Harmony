import battery from 'ets/componets/common/battery'
import Dialog from 'ets/componets/common/Dialog'

@Entry
@Component
struct ReaderPage {
  @State isShowSetting: boolean = false
  // 网址导入dialog
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
          Row() {
            Image($r("app.media.ic_public_return_left")).width(24)
            Text("第一章 牢狱之灾")
          }
          .width("100%")
        }
        .padding({
          top: 12,
          left: 24,
          right: 24
        })
        .zIndex(2)
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
              Row() {
                Button({ type: ButtonType.Normal }) {
                  Row() {
                    Image($r("app.media.ic_public_return_left")).width(24)
                    Text("换源")
                  }

                }
                .borderRadius(8)
                .height(40)
                .width("45%")
                .backgroundColor("rgba(0, 0, 0, 0.06)")

                Button({ type: ButtonType.Normal }) {
                  Row() {
                    Image($r("app.media.ic_public_return_left")).width(24)
                    Text("净化")
                  }
                }
                .borderRadius(8)
                .height(40)
                .width("45%")
                .backgroundColor("rgba(0, 0, 0, 0.06)")
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width("100%")

              Row() {
                Text("上一章")
                Blank(1)
                Progress({ value: 50 }).width("50%")
                Blank(1)
                Text("下一章")
              }
              .width("100%")

              Row() {
                Image($r("app.media.ic_public_return_left")).width(24)
                Text("第一章 牢狱之灾")
              }
              .width("100%")
              .height(60)
            }
            .backgroundColor("white")
            .padding({
              top: 12,
              left: 24,
              right: 24
            })
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
    .alignContent(Alignment.TopStart)
    .height('100%')
    .width('100%')
  }

  onBackPress() {
    this.dialogController.open();
    return true
  }
}