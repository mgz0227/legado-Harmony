import router from '@ohos.router'

@Entry
@Component
struct PrivacyAgreementPage {
  build() {
    Column({ space: 16 }) {
      Row() {
        Image($r("app.media.return_left"))
          .position({ x: 0, y: 2 })
          .size({ width: 24, height: 24 })
          .interpolation(ImageInterpolation.Medium)
          .onClick(() => {
            router.back()
          })
        Blank(20)
        Text("免责声明")
          .lineHeight(24)
          .font({
            family: "PingFang SC",
            size: 16,
            weight: 500,
            style: FontStyle.Normal,
          })
        Blank(20)
      }
      .padding({
        top: 12,
        bottom: 12,
      })
      .height(48)
      .width("100%")

      Row() {
        Text("免责声明（Disclaimer）\n\n阅读是一款解析指定规则并获取内容的工具，为广大网络文学爱好者提供一种方便、快捷舒适的试读体验。")
          .lineHeight(22)
          .font({
            family: "PingFang SC",
            size: 14,
            style: FontStyle.Normal,
            weight: 400,
          })
      }.width("100%").margin({ top: 12 })

    }
    .height("100%")
    .padding({
      left: 20,
      right: 20
    })
    .backgroundColor("rgb(245, 245, 245)")
  }
}