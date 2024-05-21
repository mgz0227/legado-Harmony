/**
 * 文件夹宫格_管理页
 */
import { shelfList } from '../../../../componets/dataList/shelfList'

@Component
export default struct BookShelfGrid {

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
    Column() {
      Stack() {
        if (this.isShowCheck){
          Flex({
            alignItems: ItemAlign.End,
            justifyContent: FlexAlign.End
          }){
            Checkbox({
              name: this.bookShelf.title
            })
              .zIndex(2)
              .selectedColor($r('app.color.theme_color'))
              .unselectedColor('rgba(0, 0, 0, 0.35)')
              .select(this.allCheck)
              .onClick(() => {
                this.allCheck = !this.allCheck
              })
          }
          .zIndex(3)
          .backgroundColor('rgba(0,0,0,0.45)')
          .width(88).height(120)
        }

        Flex({
          alignItems: ItemAlign.End,
          justifyContent: FlexAlign.End
        }) {
          Flex({
            alignItems: ItemAlign.End,
          }) {
            // if (this.folderList.isTop) {
            //   Text('置顶')
            //     .fontColor(Color.White)
            //     .fontWeight(300)
            //     .fontSize(8)
            //     .padding(5)
            //     .margin({ left: 1, bottom: 1 })
            //     .borderRadius({ bottomLeft: 10, bottomRight: 5, topRight: 5, topLeft: 5 })
            //     .backgroundColor('rgba(0, 0, 0, 0.45)')
            // }
          }
          .align(Alignment.Bottom)
          // if (this.isShowCheck){
          //   Checkbox({
          //     name: this.bookShelf.title
          //   })
          //     .zIndex(2)
          //     .selectedColor($r('app.color.theme_color'))
          //     .unselectedColor('rgba(0, 0, 0, 0.35)')
          //     .select(this.allCheck)
          //     .onClick(() => {
          //       this.allCheck = !this.allCheck
          //     })
          // }

        }
        .backgroundColor('rgba(0, 0, 0, 0.45)')
        .width(88)
        .height(120)
        .backgroundImage(this.bookShelf.bookList[0].bookImage)
        .backgroundImageSize({ width: 88, height: 120 })
        .zIndex(2)
        Row() {
          Image($r('app.media.occlusion1'))
        }
        .zIndex(1)
        .width(95).height(110)

        Row() {
          Image($r('app.media.occlusion2'))
        }.zIndex(0)
        .width(100).height(100)
      }.align(Alignment.BottomStart)
      Row().width(100).height(20).backgroundColor('rgba(255, 255, 255, 0.6)').borderRadius(10)
      Text(this.bookShelf.title)
          .fontSize(15)
          .fontWeight(700)
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .maxLines(2)
        Text(`共${this.bookShelf.bookList.length}本`).fontSize(12).fontColor('rgb(174,174,174)')
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .fontWeight(500)
          .maxLines(1)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left:8,right:8,bottom:5,top:5 })
  }
}