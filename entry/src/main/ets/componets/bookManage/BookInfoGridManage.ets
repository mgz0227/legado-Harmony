import { BookList } from '../dataList/bookList'

@Component
/**
 * 书签_宫格
 */
export default struct BookInfoGridManage{
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
    Column() {
      Column(){
        Flex({
          alignItems: ItemAlign.End,
          justifyContent:FlexAlign.End
        }){
          Checkbox({
            name: this.title
          })
            .selectedColor($r('app.color.theme_color'))
            .unselectedColor('rgba(255, 255, 255, 0.6)')
            .select(this.allCheck)
            .onClick(()=>{
              this.allCheck = !this.allCheck
            })
        }
        .borderRadius(10)
        .backgroundColor('rgba(0, 0, 0, 0.3)')
        .width(100).height(120)
      }
      .borderRadius(10)
      .width(100).height(120)
      .backgroundImage(this.bookImage)
      .backgroundImageSize({width:100,height:120})
      Text(this.title)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)

      Text(this.chapter).fontSize(12).fontColor('rgb(174,174,174)')
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