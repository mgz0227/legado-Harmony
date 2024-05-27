import commonInputDialog from '../../../componets/common/commonInputDialog'
import confirmDialogExample from '../../../componets/common/confirmDialog'
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { showMessage } from '../../../componets/common/promptShow'
import TitleContentDialog from '../../../componets/common/TitleContentDialog'
import { buttonList } from '../../../componets/dataList/buttonList'
import { folderList } from '../../../componets/dataList/folderList'
import { updateBookListData } from '../../../storage/bookListData'
import { delGroupById } from '../../../storage/groupData'
import coverInfoDialog from './coverInfoDialog'

@CustomDialog
/**
 * 文件夹长按弹窗
 */
export default struct FolderInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  @Link itemData:folderList
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
        showMessage('置顶'); this.isFolderTop(); break;
      case 3 :
        showMessage('移动至'); break;
      case 4 :
        showMessage('加入书单'); break;
      case 5 :
        showMessage('封面样式');
        this.coverDialog?.open();
        break;
      case 6 :
        showMessage('隐藏分组');
        this.dialogTitle = this.dialogHideTitle;
        this.dialogContent = this.dialogHideContent;
        this.hideDisbandDelDialog?.open();
        break;
      case 7 :
        showMessage('解散分组');
        this.dialogTitle = this.dialogDisbandTitle;
        this.dialogContent = this.dialogDisbandContent;
        this.hideDisbandDelDialog?.open();
        break;
      case 8 :
        showMessage('删除'); this.groupDelDialog?.open(); break;
    }
  }
  restTitle(){
    this.restTitleDialog?.open()
    this.inputValue = this.itemData.title
  }

  isFolderTop(){
    this.itemData.isTop = true
    this.itemData.topUpdateTime = new Date()
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

  @State delCache:boolean = false
  //弹窗
  groupDelDialog: CustomDialogController | null = new CustomDialogController({
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
    delGroupById(this.itemData.id)
    this.cancel()
  }

  exitApp() {
    this.groupDelDialog?.close()
  }
  @State dialogTitle:string = ''
  @State dialogContent:string = ''

  @State dialogHideTitle:string = '隐藏分组'
  @State dialogHideContent:string = '隐藏后可点击分组标签栏右侧分组管理入口查看隐藏分组并进入'
  @State dialogDisbandTitle:string = '解散分组'
  @State dialogDisbandContent:string = '解散分组后，原组内书籍不会被删除，将自动移动至未分组'

  //隐藏、解散分组弹窗
  hideDisbandDelDialog: CustomDialogController | null = new CustomDialogController({
    builder: TitleContentDialog({
      confirm: ()=> { this.hideOrDisband() },
      title:this.dialogTitle,
      content:this.dialogContent
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  hideOrDisband(){
    if (this.dialogTitle === '隐藏分组') {
      this.hideGroup()
    } else {
      this.disbandGroup()
    }
  }

  disbandGroup(){
    //TODO 删除分组将原来小说分类类型置为空
  }
  //隐藏分组
  hideGroup(){
    this.itemData.isShow = true
    this.cancel()
  }

  coverDialog: CustomDialogController | null = new CustomDialogController({
    builder: coverInfoDialog({
      itemData:this.itemData,
      cancel:()=>{
        this.coverCancel()
      }
    }),
    cancel: this.coverCancel,
    autoCancel: true,
    width:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true
  })

  coverCancel(){
    this.coverDialog?.close()
  }

}