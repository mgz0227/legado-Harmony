import confirmDialogExample from '../../../../componets/common/confirmDialog'
import { Books } from '../../../../database/entities/Books'
import { router } from '@kit.ArkUI'
import BookInfoDialogs from './dialog/BookInfoDialogs'

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
    Column() {
      Stack(){
        Stack(){
          if (this.book.isTop){
            Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
          }
          Image(this.book.coverUrl)
            .draggable(false)
            .alt($r('app.media.icon_book_default_cover_one'))
            .width(100)
            .height(120)
        }.alignContent(Alignment.BottomStart)
      }
      .backgroundColor($r('app.string.color_black_45'))
      .borderRadius(10)
      Text(this.book.bookName)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)
      //描述
      Text(this.book.customIntro).fontSize(12).fontColor('rgb(174,174,174)')
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .fontWeight(500)
        .maxLines(1)
      Text(this.book.latestChapterTitle).fontSize(12).fontColor('rgb(174,174,174)')
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .fontWeight(500)
        .maxLines(1)
    }
    .padding({ left:8,right:8,bottom:5,top:5 })
    .onClick(()=>{
      router.pushUrl({
        url: 'pages/view/BookDetailPage',
        params: {
          bookId: '1',
          bookName: '大奉打更人',
          bookAuthor: '卖报小郎君',
          bookImage: $r('app.media.cover_list'),
          bookDescribe: '《大奉打更人》（第一卷）实体书已在天猫、当当、京东等全平台，以及各个实体书店发售。 这个世界，有儒；有道；有佛；有妖；有术士。 警校毕业的许七安幽幽醒来，发现自己身处牢狱之中，三日后流放边陲..... '
        }
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