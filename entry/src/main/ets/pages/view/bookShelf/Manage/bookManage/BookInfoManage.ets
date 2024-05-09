import { BookList } from '../../../../../componets/dataList/bookList'

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

  @Prop isTop:boolean

  @Prop @Watch('isCheckChange')allCheck:boolean

  @Link checkBookList:BookList[]

  @Link @Watch('isTopChange')changeTop:boolean

  isTopChange(){
    this.allCheck = false
  }

  isCheckChange(){
    if (this.allCheck) {
      //判断bookId是否有存在
      if (this.checkBookList.some(book => book.bookId === this.bookId)) {
        return
      }
      this.checkBookList.push(new BookList(this.bookId,this.title,this.describe,this.chapter,this.bookImage,'',new Date(),this.isJoin,this.isTop))
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
        Flex({
          alignItems: ItemAlign.End,
        }){
          if (this.isTop){
            Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)')
          }
        }
        .align(Alignment.Bottom).width(60).height(80).backgroundImage(this.bookImage).backgroundImageSize({width:60,height:80})

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