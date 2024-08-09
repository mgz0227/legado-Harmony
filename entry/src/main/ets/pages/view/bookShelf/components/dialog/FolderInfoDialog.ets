import bookGroupUtil from '../../../../../common/utils/bookGroupUtils'
import commonInputDialog from '../../../../../componets/common/commonInputDialog'
import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import InsideCircleIcon from '../../../../../componets/common/InsideCircleIcon'
import { showMessage } from '../../../../../componets/common/promptShow'
import TitleContentDialog from '../../../../../componets/common/TitleContentDialog'
import { buttonList } from '../../../../../componets/dataList/buttonList'
import { BookGroups } from '../../../../../database/entities/BookGroups'
import catalogAddShelf from '../../Manage/components/catalogAddShelf'
import BookSelectGroupDialog from './BookSelectGroupDialog'
import coverInfoDialog from './coverInfoDialog'

@CustomDialog
/**
 * 文件夹长按弹窗
 */
export default struct FolderInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  @Prop itemData:BookGroups
  @State pushReminder:boolean = false
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'重命名',$r('app.media.edit')),
    new buttonList(2,'置顶',$r('app.media.top')),
    new buttonList(3,'移动至',$r('app.media.folder')),
    new buttonList(4,'加入书单',$r('app.media.shelf')),
    new buttonList(5,'封面样式',$r('app.media.style_icon')),
    new buttonList(6, this.itemData.show?'隐藏分组':'显示分组',this.itemData.show?$r('app.media.hide'):$r('app.media.show')),
    new buttonList(7,'解散分组',$r('app.media.disband')),
    new buttonList(8,'删除',$r('app.media.ic_public_delete'))
  ]
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  cancel: () => void = () => {

  }

  @State isCatalogAddShelf:boolean = false


  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  @StorageLink('BOOK_IS_BOOK_GROUPS_REFRESHING') BOOK_IS_BOOK_GROUPS_REFRESHING: number = 0
  @State topTitle:string = this.itemData.isTop?'取消置顶':'置顶'
  build() {
    Column(){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }){
        Column(){
          Text(this.itemData.groupName).fontColor('rgba(0, 0, 0, 0.88)').fontSize(16).fontWeight(500).lineHeight(24)
          Text(`共${this.itemData.bookIds?.length||0}本`).fontColor('rgba(0, 0, 0, 0.45)').fontWeight(400).lineHeight(20).fontSize(12)
        }
        Row(){
          Text('更新提醒')
          Toggle({ type: ToggleType.Switch, isOn: this.itemData.canUpdate})
            .selectedColor("#F60").hoverEffect(HoverEffect.None)
            .onChange((val)=>{
              this.itemData.canUpdate = val
              bookGroupUtil.updatePartialGroup(this.itemData)
              setTimeout(()=>{
                this.BOOK_IS_BOOK_GROUPS_REFRESHING++
                showMessage('修改成功!')
              },100)
            })
        }
      }.padding(20)
      Divider().strokeWidth(0.5).padding({bottom:16})
      GridRow({
        columns:4
      }){
        ForEach(this.buttonListInfo,(item:buttonList)=>{
          GridCol(){
            if (item.id === 2){
              InsideCircleIcon({
                icon:item.icon,
                title:this.topTitle
              })
                .onClick(()=>{
                  this.folderInfo(item.id)
                })
            } else {
              InsideCircleIcon({
                icon:item.icon,
                title:item.title
              })
                .onClick(()=>{
                  this.folderInfo(item.id)
                })
            }
          }
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
      Flex()
        .bindSheet($$this.isCatalogAddShelf, this.dialogCatalogAddShelf(), {
          height:400,
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isCatalogAddShelf = false
          }
        })
    }
    .borderRadius({topLeft:20,topRight:20})
    .backgroundColor(Color.White)
    .width('100%')
  }

  //书单弹窗
  @Builder dialogCatalogAddShelf(){
    Column(){
      catalogAddShelf({
        onClickShelf:(val:boolean)=>{
          this.isCatalogAddShelf = val
        },
        currentIndex:this.itemData.groupType,
        ids:this.itemData.groupId?[this.itemData.groupId]:[],
        bookOrFolder:1
      })
    }
  }

  folderInfo(id:number){
    switch (id){
      case 1 :
        this.restTitle(); break;
      case 2 :
        this.isFolderTop(); break;
      case 3 :
        this.bookMoveGroup?.open(); break;
      case 4 :
        this.isCatalogAddShelf = true;break;
      case 5 :
        this.coverDialog?.open();
        break;
      case 6 :
        showMessage('隐藏分组');
        if (this.itemData.show) {
          this.dialogTitle = this.dialogHideTitle;
          this.dialogContent = this.dialogHideContent;
        } else {
          this.dialogTitle = '显示分组'
          this.dialogContent = ''
        }
        this.hideDisbandDelDialog?.open();
        break;
      case 7 :
        showMessage('解散分组');
        this.dialogTitle = this.dialogDisbandTitle;
        this.dialogContent = this.dialogDisbandContent;
        this.hideDisbandDelDialog?.open();
        break;
      case 8 :
       this.groupDelDialog?.open(); break;
    }
  }
  //打开重名弹窗
  restTitle(){
    this.restTitleDialog?.open()
    this.inputValue = this.itemData.groupName
  }
  //置顶/取消置顶
  isFolderTop(){
    if (this.itemData.groupId) {
      bookGroupUtil.isTopGroup(this.itemData.groupId, !this.itemData.isTop)
      this.itemData.isTop = !this.itemData.isTop
    }

    setTimeout(() => {
      showMessage(this.itemData.isTop? '置顶成功' : '取消置顶成功')
      this.topTitle = this.itemData.isTop?'取消置顶':'置顶'
      this.BOOK_IS_BOOK_GROUPS_REFRESHING++
    },500)
  }
  //重命名弹窗
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
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 25
  })

  restTitleCancel(){
    this.restTitleDialog?.close()
    this.inputValue = ''
  }

  async restTitleConfirm(){
    let result = await bookGroupUtil.onlyGroupUpdateName(this.inputValue, this.itemData.groupId ?? 0)
    if (result) {
      this.itemData.groupName = this.inputValue
      showMessage('重命名成功')
      setTimeout(() => {
        this.BOOK_IS_BOOK_GROUPS_REFRESHING++
      },500)
    } else {
      showMessage('已存在其它相同分组名')
    }
    this.inputValue = ''
    this.restTitleDialog?.close()
  }

  //移动分组弹窗
  bookMoveGroup: CustomDialogController | null = new CustomDialogController({
    builder: BookSelectGroupDialog({
      moveGroup: ()=> {
        setTimeout(()=>{
          this.isBookRefreshing++
          this.BOOK_IS_BOOK_GROUPS_REFRESHING++
        },500)
        this.bookMoveGroup?.close()
      },
      oldGroupId:this.itemData.groupId,
      currentIndex:this.itemData.groupType,
      Ids:this.itemData.groupId,
      isMoveStatus: 1
    }),
    height: 400,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  @State delCache:boolean = false
  //删除分组弹窗
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
  //删除分组
  deleteGroup() {
    if (this.itemData.groupId) {
      bookGroupUtil.delGroupById(this.itemData.groupId)
    }
    this.cancel()
    setTimeout(()=>{
      this.BOOK_IS_BOOK_GROUPS_REFRESHING++
      showMessage('删除成功')
    },500)
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
  //显示/隐藏
  hideOrDisband(){
    if (this.dialogTitle === '隐藏分组' || this.dialogTitle === '显示分组') {
      this.hideGroup()
    } else {
      this.disbandGroup()
    }
  }
  //解散分组
  disbandGroup(){
    bookGroupUtil.delGroupById(this.itemData.groupId ?? [])
    setTimeout(()=>{
      this.BOOK_IS_BOOK_GROUPS_REFRESHING++
      this.cancel()
      showMessage('解散分组成功')
    },500)
  }

  //隐藏分组
  hideGroup(){
    this.itemData.show = this.itemData.show ? false : true
    if (this.itemData.groupId) {
      bookGroupUtil.updateGroupShow(this.itemData.groupId)
    }
    setTimeout(()=>{
      this.BOOK_IS_BOOK_GROUPS_REFRESHING++
      this.cancel()
      showMessage(this.itemData.show ? '隐藏成功' : '显示成功')
    },500)
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