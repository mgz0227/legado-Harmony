import confirmDialogExample from '../../../../componets/common/confirmDialog'
import { Books } from '../../../../database/entities/Books'
import { router } from '@kit.ArkUI'
import { showMessage } from '../../../../componets/common/promptShow'
import BookInfoDialogs from './dialog/BookInfoDialogs'
import booksUtil from '../../../../common/utils/booksUtils'
import { BookHistory } from '../../../../database/entities/BookHistory'
import bookHistoryUtils from '../../../../common/utils/BookHistoryUtils'
import clickUtil from '../../../../common/utils/ClickUtils'

@Component
/**
 * 浏览历史记录
 */
export default struct BookHistoryInfo{
  @State book:Books = new Books()
  @Prop bookHistory:BookHistory
  @State delCache:boolean = false
  @StorageLink('BOOK_IS_BOOK_HISTORY_REFRESHING') isBookHistoryRefreshing: number = 0

  async aboutToAppear(): Promise<void> {
    if (this.bookHistory.id) {
     let bookInfo = await booksUtil.getBookByIds(this.bookHistory.id)
      if (bookInfo && bookInfo[0]) {
        this.book = bookInfo[0]
      } else {
       this.book = this.mergeBookHistoryToBooks(this.bookHistory)
       this.book.isJoin = false
      }
    }
  }
  mergeBookHistoryToBooks(history: BookHistory): Books {
    // 将 `BookHistory` 和 `Books` 对象转换为 JSON
    return JSON.parse(JSON.stringify(history)) as Books;
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
        Stack(){
          Image(this.book.coverUrl??'')
            .draggable(false)
            .alt($r('app.media.icon_book_default_cover_one'))
            .width(60)
            .height(80)
        }.alignContent(Alignment.BottomStart)
        Column({
          space:24
        })
        {
          Text(this.book.bookName)
            .fontWeight(700)
          Column(){
            Text(this.book.intro).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
            Text(`最近阅读章节:${this.book.durChapterTitle}`).fontSize(12).fontColor('rgb(174,174,174)')
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
        .onClick(()=>{
          clickUtil.preventClick(()=>{
            router.pushUrl({
              url: 'pages/view/BookDetailPage',
              params: this.book
            })
          })
        })
      }

      Column({space:15}){
        Row(){
          Image($r('app.media.delete_svg')).width(17).fillColor('rgba(0, 0, 0, 0.6)')
        }
        .onClick(()=>{
          if (this.bookInfoDel != null) {
            this.bookInfoDel.open()
          }
        })
        .padding({right:5})
        Row(){
          Row({space:5}){
            Image(this.book.isJoin?$r("app.media.add_check"):$r("app.media.add_shelf"))
              .width(this.book.isJoin?15:10)
              .height(this.book.isJoin?15:10)
              .fillColor('rgba(0, 0, 0, 0.9)')
            Text('书架').fontSize(10).fontColor('rgba(0, 0, 0, 0.45)')
          }.padding({ left:15,right:15,bottom:5,top:5 })
        }
        .backgroundColor(this.book.isJoin?'rgba(174,174,174,0.2)':'')
        .borderColor('rgb(174,174,174)')
        .borderWidth(this.book.isJoin?0:1)
        .borderRadius(50)
        .onClick(()=>{
          if (!this.book.isJoin) {
            this.book.id = undefined
            booksUtil.addBooks(this.book)
            showMessage('加入书架成功')
            this.book.isJoin = true
            return
          }
          this.bookHistory.originBookId?booksUtil.delBooksById(this.bookHistory.originBookId):''
          this.book.isJoin = false
          showMessage('移出书架成功')
        })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.End)
    }
    .gesture(
      LongPressGesture({ repeat: true,duration:500 })
        .onAction((event: GestureEvent) => {
          if (event.repeat) {
            // this.bookInfoDialog?.open()
          }
        }))
    .padding(10)
    .borderRadius(10)
  }

  // bookInfoDialog: CustomDialogController | null = new CustomDialogController({
  //   builder: BookInfoDialogs({
  //     bookData:this.book,
  //     cancel: () => {
  //       this.exitDialog()
  //     }
  //   }),
  //   cancel: this.exitDialog,
  //   autoCancel: true,
  //   width:'100%',
  //   alignment: DialogAlignment.Bottom,
  //   customStyle:true
  // })
  //退出弹框
  // exitDialog(){
  //   this.bookInfoDialog?.close()
  // }

  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: ()=> { this.onAccept() },
      delCache:this.delCache,
      isShowCache:true
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  async onAccept() {
    if (this.bookHistory.id) {
     let result = await bookHistoryUtils.deleteBookHistory(this.bookHistory.id)
      this.isBookHistoryRefreshing++
      showMessage(result?'删除成功':'删除失败')
    }
  }


}