import { router } from '@kit.ArkUI';

@Entry
@Component
struct OpenSourceLicensePage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0

  build() {
    Column({ space: 16 }) {
      Flex() {
        Column() {
          Image($r("app.media.return_left"))
            .size({ width: 24, height: 24 })
            .interpolation(ImageInterpolation.Medium)
            .onClick(() => {
              router.back()
            })
        }
        .alignItems(HorizontalAlign.Start)
        .width('33%')

        Column() {
          Text(`开源许可`)
            .lineHeight(24)
            .font({
              family: "PingFang SC",
              size: 16,
              weight: 500,
              style: FontStyle.Normal,
            })
        }.width('33%')
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
      top:this.topRectHeight,
      left: 20,
      right: 20
    })
    .backgroundColor("rgb(245, 245, 245)")
  }
}