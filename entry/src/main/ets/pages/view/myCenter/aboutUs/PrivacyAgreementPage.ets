import { router } from '@kit.ArkUI';

@Entry
@Component
struct PrivacyAgreementPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State rowsData: Array<string> = [
    '本应用没有服务端,不收集任何用户信息,只采用了Google Firebase收集崩溃报告和性能报告. ',
    '本应用网络同步和备份采用webDav协议,由用户自己提供同步服务.',
    '存储权限用来打开本地文件和本地备份恢复. 其它一些权限是Google Firebase需要.',
    '本应用为开源软件,内置js引擎,因书源调用js发生的任何问题由用户自行承担.'
  ]
  build() {
    Column({ space: 16 }) {
      // 标题部分（不滚动，保持固定）
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
        .width('30%')

        Column() {
          Text(`用户隐私与协议`)
            .lineHeight(24)
            .font({
              family: "PingFang SC",
              size: 16,
              weight: 500,
              style: FontStyle.Normal,
            })
        }.width('40%')
      }
      .padding({
        top: 12,
        bottom: 12,
      })
      .height(48)
      .width("100%")

      // 内容区域
        Column() {
          ForEach(this.rowsData, (item: string) => {
            Row() {
              // 黑色原点
              Column()
                .width(4) // 设置宽度
                .height(4) // 设置高度
                .backgroundColor(0x000000) // 黑色背景
                .borderRadius(2) // 半径设置为宽高的一半，形成圆形
                .margin({ right: 8, top: -20 }) // 与文字的间隔
              Text(item)
                .lineHeight(22)
                .font({
                  family: "PingFang SC",
                  size: 14,
                  style: FontStyle.Normal,
                  weight: 400,
                })
            }.width("100%")
            .margin({ top: 12 })
          })
        }
        .width("100%")
    }
    .height("100%") // 设置外部 Column 高度为 100%
    .padding({
      top: this.topRectHeight,
      left: 20,
      right: 20
    })
    .backgroundColor("rgb(245, 245, 245)")
  }
}