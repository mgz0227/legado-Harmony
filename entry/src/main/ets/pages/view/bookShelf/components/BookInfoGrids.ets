import confirmDialogExample from '../../../../componets/common/confirmDialog'
import { Books } from '../../../../database/entities/Books'
import { router } from '@kit.ArkUI'
import BookInfoDialogs from './dialog/BookInfoDialogs'
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import clickUtil from '../../../../common/utils/ClickUtils'

@Component
/**
 * 书签_宫格
 */
export default struct BookInfoGrids{

  @Prop book:Books

  onDelete: () => void = () => {

  }
  @State delCache:boolean = false
  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      delCache:this.delCache,
      isShowCache:true
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    // offset: { dx: 0, dy: '-40%' },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  onCancel() {
    console.info('取消')
  }

  onAccept() {
    this.onDelete()
  }

  exitApp() {
    console.info('点外围取消')
  }


  build() {
    Column({
      space:8
    }) {
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
            Text('置顶')
              .fontColor(Color.White)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
              .fontSize(9)
              .padding(3)
              .borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)')
              .zIndex(1)
          }
          Image(this.book.coverUrl)
            .draggable(false)
            .alt($r('app.media.icon_book_default_cover_one'))
            .width(100)
            .height(120)
        }
        .alignContent(Alignment.BottomStart)
      }
      .alignContent(Alignment.TopEnd)
      .backgroundColor($r('app.string.color_black_45'))
      .borderRadius(10)
      Column({
        space:CommonConstants.SPACE_2
      }){
        Text(this.book.bookName)
          .fontSize(15)
          .fontWeight(700)
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .maxLines(2)
        //描述
        Text(this.book.customIntro).fontSize(12).fontColor('rgb(174,174,174)')
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .fontWeight(500)
          .maxLines(1)
        Text(this.book.durChapterTitle).fontSize(12).fontColor('rgb(174,174,174)')
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .fontWeight(500)
          .maxLines(1)
      }
      .width(100)
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left:8,right:8,bottom:5,top:5 })
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