import commonInputDialog from '../../../componets/common/commonInputDialog'
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { showMessage } from '../../../componets/common/promptShow'
import { buttonList } from '../../../componets/dataList/buttonList'
import { folderList } from '../../../componets/dataList/folderList'
import { updateBookListData } from '../../../storage/bookListData'

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
    new buttonList(8,'删除',$r('app.media.ic_public_delete'))
  ]
  itemDataFunction(){
    console.log('变动了' + JSON.stringify(this.itemData))
    //TODO 监听到变动将分组缓存更新
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
          InsideCircleIcon({
            item:item
          })
            .onClick(()=>{
              this.folderInfo(item.id)
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

  folderInfo(id:number){
    switch (id){
      case 1 :
        this.restTitle(); break;
      case 2 :
        showMessage('置顶'); break;
      case 3 :
        showMessage('移动至'); break;
      case 4 :
        showMessage('加入书单'); break;
      case 5 :
        showMessage('封面样式'); break;
      case 6 :
        showMessage('隐藏分组'); break;
      case 7 :
        showMessage('解散分组'); break;
      case 8 :
        showMessage('删除'); break;
    }
  }
  restTitle(){
    this.restTitleDialog?.open()
    this.inputValue = this.itemData.title
  }

  @State inputValue:string = ''
  restTitleDialog: CustomDialogController | null = new CustomDialogController({
    builder: commonInputDialog({
      textValue:this.inputValue,
      cancel: () => {
        this.restTitleCancel()
      },
      confirm: () => {
        this.restTitleConfirm()
      },
      placeholder:'请输入分组名称',
      title:'重命名'
    }),
    gridCount: 4,
    cancel: this.restTitleCancel,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 25
  })

  restTitleCancel(){
    this.restTitleDialog?.close()
    this.inputValue = ''
  }
  restTitleConfirm(){
    console.log(this.inputValue + 'inputValue')
    this.itemData.title = this.inputValue
    this.inputValue = ''
    showMessage('重命名成功')
    console.log(JSON.stringify(this.itemData))
    console.log(JSON.stringify(this.itemData.title))
    this.restTitleDialog?.close()
  }
}