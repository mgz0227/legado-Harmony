@Entry
@Component
struct HelpCenterPage {
  build() {
    RelativeContainer() {
      Text("帮助中心")
        .id('HelpCenterPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}