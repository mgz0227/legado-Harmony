@Component
export default struct LayoutMore {
  @Link ReaderPadding: number

  build() {
    Column() {
      Row() {
        Text("边距")
        Slider({
          value: this.ReaderPadding,
          max: 32,
          min: 12,
          step: 4,
          style: SliderStyle.InSet
        })
          .selectedColor('rgba(0, 0, 0, 0.04)')
          .blockSize({ width: 30, height: 30 })
          .layoutWeight(1)
          .onChange((value) => {
            this.ReaderPadding = value
          })
      }
      .width("100%")

      Row() {
        Text("字体")
        Button("细")
        Button("中")
        Button("粗")

        Button("简体")
        Button("繁体")
      }
      .width("100%")

      Row() {
        Text("首行缩进")
        // Toggle()
      }
      .width("100%")
    }
    .height(500)
    .padding({
      left: 20,
      right: 20
    })
  }
}

