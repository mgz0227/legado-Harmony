import BookOverlay from '../../../componets/bookDetail/BookOverlay'
import commonInputDialog from '../../../componets/common/commonInputDialog'
import confirmDialogExample from '../../../componets/common/confirmDialog'
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { showMessage } from '../../../componets/common/promptShow'
import TitleContentDialog from '../../../componets/common/TitleContentDialog'
import { buttonList } from '../../../componets/dataList/buttonList'
import { folderList } from '../../../componets/dataList/folderList'
import { updateBookListData } from '../../../storage/bookListData'
import { delGroupById } from '../../../storage/groupData'

@CustomDialog
/**
 * 封面弹窗
 */
@Preview
export default struct coverInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  // @Link itemData:folderList

  cancel: () => void = () => {
  }
  @State coverFolder:boolean = false
  build() {
    Column(){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }){
        Column(){
          Text('游戏').fontColor('rgba(0, 0, 0, 0.88)').fontSize(16).fontWeight(500).lineHeight(24)
          Text(`共${12}本`).fontColor('rgba(0, 0, 0, 0.45)').fontWeight(400).lineHeight(20).fontSize(12)
        }
        Row(){
          Text('仅用于当前分组')
          Toggle({ type: ToggleType.Switch, isOn: this.coverFolder})
            .selectedColor("#F60").hoverEffect(HoverEffect.None)
            // .onChange(()=>{
            //   this.itemData.isUpdateReminder = !this.itemData.isUpdateReminder
            // })
        }
      }.padding(20)
      Divider().strokeWidth(0.5)
      Flex({
        direction: FlexDirection.Row,
        justifyContent:FlexAlign.SpaceBetween
      }){
        this.coverImage($r('app.media.cover_list'))
        this.coverImage($r('app.media.cover_list'))
        this.coverImage($r('app.media.cover_list'))
      }.padding(20)
      Divider().strokeWidth(0.5).padding({bottom:16})
      Column(){
        Flex({
          justifyContent:FlexAlign.SpaceBetween
        }) {
          Column(){
            Text('取消').fontSize(16).fontWeight(400).fontColor($r('app.color.theme_color'))
              .lineHeight(24)
              .padding({left:32,right:32,bottom:8,top:8})
          }
          .onClick(()=>{
            this.cancel()
          })
          .width('49%')
          .borderRadius(20)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('rgba(255, 102, 0, 0.12)')
          Column(){
            Text('确定').fontSize(16).fontWeight(400).fontColor(Color.White)
              .lineHeight(24)
              .padding({left:32,right:32,bottom:8,top:8})
          }
          .width('49%')
          .borderRadius(20)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor($r('app.color.theme_color'))
        }
      }
      .alignItems(HorizontalAlign.Center)
      .padding({right:20,left:20,bottom:16})
    }
    .borderRadius({topLeft:20,topRight:20})
    .backgroundColor(Color.White)
    .width('100%')
  }

  @Builder coverImage(bookImage:Resource){
    Column(){
      BookOverlay({
        bookImage:bookImage,
        // isTop:this.folderList.isTop
      })
      Row().width(86).height(20).backgroundColor(Color.White).borderRadius(2)
        .shadow({ radius: 5, color: 'rgba(0, 0, 0, 0.10)' })
         // .border({width:1,color:'rgba(255, 255, 255, 0.10)'})
    }
  }
}