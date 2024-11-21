@Component
export default struct BookType {
  @Prop title:string
  @Prop bookType:string
  @Prop index:number
  @Prop bookTypeNumber:number = 0

  build() {
    Column() {
      Text(this.title)
        .fontColor(this.index === this.bookTypeNumber ? 'rgb(255,135, 56)' :  'rgba(0,0,0,0.8)')
        .fontSize(12)
        .fontWeight(this.index === this.bookTypeNumber ? 700 : 700)
    }
    .borderRadius(8)
    .padding(8)
    .backgroundColor(this.index === this.bookTypeNumber?'rgba(255,102,0,0.2)':'rgb(240,240,240)')
  }
}