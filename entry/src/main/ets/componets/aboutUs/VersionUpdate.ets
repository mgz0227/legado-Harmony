@CustomDialog
export default struct VersionUpdateCustomDialog {
  controller: CustomDialogController
  @State clickUpdate: boolean = false
  @State ProgressValue: number = 40

  build() {
    Column() {
      Row({ space: 12 }) {
        Text('发现新版本')
          .lineHeight(32)
          .fontColor("#000000")
          .font({
            family: "PingFang SC",
            size: 24,
            style: FontStyle.Normal,
            weight: 500,
          })
        Text('v4.1.14')
          .lineHeight(32)
          .fontColor("#000000")
          .font({
            family: "PingFang SC",
            size: 16,
            style: FontStyle.Normal,
            weight: 500,
          })
      }
      .padding({
        top: 32,
        left: 24,
        right: 24
      })
      .height(76)
      .width("100%")
      .backgroundImage($r('app.media.versionUpdateBackground'))
      .backgroundImageSize({ width: "100%", height: 76 })

      Column() {
        Row() {
          Text("首页风格改版，更全面的内容，恍然一新的视觉用户体验")
        }

        Row() {
          Text("优化了动画细节，让产品更流畅。")
        }
      }
      .alignItems(HorizontalAlign.Start)
      .width("100%")
      .padding({
        top: 12,
        left: 24,
        right: 24
      })

      if (!this.clickUpdate) {
        Button("立即更新")
          .backgroundColor("#FF6600")
          .width("73%")
          .margin({
            top: 24,
            bottom: 16
          })
          .onClick(() => {
            this.clickUpdate = true
          })
      } else {
        Progress({
          value: this.ProgressValue,
          total: 100,
          type: ProgressType.Capsule,
        })
          .style({
            content: `正在更新（${this.ProgressValue}%）`,
            fontColor: "#FFFFFF",
            font: ({
              family: "PingFang SC",
              size: 14,
              style: FontStyle.Normal,
              weight: 400,
            })
          })
          .width("73%")
          .color("#FF6600")
          .backgroundColor("#FFAF7A")
          .margin({
            top: 24,
            bottom: 16
          })

      }

      Text(!this.clickUpdate ? "暂不更新" : "后台下载")
        .lineHeight(22)
        .fontColor("#000000")
        .opacity(0.45)
        .font({
          family: "PingFang SC",
          size: 14,
          style: FontStyle.Normal,
          weight: 400,
        })
        .margin({
          bottom: 24
        })
        .onClick(() => {
          if (!this.clickUpdate) {
            this.controller.close()
          }
        })
    }
  }
}