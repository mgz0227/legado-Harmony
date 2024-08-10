import { Books } from '../../../../../database/entities/Books'

@Component
/**
 * 书签
 */
export default struct BookInfoManage{
  @Prop isManage:boolean
  @Prop bookData:Books
  @Link checkGroup:Record<number, boolean>
  build() {
    Flex(
      {
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.SpaceBetween
      }
    ) {
      Row({
        space:20
      }){
        Stack(){
          if (this.bookData.isTop){
            Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
          }
          Image(this.bookData.coverUrl)
            .alt($r('app.media.icon_book_default_cover_one'))
            .width(60)
            .height(80)
        }.alignContent(Alignment.BottomStart)

        Column({
          space:24
        })
        {
          Text(this.bookData.bookName)
            .fontWeight(700)
          Column(){
            Text(this.bookData.intro).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
            Text(this.bookData.durChapterTitle).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
          }
          .width('40%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
      }
      if (this.isManage){
        Row() {
          Checkbox({
            name: JSON.stringify(this.bookData.id)
          })
            .select(this.bookData.id?this.checkGroup[this.bookData.id] ?? false:false)
            .onChange((val:boolean)=>{
              if (this.bookData.id) {
                this.checkGroup[this.bookData.id] = val
              }
            })
            .selectedColor($r('app.color.theme_color'))
            .unselectedColor('rgba(0, 0, 0, 0.35)')
        }
        .padding({ left: 15, right: 15, bottom: 5, top: 5 })
      }
    }
    .padding(10)
    .borderRadius(10)
  }
}