@Component
export default struct Tag {
  text: string = ''
  color: ResourceColor = ''
  bgColor: ResourceColor = ''

  build() {
    Column() {
      Text(this.text)
        .fontSize(10)
        .fontColor(this.color)
    }
    .height(16)
    .margin({ left: 8 })
    .padding({ left: 6, right: 6 })
    .borderRadius(4)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.bgColor)
  }
}