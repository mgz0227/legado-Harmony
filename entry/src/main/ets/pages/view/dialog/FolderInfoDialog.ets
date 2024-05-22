import { folderList } from '../../../componets/dataList/folderList'

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
 * 文件夹长按弹窗
 */
export default struct FolderInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  @Link @Watch('itemDataFunction')itemData:folderList
  @State pushReminder:boolean = false
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'重命名',$r('app.media.edit')),
    new buttonList(2,'置顶',$r('app.media.top')),
    new buttonList(3,'移动至',$r('app.media.folder')),
    new buttonList(4,'加入书单',$r('app.media.shelf')),
    new buttonList(5,'封面样式',$r('app.media.style_icon')),
    new buttonList(6,'隐藏分组',$r('app.media.hide')),
    new buttonList(7,'解散分组',$r('app.media.disband')),
    new buttonList(8,'删除',$r('app.media.delete_svg'))
  ]
  itemDataFunction(){
    console.log(JSON.stringify(this.itemData))
  }
  cancel: () => void = () => {
  }

  build() {
    Column(){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }){
        Column(){
          Text(this.itemData.title).fontColor('rgba(0, 0, 0, 0.88)').fontSize(16).fontWeight(500).lineHeight(24)
          Text(`共${(this.itemData.countNumber)}本`).fontColor('rgba(0, 0, 0, 0.45)').fontWeight(400).lineHeight(20).fontSize(12)
        }
        Row(){
          Text('更新提醒')
          Toggle({ type: ToggleType.Switch, isOn: this.itemData.isUpdateReminder})
            .selectedColor("#F60").hoverEffect(HoverEffect.None)
            .onChange(()=>{
              this.itemData.isUpdateReminder = !this.itemData.isUpdateReminder
            })
        }
      }.padding(20)
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