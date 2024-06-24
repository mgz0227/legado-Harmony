import CommonConstants from '../../../common/constants/CommonConstants'
import confirmDialogExample from '../../../componets/common/confirmDialog'
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { showMessage } from '../../../componets/common/promptShow'
import { BookList } from '../../../componets/dataList/bookList'
import { buttonList } from '../../../componets/dataList/buttonList'
import { router } from '@kit.ArkUI'

@CustomDialog
/**
 * 书籍长按
 */
export default struct BookInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  @Link itemData:BookList
  @State pushReminder:boolean = false
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'置顶',$r('app.media.top')),
    new buttonList(2,'移动至',$r('app.media.folder')),
    new buttonList(3,'加入书单',$r('app.media.shelf')),
    new buttonList(4,'删除',$r('app.media.ic_public_delete'))
  ]

  cancel: () => void = () => {
  }

  onDelete: () => void = () => {

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
          Image(this.itemData.bookImage)
            .width(45).height(65)
          Column({
            space:4
          }){
            Text(this.itemData.title).fontSize(16).fontWeight(500).fontColor($r('app.string.color_black_88'))
            Text(this.itemData.author).fontSize(12).fontWeight(400).fontColor($r('app.string.color_black_45'))
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
            params: {
              bookId: '1',
              bookName: '大奉打更人',
              bookAuthor: '卖报小郎君',
              bookImage: $r('app.media.cover_list'),
              bookDescribe: '《大奉打更人》（第一卷）实体书已在天猫、当当、京东等全平台，以及各个实体书店发售。 这个世界，有儒；有道；有佛；有妖；有术士。 警校毕业的许七安幽幽醒来，发现自己身处牢狱之中，三日后流放边陲..... '
            }
          })
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
        showMessage(!this.itemData.isTop?'置顶':'取消置顶');
        this.isFolderTop(); break;
      case 2 :
        showMessage('移动至'); break;
      case 3 :
        showMessage('加入书单'); break;
      case 4 :
        showMessage('删除'); this.bookDelDialog?.open(); break;
    }
  }

  isFolderTop(){
    this.itemData.isTop = !this.itemData.isTop
    this.buttonListInfo[0].title = this.itemData.isTop?'取消置顶':'置顶'
    //刷新数组buttonListInfo
    this.buttonListInfo = this.buttonListInfo.slice(0)
    this.itemData.topUpdateTime = new Date()
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
    this.onDelete()
    this.cancel()
  }

  exitApp() {
    this.bookDelDialog?.close()
  }
}