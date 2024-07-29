import CommonConstants from '../../../../../common/constants/CommonConstants'
import { Books } from '../../../../../database/entities/Books'

@Component
/**
 * 书签_宫格
 */
export default struct BookInfoGridManage{

  @Prop isManage:boolean

  @Prop bookData:Books

  @Link checkGroup:Record<number, boolean>

  build() {
    Column({
      space:CommonConstants.SPACE_6
    }) {
      Stack(){
        if (this.isManage){
          Checkbox({
            name: JSON.stringify(this.bookData.id),
            group: 'checkboxGroup'
          })
            .select(this.bookData.id?this.checkGroup[this.bookData.id] ?? false:false)
            .selectedColor($r('app.color.theme_color'))
            .unselectedColor('rgba(0, 0, 0, 0.35)')
            .zIndex(2)
            .onChange((val:boolean)=>{
              if (this.bookData.id) {
                this.checkGroup[this.bookData.id] = val
              }
            })
        }
        Stack(){
          if (this.bookData.isTop){
            Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
          }
          Image(this.bookData.coverUrl)
            .alt($r('app.media.icon_book_default_cover_one'))
            .width(100)
            .height(120)
        }.alignContent(Alignment.BottomStart)
      }
      .backgroundColor($r('app.string.color_black_45'))
      .borderRadius(10)

      Text(this.bookData.bookName)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)

      Text(this.bookData.intro).fontSize(12).fontColor('rgb(174,174,174)')
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .fontWeight(500)
        .maxLines(1)
    }
    .padding({ left:8,right:8,bottom:5,top:5 })
  }
}