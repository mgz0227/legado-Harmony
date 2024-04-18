@Entry
@Component
struct Index {
  @State message: string = '开源阅读'

  build() {

    Row() {
      Column() {
        Image($r("app.media.app_icon"))
          .objectFit(ImageFit.Cover)
          .width(100)
          .height(100)
        Text(     )
          .fontSize(45)

        Text(this.message)
          .fontSize(45)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}