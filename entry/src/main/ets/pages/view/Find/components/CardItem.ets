import { ExploreRule } from '../../../../database/entities/rule';

@Component
export  struct CardItem {
  @Prop item: ExploreRule = {};

  build() {
    Row() {
      Image(this.item.coverUrl ?? $r('app.media.no_record'))
        .width(63)
        .height(84)
        .objectFit(ImageFit.Contain)
        .borderRadius(4)
        .margin({ right: 12 })


      Column() {
        Text(this.item.name)
          .fontSize(16)
          .height(24)
          .lineHeight(24)

        Text(this.item.intro)
          .fontSize(12)
          .lineHeight(20)
          .height(40)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .maxLines(2)

        Row() {
          Column() {
            Text(this.item.author)
              .fontSize(10)
              .fontColor('#FF6600')
          }
          .padding({ left: 6, right: 6 })
          .height(16)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#1FFF6600')

          if (this.item.kind) {
            Column() {
              Text(this.item.kind)
                .fontSize(10)
                .fontColor('#73000000')
            }
            .margin({ left: 8 })
            .padding({ left: 6, right: 6 })
            .height(16)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#0F000000')
          }

          if (this.item.wordCount) {
            Column() {
              Text(this.item.wordCount)
                .fontSize(10)
                .fontColor('#73000000')
            }
            .margin({ left: 8 })
            .padding({ left: 6, right: 6 })
            .height(16)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#0F000000')
          }
        }
        .padding({top: 4})
        .width('100%')
        .height(16)
        .justifyContent(FlexAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 20 })
  }
}