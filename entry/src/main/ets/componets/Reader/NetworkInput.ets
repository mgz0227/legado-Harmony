@Component
export struct NetworkInput {
  build() {
    Row() {
      Row() {
        Image($r("app.media.ic_public_return_left"))
          .width(12)
        Text("笔趣阁")
          .lineHeight(18)
          .font({
            size: 10,
            weight: 500
          })
      }
      .margin({
        left: 3
      })
      .borderRadius(40)
      .backgroundColor("white")
      .padding({
        top: 4,
        bottom: 4,
        left: 12,
        right: 12
      })

      Text("https://www.qidian.com/book/10319406240624062")
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .backgroundColor("rgba(0, 0, 0, 0.06)")
    .width("100%")
    .height(30)
    .borderRadius(40)
  }
}