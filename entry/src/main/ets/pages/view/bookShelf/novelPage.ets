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
      BookInfo()
      Divider().vertical(false)
      Row(){
        Text('END').fontColor('rgba(84, 84, 84, 0.30)').fontWeight(500)
      }
    }
    .backgroundColor('rgba(255,250,247,0.8)')
  }
}