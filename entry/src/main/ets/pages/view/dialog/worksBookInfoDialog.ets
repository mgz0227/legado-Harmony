import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { buttonList } from '../../../componets/dataList/buttonList'
import { WorksLists } from '../../../database/entities/WorksLists'

@CustomDialog
/**
 * 书单长按弹窗
 */
export default struct worksBookInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  @Prop works:WorksLists
  @State pushReminder:boolean = false
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'编辑',$r('app.media.edit')),
    new buttonList(2,'分享',$r('app.media.icon_share')),
    new buttonList(3,'删除',$r('app.media.ic_public_delete'))
  ]

  cancel: () => void = () => {
  }

  build() {
    Column(){
      Divider().strokeWidth(0.5).padding({bottom:16})
      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
        justifyContent:FlexAlign.Start
      }){
        ForEach(this.buttonListInfo,(item:buttonList)=>{
          InsideCircleIcon({
            icon:item.icon,
            title:item.title
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
}