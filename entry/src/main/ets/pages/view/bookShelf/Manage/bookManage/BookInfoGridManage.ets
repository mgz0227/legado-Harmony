import { BookList } from '../../../../../componets/dataList/bookList'

@Component
/**
 * 书签_宫格
 */
export default struct BookInfoGridManage{
  @Prop @Watch('isCheckChange')allCheck:boolean

  @Link checkBookList:BookList[]

  @Link @Watch('isTopChange')changeTop:boolean

  @Prop isManage:boolean

  @Prop bookData:BookList

  isTopChange(){
    this.allCheck = false
  }

  isCheckChange(){
    if (this.allCheck) {
      //判断bookId是否有存在
      if (this.checkBookList.some(book => book.bookId === this.bookData.bookId)) {
        return
      }
      this.checkBookList.push(this.bookData)
    } else {
      this.checkBookList = this.checkBookList.filter(book => book.bookId !== this.bookData.bookId);
    }
  }


  build() {
    Column() {
      Column(){
        Flex({
          alignItems: ItemAlign.End,
          justifyContent:FlexAlign.End
        }){
          Flex({
            alignItems: ItemAlign.End,
          }){
            if (this.bookData.isTop){
              Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(5).margin({left:1,bottom:1}).borderRadius({ bottomLeft:10,bottomRight:5,topRight:5,topLeft:5 })
                .backgroundColor('rgba(0, 0, 0, 0.45)')
            }
          }
          .align(Alignment.Bottom)
          if (this.isManage){
            Checkbox({
              name: this.bookData.title
            })
              .selectedColor($r('app.color.theme_color'))
              .unselectedColor('rgba(255, 255, 255, 0.6)')
              .select(this.allCheck)
              .onClick(()=>{
                this.allCheck = !this.allCheck
              })
          }
        }
        .width(100).height(120)
      }
      .backgroundColor('rgba(0, 0, 0, 0.45)')
      .borderRadius(10)
      .width(100).height(120)
      .backgroundImage(this.bookData.bookImage)
      .backgroundImageSize({width:100,height:120})
      Text(this.bookData.title)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)

      Text(this.bookData.chapter).fontSize(12).fontColor('rgb(174,174,174)')
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