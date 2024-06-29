import confirmDialogExample from '../../../componets/common/confirmDialog'
import router from '@ohos.router'
import { promptAction } from '@kit.ArkUI'
import { updateDateListById } from '../../../storage/bookListData'
import { BookList } from '../../../componets/dataList/bookList'
import { showMessage } from '../../../componets/common/promptShow'
import BookInfoDialog from '../dialog/BookInfoDialog'

@Component
/**
 * 书签
 */
export default struct BookInfo{
  @Prop searchValue:string

  @Prop currentIndex:number

  @Prop bookData:BookList

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
          if (this.bookData.isTop){
            Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)')
          }
        }
        .align(Alignment.Bottom).width(60).height(80).backgroundImage(this.bookData.bookImage).backgroundImageSize({width:60,height:80})
        Column({
          space:24
        })
        {
          Text(this.bookData.title)
            .fontWeight(700)
          Column(){
            Text(this.bookData.describe).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
            Text(this.bookData.chapter).fontSize(12).fontColor('rgb(174,174,174)')
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
            params: this.bookData
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
              Image(this.bookData.isJoin?$r("app.media.add_check"):$r("app.media.add_shelf")).width(this.bookData.isJoin?15:10).height(this.bookData.isJoin?15:10)
                .fillColor('rgba(0, 0, 0, 0.9)')
              Text('书架').fontSize(10).fontColor('rgba(0, 0, 0, 0.45)')
            }.padding({ left:15,right:15,bottom:5,top:5 })
          }
          .backgroundColor(this.bookData.isJoin?'rgba(174,174,174,0.2)':'')
          .borderColor('rgb(174,174,174)')
          .borderWidth(this.bookData.isJoin?0:1)
          .borderRadius(50)
          .onClick(()=>{
            this.bookData.isJoin = !this.bookData.isJoin
            updateDateListById(this.currentIndex, this.bookData.isJoin, this.bookData.bookId)
            promptAction.showToast({
              message: this.bookData.isJoin?'已加入书架':'已移出书架',
              duration: 1000,
            })
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
    builder: BookInfoDialog({
      itemData:this.bookData,
      onDelete:this.onDelete,
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