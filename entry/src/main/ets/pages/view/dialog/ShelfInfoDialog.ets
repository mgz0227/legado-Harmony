import { shelfList } from '../../../componets/dataList/shelfList'

class buttonList {
  id:number
  title:string
  icon:Resource
  constructor(id:number,title:string,icon:Resource){
    this.id = id
    this.title = title
    this.icon = icon
  }
}


@CustomDialog
/**
 * 书单长按弹窗
 */
export default struct ShelfInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  @Link @Watch('itemDataFunction')itemData:shelfList
  @State pushReminder:boolean = false
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'编辑',$r('app.media.edit')),
    new buttonList(2,'分享',$r('app.media.icon_share')),
    new buttonList(3,'删除',$r('app.media.ic_public_delete'))
  ]
  itemDataFunction(){
    console.log(JSON.stringify(this.itemData))
  }
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
          this.titleBuilder(item)
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

  @Builder titleBuilder(item:buttonList) {
    Column({
      space:8
    }){
      Column(){
        Image(item.icon)
          .width(24).height(24).margin(12)
      }.borderRadius(50)
      .border({width:0.5,color:'rgba(0, 0, 0, 0.15)'})
      Text(item.title)
    }
    .onClick(()=>{
      console.log(item.id + '')
    })
    .padding({bottom:28})
    .width('25%')
  }
}