/**
 * 书单信息
 */
import BookOverlay from '../../../../componets/bookDetail/BookOverlay'
import { shelfList } from '../../../../componets/dataList/shelfList'


@Component
export default struct BookShelfInfo{

  @Prop @Watch('isCheckChange')allCheck:boolean
  @Prop bookShelf:shelfList
  @Link checkBookShelf:shelfList[]
  @Link @Watch('isTopChange')changeTop:boolean
  @Prop isShowCheck:boolean
  isTopChange(){
    this.allCheck = false
  }

  isCheckChange(){
    if (this.allCheck) {
      //判断bookId是否有存在
      if (this.checkBookShelf.some(book => book.id === this.bookShelf.id)) {
        return
      }
      this.checkBookShelf.push(this.bookShelf)
    } else {
      this.checkBookShelf = this.checkBookShelf.filter(book => book.id !== this.bookShelf.id);
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
        Column(){
          BookOverlay({
            bookImage:this.bookShelf.bookList[0].bookImage,
            isTop:false,
            isShow:this.isShowCheck
          })
        }
        Column({
          space:24
        })
        {
          Text(this.bookShelf.title)
            .fontWeight(700)
          Column(){
            Text(`共${this.bookShelf.bookList.length}本`).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(400)
              .maxLines(1)
              .lineHeight(20)
            Text(this.bookShelf.describe)
              .fontSize(12).fontColor('rgb(174,174,174)')
              .fontSize(12)
              .fontWeight(400)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(2)
              .lineHeight(20)
          }
          .width('60%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
      }
      if (this.isShowCheck){
        Row() {
          Checkbox({
            name: this.bookShelf.title
          })
            .selectedColor($r('app.color.theme_color'))
            .select(this.allCheck)
            .onClick(()=>{
              this.allCheck = !this.allCheck
            })
        }
        .padding({ left: 15, right: 15, bottom: 5, top: 5 })
      }

    }
    .padding(10)
    .borderRadius(10)

  }

}