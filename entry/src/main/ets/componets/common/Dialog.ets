@CustomDialog
  // 通用弹窗
export default struct Dialog {
  controller?: CustomDialogController;
  @Prop title: string = '标题'
  @Prop CancelString: string = "取消"
  @Prop ConfirmString: string = "确定"
  @BuilderParam child: () => void // 通用组件

  build() {
    Column() {
      Row() {
        Text(this.title)
          .lineHeight(26)
          .font({
            size: 18,
            weight: 500
          })
      }


      this.child()
      // Row() {
      //   TextInput({ placeholder: this.placeholder })
      //     .maxLength(this.maxlength)
      //     .showCounter(true)
      //     .cancelButton({
      //       icon: {
      //         src: $r('app.media.close')
      //       }
      //     })
      // }
      // .margin({
      //   top: 16,
      //   bottom: 16
      // })

      Flex({
        justifyContent: FlexAlign.SpaceEvenly,
        alignItems: ItemAlign.Center
      }) {
        Button() {
          Text(this.CancelString)
            .fontColor("#FF6600")
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500
            })
        }
        .width(112)
        .height(38)
        .backgroundColor("rgba(255, 102, 0, 0.12)")
        .onClick(() => {
          if (this.controller != undefined) {
            this.controller.close()
          }
        })

        Button() {
          Text(this.ConfirmString)
            .fontColor("#FFFFFF")
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500
            })
        }
        .width(112)
        .height(38)
        .backgroundColor("#FF6600")
        .onClick(() => {

        })
      }
    }
    .padding({
      top: 24,
      bottom: 24,
      left: 24,
      right: 24
    })
  }
}