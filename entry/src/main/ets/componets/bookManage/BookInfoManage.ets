import { BookList } from '../dataList/bookList'
import { JSON } from '@kit.ArkTS'

@Component
/**
 * 书签
 */
export default struct BookInfoManage{
  @Prop bookId:string
  //标题
  @Prop title:string
  //描述
  @Prop describe:string
  //章节
  @Prop chapter:string
  //图片
  @Prop bookImage:Resource

  @Prop isJoin:boolean

  @Prop @Watch('isCheckChange')allCheck:boolean = false

  @Link checkBookList:BookList[]

  isCheckChange(){
    if (this.allCheck) {
      this.checkBookList.push(new BookList(this.bookId,this.title,this.describe,this.chapter,this.bookImage,this.isJoin))
    } else {
      this.checkBookList = this.checkBookList.filter(book => book.bookId !== this.bookId);
    }
  }

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
        Image(this.bookImage).width(60).height(80)
        Column({
          space:24
        })
        {
          Text(this.title)
            .fontWeight(700)
          Column(){
            Text(this.describe).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
            Text(this.chapter).fontSize(12).fontColor('rgb(174,174,174)')
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
      Row() {
        Checkbox({
          name: this.title
        })
          .selectedColor($r('app.color.theme_color'))
          .select(this.allCheck)
          .onClick(()=>{
            this.allCheck = !this.allCheck
          })
      }
      .padding({ left: 15, right: 15, bottom: 5, top: 5 })
    }
    .padding(10)
    .borderRadius(10)
  }
}