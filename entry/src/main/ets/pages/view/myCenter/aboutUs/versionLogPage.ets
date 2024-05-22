import { router } from '@kit.ArkUI';

@Entry
@Component
struct VersionLogPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State List: Array<string> = [
    '更新了书架1',
    '更新了书架2',
    '更新了书架3',
    '更新了书架4',
    '更新了书架5',
  ]

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
          Text(`版本更新日志`)
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

      this.versionCard("V5.1.223", "2024/5/10", this.List)
      this.versionCard("V5.1.1", "2024/5/9", this.List)
    }
    .height("100%")
    .padding({
      top:this.topRectHeight,
      left:20,
      right:20
    })
    .backgroundColor("rgb(245, 245, 245)")
  }

  @Builder
  versionCard(version: string, date: string, updateInfo: Array<string>) {
    Column() {
      Row() {
        Line({ width: 4, height: 16 })
          .backgroundColor('#FF6600')
          .margin({ right: 8 })
        Text(version)
          .lineHeight(24)
          .fontColor("#000000")
          .font({
            family: "PingFang SC",
            size: 16,
            weight: 500,
            style:FontStyle.Normal,
          })
        Blank(20)
        Text(date)
          .fontColor("#000000")
          .opacity(0.45)
          .lineHeight(20)
          .font({
            family: "PingFang SC",
            size:12,
            weight:400,
            style:FontStyle.Normal
          })
      }
      .margin({ bottom: 12 })
      .width("100%")

      ForEach(updateInfo, (item: string) => {
        Row() {
          // todo:这里有个点
          Text(item).lineHeight(20)
            .font({
              family: "PingFang SC",
              size:12,
              weight:400,
              style:FontStyle.Normal
            })
        }
        .width("100%")
      })
    }
    .borderRadius(12)
    .backgroundColor("#FFFFFF")
    .padding(16)
    .width("100%")
  }
}