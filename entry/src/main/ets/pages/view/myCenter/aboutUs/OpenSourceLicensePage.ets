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
        Text("开源许可")
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

      Row(){
        Text("GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007\nCopyright (C) 2007 Free Software Foundation, Inc. https://fsf.org/ Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.\nPreamble")
      }.width("100%").margin({top:12})
    }
    .height("100%")
    .padding({
      left: 20,
      right: 20
    })
    .backgroundColor("rgb(245, 245, 245)")
  }
}