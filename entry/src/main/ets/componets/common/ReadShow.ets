/**
 * 上次阅读弹窗
 */
import booksUtil from '../../common/utils/booksUtils'
import bookHistoryDao from '../../database/dao/BookHistoryDao'
import { BookHistory } from '../../database/entities/BookHistory'
import { Books } from '../../database/entities/Books'
import { router } from '@kit.ArkUI'

@Component
export default struct ReadShow {
  @Link showReadShow:boolean
  @State bookHistory:BookHistory = new BookHistory()
  @State book:Books = new Books()
  aboutToAppear(): void {
    this.getBookHistoryList()
  }
  async getBookHistoryList(){
    bookHistoryDao.search().then((val)=>{
      this.bookHistory = val[0]
    })
    if (this.bookHistory.id) {
      let bookInfo = await booksUtil.getBookByIds(this.bookHistory.id)
      if (bookInfo && bookInfo[0]) {
        this.book = bookInfo[0]
      }
    }
  }
  build() {
    if (this.book && this.bookHistory){
      Column(){
        Flex(
          {
            alignItems:ItemAlign.Center,
            alignContent:FlexAlign.SpaceBetween
          }
        ) {
          Image(this.bookHistory.coverUrl??'')
            .draggable(false)
            .alt($r('app.media.icon_book_default_cover_one')).width(40).height(52)
          Column({
            space:24
          })
          {
            Text(this.bookHistory.bookName)
              .fontSize(12)
              .fontColor(Color.White)
            Column(){
              Text(this.bookHistory.durChapterTitle).fontSize(12).fontColor(Color.White)
                .textOverflow({
                  overflow:TextOverflow.Ellipsis
                })
                .ellipsisMode(EllipsisMode.END)
                .fontWeight(500)
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .padding({left:15})
          Column(){
            Text('继续阅读')
              .fontSize(12)
              .fontWeight(600)
              .padding(10)
              .borderRadius(20)
              .fontColor('#FF6600')
              .backgroundColor(Color.White)
          }
          .padding({left:55,right:30})
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/view/BookDetailPage',
              params: this.book
            })
          })

          Image($r('app.media.Outlined')).width(15).height(15)
            .onClick(() => {
              this.showReadShow = !this.showReadShow
              console.log(this.showReadShow + '')
            })
        }
        .borderRadius(10)
      }
      .alignItems(HorizontalAlign.Start)
      .borderRadius(10)
      .padding(10)
      .width('95%')
      .backgroundColor('rgb(182,134,102)')
    }
  }
}