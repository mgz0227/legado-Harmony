import { buttonList } from '../../../../../componets/dataList/buttonList'
import { Books } from '../../../../../database/entities/Books'
import { router } from '@kit.ArkUI'
import InsideCircleIcon from '../../../../../componets/common/InsideCircleIcon'
import { showMessage } from '../../../../../componets/common/promptShow'
import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import { sleep } from '../../../../../common/utils/utils'
import booksUtil from '../../../../../common/utils/booksUtils'

@CustomDialog
/**
 * 书籍长按
 */
export default struct BookInfoDialogs{
  controller?: CustomDialogController
  //推送提醒
  @Link bookData:Books
  @State pushReminder:boolean = false
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'置顶',$r('app.media.top')),
    new buttonList(2,'移动至',$r('app.media.folder')),
    new buttonList(3,'加入书单',$r('app.media.shelf')),
    new buttonList(4,'删除',$r('app.media.ic_public_delete'))
  ]

  cancel: () => void = () => {
  }

  build() {
    Column(){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }){
        Row({
          space:20
        }){
          Image(this.bookData.toUrl)
            .width(45).height(65)
          Column({
            space:4
          }){
            Text(this.bookData.bookName).fontSize(16).fontWeight(500).fontColor($r('app.string.color_black_88'))
            Text(this.bookData.author).fontSize(12).fontWeight(400).fontColor($r('app.string.color_black_45'))
          }.alignItems(HorizontalAlign.Start)
        }
        Row({
          space:8
        }){
          Text('书籍详情').fontSize(12).fontWeight(400).fontColor($r('app.string.color_black_45'))
          Image($r('app.media.icon_right')).width(20).height(20).fillColor($r('app.string.color_black_45'))
        } .onClick(()=>{
          router.pushUrl({
            url: 'pages/view/BookDetailPage',
            params: this.bookData
          })
          this.controller?.close()
        })
      }.padding(20)
      Divider().strokeWidth(0.5).padding({bottom:16})
      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
        justifyContent:FlexAlign.Start
      }){
        ForEach(this.buttonListInfo,(item:buttonList)=>{
          InsideCircleIcon({
            item:item
          })
            .onClick(()=>{
              this.bookInfoButton(item.id)
            })
        })
      }
      Divider().strokeWidth(0.5).padding({bottom:16})
      Column(){
        Text('取消').fontColor('rgba(0, 0, 0, 0.88)').fontSize(16).fontWeight(400).lineHeight(24).textAlign(TextAlign.Center)
      }
      .onClick(()=>{
        this.cancel()
        this.controller?.close()
      })
      .alignItems(HorizontalAlign.Center)
      .padding({bottom:16})
    }
    .borderRadius({topLeft:20,topRight:20})
    .backgroundColor(Color.White)
    .width('100%')
  }

  bookInfoButton(id:number){
    switch (id){
      case 1 :
        showMessage(!this.bookData.isTop?'置顶':'取消置顶');
        this.isFolderTop(); break;
      case 2 :
        showMessage('移动至'); break;
      case 3 :
        showMessage('加入书单'); break;
      case 4 :
        this.bookDelDialog?.open(); break;
    }
  }

  isFolderTop(){
    this.bookData.isTop = !this.bookData.isTop
    this.buttonListInfo[0].title = this.bookData.isTop?'取消置顶':'置顶'
    //刷新数组buttonListInfo
    this.buttonListInfo = this.buttonListInfo.slice(0)
    this.bookData.updateTime = Date.now()
  }

  @State delCache:boolean = false
  //弹窗
 bookDelDialog: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: ()=> { this.deleteGroup() },
      delCache:this.delCache
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  deleteGroup() {
    this.deleteBook()
    this.cancel()
  }

  exitApp() {
    this.bookDelDialog?.close()
  }
  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0

  async deleteBook(){
    booksUtil.delBooksById(this.bookData.id || 0)
    setTimeout(()=>{
      this.isBookRefreshing++
    },500)
    showMessage('删除成功')
  }

}