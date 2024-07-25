import confirmDialogExample from '../../../../componets/common/confirmDialog'
import { Books } from '../../../../database/entities/Books'
import { router } from '@kit.ArkUI'
import { showMessage } from '../../../../componets/common/promptShow'
import BookInfoDialogs from './dialog/BookInfoDialogs'

@Component
/**
 * 书签
 */
export default struct BookInfos{
  @Prop searchValue:string

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
          if (this.book.isTop){
            Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
          }
          Image(this.book.coverUrl)
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
            Text(this.book.latestChapterTitle).fontSize(12).fontColor('rgb(174,174,174)')
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
          router.pushUrl({
            url: 'pages/view/BookDetailPage',
            params: this.book
          })
        })
      }

      if (this.searchValue === '浏览历史'){
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
            this.book.isJoin = !this.book.isJoin
            // updateDateListById(this.currentIndex, this.book.isJoin, this.book.bookId)
            showMessage(this.book.isJoin?'已加入书架':'已移出书架',)
          })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.End)
      }
    }
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

  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: ()=> { this.onCancel() },
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

  onCancel() {
    console.info('取消')
  }

  onAccept() {

  }


}