import { Books } from '../../../../database/entities/Books'
import { router } from '@kit.ArkUI'
import BookInfoDialogs from './dialog/BookInfoDialogs'
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import clickUtil from '../../../../common/utils/ClickUtils'

@Component
/**
 * 书签
 */
export default struct BookInfos{
  @Prop currentIndex:number

  @Prop book:Books

  @State delCache:boolean = false
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
          if (this.book.isLocalBook){
            Text('本地')
              .fontColor('#FFEDD4')
              .fontWeight(FontConstants.FONT_WEIGHT_400)
              .fontSize(9)
              .padding(3)
              .backgroundColor('#523000')
              .zIndex(1)
              .borderRadius({
                topRight: 6,
                bottomLeft: 6,
              })
          }
          Stack(){
            if (this.book.isTop){
              Text('置顶').fontColor(Color.White).fontWeight(FontConstants.FONT_WEIGHT_400).fontSize(9).padding(3).borderRadius(5)
                .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
            }
            Image(this.book.coverUrl)
              .draggable(false)
              .alt($r('app.media.icon_book_default_cover_one'))
              .width(60)
              .height(80)
          }
          .alignContent(Alignment.BottomStart)
        }
        .alignContent(Alignment.TopEnd)
        Column({
          space:12
        })
        {
          Text(this.book.bookName)
            .fontWeight(700)
          Column(){
            Text(this.book.intro).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .maxLines(2)
              .fontWeight(500)
              .width('80%')
            Text(this.book.durChapterTitle).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
      }
    }
    .onClick(()=>{
      clickUtil.preventClick(()=>{
        router.pushUrl({
          url: 'pages/view/BookDetailPage',
          params: this.book
        })
      })
    })
    .gesture(
      LongPressGesture({ repeat: true,duration:500 })
        .onAction((event: GestureEvent) => {
          if (event.repeat) {
            this.bookInfoDialog?.open()
          }
        }))
    .padding(10)
    .borderRadius(10)
  }

  bookInfoDialog: CustomDialogController | null = new CustomDialogController({
    builder: BookInfoDialogs({
      bookData:this.book,
      cancel: () => {
        this.exitDialog()
      }
    }),
    cancel: this.exitDialog,
    autoCancel: true,
    width:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true
  })
  //退出弹框
  exitDialog(){
    this.bookInfoDialog?.close()
  }
}