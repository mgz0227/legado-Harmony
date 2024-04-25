@Component
export default struct BookType {
  @Prop title:string
  @Prop bookType:string

  build() {
    Column() {
      Text(this.title)
        .fontColor(this.title === this.bookType ? 'rgb(255,135, 56)' :  'rgba(0,0,0,0.8)')
        .fontSize(12)
        .fontWeight(this.title === this.bookType ? 700 : 700)
    }
    .borderRadius(8)
    .padding(8)
    .backgroundColor(this.title === this.bookType?'rgba(255,102,0,0.2)':'rgb(240,240,240)')
  }
}