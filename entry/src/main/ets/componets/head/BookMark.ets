@Component
export default struct BookMark {
  @Prop title:string
  @Prop currentIndex:number
  @Prop index:number

  build() {
    Column() {
      Text(this.title)
        .fontColor(this.currentIndex === this.index ? 'rgba(0, 0, 0, 1.00)' :  'rgba(0,0,0,0.5)')
        .fontSize(this.currentIndex === this.index ? 25 :  16)
        .fontWeight(this.currentIndex === this.index ? 700 : 500)
        .lineHeight(30)
      // Divider()
      //   .strokeWidth(3)
      //   .color('#fff')
      //   .opacity(this.currentIndex === this.index?1:0).width('15%')
    }
  }
}