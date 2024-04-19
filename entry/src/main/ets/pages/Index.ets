import CommonConstants from '../common/constants/CommonConstants';

@Entry
@Component
struct Index {
  @State name: string = '开源阅读'
  @State Tip: string = '享受阅读时光'

  build() {
    Stack() {
      Image($r('app.media.ic_launcher_background'))
        .width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.FULL_HEIGHT)

      Column() {
        Row() {
          Text(this.name)
            .fontSize(45)
            .fontWeight(FontWeight.Bold)
            .width(45)
          Text(this.Tip)
            .fontSize(20)
            .fontWeight(FontWeight.Normal)
            .width(25)
            .markAnchor({ x: -20, y: -80 })
              }

      }
      .width('100%')
    }
    .height('100%')
  }
}