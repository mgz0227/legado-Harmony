import BookInfo from './BookInfo'

@Component
export default struct novelPage{
  @State TypeSearch:number = 0
  build() {
    Column(
      {space:10}
    ){
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
      BookInfo()
    }
    .backgroundColor('rgba(255,250,247,0.8)')
    .alignItems(HorizontalAlign.Start)

  }
}