import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'
import bookGroupUtil from '../../common/utils/bookGroupUtils'
import BookGroupsDao from '../../database/dao/BookGroupsDao'
import { BookGroups } from '../../database/entities/BookGroups'
import BookManageDialog from '../../pages/view/bookShelf/components/dialog/BookManageDialog'
import FolderInfoDialog from '../../pages/view/bookShelf/components/dialog/FolderInfoDialog'
import { updateAppData } from '../../storage/appData'
import customizeDialogExample from '../common/customizeDialog'
import hideDialogExample from '../common/hideDialog'
import { showMessage } from '../common/promptShow'

@Component
export default struct groupTypePanel{
  @Link groupCoverShow:boolean
  @State isShowIcon:boolean = false
  @Prop showGroupList:BookGroups[] = []
  @State hideList:BookGroups[] = []
  @Prop currentIndex:number = 0

  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = true
  @Prop clickGroup:BookGroups
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  aboutToAppear(): void {
    this.getGroupList()
  }

  getGroupList(){
    BookGroupsDao.searchHide({
      type:this.currentIndex,
      show: false
    }).then((val)=>{
      this.hideList = val
    })
  }

  build() {
    Column({
      space:15
    }){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.End
      }){
        Row({space:12}){
          Text('显示分组').fontSize(16).fontWeight(500).lineHeight(24).fontColor('rgba(0, 0, 0, 0.88)')
          Text('点击进入').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
        }.alignItems(VerticalAlign.Bottom)
        Row({space:12}){
          Text(this.isShowIcon?'完成':'管理').fontSize(12).fontWeight(400).lineHeight(20).fontColor(this.theme.mainColor)
            .onClick(()=>{
              this.isShowIcon = !this.isShowIcon
            })
          Image($r('app.media.close')).width(24).height(20).onClick(()=>{
            this.groupCoverShow = false
            this.isShowIcon = false
          })
        }
      }

      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
        justifyContent:FlexAlign.Start
      }){
        ForEach(this.showGroupList,(item:BookGroups,index:number)=>{
          if (item.show) {
            Row(){
              if (index === 0){
                this.GroupTypeColor(item.groupName)
              } else {
                this.GroupType(item.groupName)
              }
              if (this.isShowIcon) {
                Image(!item.isSystem?$r('app.media.clear'):$r('app.media.sort')).width(12).height(12).offset({x:-20,y:-20})
                  .onClick(()=>{
                    if (!item.isSystem && item.groupId) {
                      this.isHide = true
                      this.checkListNumber = item.groupId
                      this.clickHideDialog?.open()
                    }
                  })
              }
            }.width('25%')
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.dragIndex = index // 获取当前拖拽子组件的索引
                console.info('onTouch' + this.dragIndex)
              }
            })
            .draggable(this.isShowIcon)
            .onDragStart(()=>{
              console.log('onDragStart')
            })
            .onDrop((event: DragEvent, extraParams: string) => {
              console.log('onDrop')
              this.changeIndex(this.dragIndex, index,0)
            })
            .onClick(() => {
              this.clickGroup = item
              this.isShowBookFolderInfoDialog = true
            })
          }
        })
      }

      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.End
      }){
        Row({space:12}){
          Text('隐藏分组').fontSize(16).fontWeight(500).lineHeight(24).fontColor('rgba(0, 0, 0, 0.88)')
          Text('点击进入,长按编辑').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
        }.alignItems(VerticalAlign.Bottom)
        Row({space:8}){
          Image($r('app.media.help')).width(20).height(20).onClick(()=>{
            this.tagLockDialog?.open()
          })
          Text('标签锁').fontSize(16).fontWeight(500).lineHeight(24).fontColor('rgba(0, 0, 0, 0.45)')
          Toggle({ type: ToggleType.Switch, isOn: $$this.APP_INDEX_SCROLLABLE})
            .selectedColor(this.theme.mainColor).hoverEffect(HoverEffect.None)
            .onChange(()=>{
              updateAppData(this.APP_INDEX_SCROLLABLE)
              showMessage(this.APP_INDEX_SCROLLABLE?'标签栏锁已开启':'标签栏已解锁')
            })
        }.alignItems(VerticalAlign.Bottom).justifyContent(FlexAlign.End)
      }
      if (this.hideList.length > 0){
        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center
        }){
          ForEach(this.hideList, (item: BookGroups,index:number) => {
              Row(){
                this.GroupType(item.groupName)
                if (this.isShowIcon) {
                  Image($r('app.media.add_new_fill')).width(12).height(12).offset({x:-20,y:-20})
                    .onClick(() => {
                      if (item.groupId) {
                        this.isHide = false
                        this.checkListNumber = item.groupId
                      }
                      this.clickHideDialog?.open()
                    })
                }
              }
              .onTouch((event: TouchEvent) => {
                if (event.type === TouchType.Down) {
                  this.dragIndex = index // 获取当前拖拽子组件的索引
                  console.info('onTouch' + this.dragIndex)
                }
              })
              .draggable(this.isShowIcon)
              .onDragStart(()=>{
                console.log('onDragStart')
              })
              .onDrop((event: DragEvent, extraParams: string) => {
                console.log('onDrop')
                this.changeIndex(this.dragIndex, index,1)
              })
              .onClick(()=>{
                this.clickGroup = item
                this.isShowBookFolderInfoDialog = true
              })
              .gesture(
                LongPressGesture({ repeat: true,duration:500 })
                  .onAction((event: GestureEvent) => {
                    if (event.repeat) {
                      if (!this.isShow) {
                        this.dialogGroupData = item
                        // this.group = item
                        this.isShow = true
                        this.changeNumber = 1
                        this.groupInfoDialog?.open()
                      }
                    }
                  }))
              .width('25%')
          })
        }
      } else {
        Flex({
          justifyContent:FlexAlign.Center
        }){
          Text('暂无隐藏分组').fontSize(12).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
        }
        .borderRadius(4)
        .width('100%')
        .backgroundColor('rgba(0, 0, 0, 0.04)')
        .padding({top:6,bottom:6})

      }
      Flex()
        .bindSheet($$this.isShowBookFolderInfoDialog, this.bookFolderInfoDialog(), {
          detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
          showClose: false,
          dragBar: true,
          maskColor: 'rgba(0,0,0,0.6)',
          onDisappear:()=>{
            console.log('隐藏')
          }
        })

    }
    .offset({y:-15})
    .borderRadius({bottomLeft:20,bottomRight:20})
    .padding({left:15,right:15,top:12,bottom:20})
    .width('100%').backgroundColor(Color.White)
  }
  @State tagLockContent:string = '长按底部tab栏书架图标可锁定分组标签栏，再次长按解锁，锁定后左右滑动将直接切换小说，漫画，有声书分组大类。'
  tagLockDialog: CustomDialogController | null = new CustomDialogController({
    builder: customizeDialogExample({
      confirm: ()=> { this.onAccept() },
      title: '标签锁',
      content:this.tagLockContent
    }),
    width:'90%',
    autoCancel: true,
    alignment: DialogAlignment.Center,
    // offset: { dx: 0, dy: '-40%' },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25
  })

  onAccept() {
    this.tagLockDialog?.close()
  }

  @State dragIndex: number = 0
  changeIndex(index1: number, index2: number,type:number = 2) { // 交换数组位置
    if (!this.isShowIcon) {
      showMessage('请在管理状态下拖到改变顺序')
      return
    }
    console.log('changeIndex' + index1 + ',' + index2)
    //TODO 更新排序顺序到数据库中sort
  }
  @Builder GroupTypeColor(title:string){
    Column(){
      Row(){
        Text(title).fontWeight(500).fontSize(12).textOverflow({
          overflow:TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END)
          .maxLines(1).fontColor(this.theme.mainColor)
          .textAlign(TextAlign.Center)
      }
      .margin({ right: 16, bottom: 16 })
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width(68)
      .backgroundColor(this.theme.secondColor)
      .padding({left:16,right:16,top:6,bottom:6})
    }
  }
  @Builder GroupType(title:string){
   Column(){
     Row(){
       Text(title).fontWeight(500).fontSize(12).textOverflow({
         overflow:TextOverflow.Ellipsis
       }).ellipsisMode(EllipsisMode.END)
         .maxLines(1).fontColor(Color.Black)
         .textAlign(TextAlign.Center)
     }
     .margin({ right: 16, bottom: 16 })
     .justifyContent(FlexAlign.Center)
     .alignItems(VerticalAlign.Center)
     .width(68)
     .backgroundColor('rgba(0, 0, 0, 0.04)').padding({left:16,right:16,top:6,bottom:6})
   }
  }

  @State changeNumber:number = 0
  @State isShow:boolean = false
  @State dialogGroupData:BookGroups = new BookGroups()
  groupInfoDialog: CustomDialogController | null = new CustomDialogController({
    builder: FolderInfoDialog({
      itemData:this.dialogGroupData,
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
    this.changeNumber = 0
    this.isShow = false
    this.getGroupList()
    this.groupInfoDialog?.close()
  }

  @State isShowBookFolderInfoDialog:boolean = false
  @Builder bookFolderInfoDialog(){
    Column(){
      BookManageDialog({
        title:this.clickGroup.groupName,
        currentIndex:this.currentIndex,
        bookTypeNumber:this.clickGroup.groupId,
      })
    }
  }
  //需要显示的Id
  @State checkListNumber:number = 0
  @State isHide:boolean = false
  @StorageLink('BOOK_IS_BOOK_GROUPS_REFRESHING') BOOK_IS_BOOK_GROUPS_REFRESHING: number = 0
  //是否隐藏分组弹窗
  clickHideDialog: CustomDialogController | null = new CustomDialogController({
    builder: hideDialogExample({
      confirm: ()=> { this.clickHideAccept() },
      isHide: this.isHide
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })
  //隐藏操作
  clickHideAccept() {
    bookGroupUtil.updateGroupShow(this.checkListNumber,!this.isHide)
    setTimeout(()=>{
      this.getGroupList()
      this.BOOK_IS_BOOK_GROUPS_REFRESHING++
      showMessage('显示成功')
    },500)
    this.checkListNumber = 0
    this.isHide = false
  }

}