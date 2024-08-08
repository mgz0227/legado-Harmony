@Component
export default struct FilterText {
  index: number = 0
  @Prop title: string
  @Prop hasActive: boolean = false
  isIcon: boolean = true
  onChange: (val: number) => void = (_val) => {}

  build() {
    Row() {
      Text(this.title)
        .fontSize(12)
        .fontColor(this.hasActive ? '#FF6600' : '#E0000000')

      if (this.isIcon) {
        Image($r('app.media.down_arrow'))
          .width(8)
          .margin({ left: 6 })
          .fillColor(this.hasActive ? '#FF6600' : '#E0000000')
      }
      if (this.index === 4 && this.hasActive) {
        Image($r('app.media.close'))
          .width(8)
          .margin({ left: 2 })
          .fillColor(this.hasActive ? '#FF6600' : '#E0000000')
      }
    }
    .height(22)
    .padding({
      top: 2,
      bottom: 2,
      left: 4,
      right: 4
    })
    .layoutWeight(1)
    .backgroundColor(this.hasActive ? 'rgba(255, 102, 0, 0.12)' : Color.White)
    .borderRadius(4)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onChange(this.index)
    })
  }
}
