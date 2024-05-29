import battery from "ets/componets/common/battery"

@Entry
@Component
struct ReaderPage {
  build() {
    Column() {
      Row() {
        Text("第一章 牢狱之灾")
      }

      Blank(1)
      Row({space:4}) {
        Text("1/14  0.1%")
        Blank(1)
        TextClock({ timeZoneOffset: -8 })
          .format('hh:mm')
          .fontSize(12)
          .fontWeight(400)
        battery()
      }
      .padding({
        top: 16,
        bottom: 16
      })
      .width("100%")
    }
    .padding({
      left: 24,
      right: 24
    })
    .height('100%')
    .width('100%')
  }
}