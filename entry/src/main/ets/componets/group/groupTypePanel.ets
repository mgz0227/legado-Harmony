import FolderInfoDialog from '../../pages/view/dialog/FolderInfoDialog'
import FolderManageDialog from '../../pages/view/dialog/FolderManageDialog'
import { updateAppData } from '../../storage/appData'
import { updateDateGroup } from '../../storage/groupData'
import customizeDialogExample from '../common/customizeDialog'
import { showMessage } from '../common/promptShow'
import { folderList } from '../dataList/folderList'

@Component
export default struct groupTypePanel{
  @Link groupCoverShow:boolean
  @State isShowIcon:boolean = false
  @State groupType:string[] = ['分组','全部','未分组','本地','书单']
  @State groupTypes:string[] = []
  @State hideGroupType:string[] = ['游戏','玄幻','都市', '历史', '军事', '科幻', '灵异', '二次元', '耽美', '同人']

  @StorageProp('GROUP_LIST_DATA') groupData:folderList[] = []

  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = true
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
          Text(this.isShowIcon?'完成':'管理').fontSize(12).fontWeight(400).lineHeight(20).fontColor($r('app.color.theme_color'))
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
        ForEach(this.groupTypes.length > 0?this.groupTypes:this.groupType,(item:string,index:number)=>{
          if (index === 0) {
            Row(){
              this.GroupTypeColor(item)
              if (this.isShowIcon) {
                Image($r('app.media.sort')).width(12).height(12).offset({x:-20,y:-20})
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
              this.groupTypes = []
            })

          } else {
            Row(){
              this.GroupType(item)
              if (this.isShowIcon) {
                Image($r('app.media.sort')).width(12).height(12).offset({x:-20,y:-20})
              }
            }.width('25%')
            .draggable(this.isShowIcon)
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.dragIndex = index // 获取当前拖拽子组件的索引
                console.info('onTouch' + this.dragIndex)
              }
            })
            .onDragStart(()=>{
              console.log('onDragStart')
            })
            .onDrop((event: DragEvent, extraParams: string) => {
              console.log('onDrop')
              this.changeIndex(this.dragIndex, index,0)
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
            .selectedColor("#F60").hoverEffect(HoverEffect.None)
            .onChange(()=>{
              updateAppData(this.APP_INDEX_SCROLLABLE)
              showMessage(this.APP_INDEX_SCROLLABLE?'标签栏锁已开启':'标签栏已解锁')
            })
        }.alignItems(VerticalAlign.Bottom).justifyContent(FlexAlign.End)
      }
      if (this.hideGroupType.length > 0){
        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center
        }){
          ForEach(this.groupData, (item: folderList,index:number) => {
              Row(){
                this.GroupType(item.title)
                if (this.isShowIcon) {
                  Image($r('app.media.add_new_fill')).width(12).height(12).offset({x:-20,y:-20})
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
                this.group = item
                this.isShowBookFolderInfoDialog = true
                this.folderType = item.title
              })
              .gesture(
                LongPressGesture({ repeat: true,duration:500 })
                  .onAction((event: GestureEvent) => {
                    if (event.repeat) {
                      if (!this.isShow) {
                        this.group = item
                        this.isShow = true
                        this.changeNumber = 1
                        this.groupInfoDialog?.open()
                      }
                    }
                  }))
              .width('25%')
          })
        }
        .bindSheet($$this.isShowBookFolderInfoDialog, this.bookFolderInfoDialog(), {
          detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
          showClose: false,
          dragBar: true,
          maskColor: 'rgba(0,0,0,0.6)',
          onDisappear:()=>{
            console.log('隐藏')
          }
        })

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
    //@State hideGroupType:string[] = ['游戏','玄幻','都市', '历史', '军事', '科幻', '灵异', '二次元', '耽美', '同人']
    //hideGroupType数组位置交换
    if (!this.isShowIcon) {
      showMessage('请在管理状态下拖到改变顺序')
      return
    }
    console.log('changeIndex' + index1 + ',' + index2)
    switch (type){
      case 0:
        let temp1 = this.groupType[index1];
        this.groupType[index1] = this.groupType[index2];
        this.groupType[index2] = temp1;break;
      case 1:
        let temp = this.hideGroupType[index1];
        this.hideGroupType[index1] = this.hideGroupType[index2];
        this.hideGroupType[index2] = temp;break;
    }
  }
  @Builder GroupTypeColor(title:string){
    Column(){
      Row(){
        Text(title).fontWeight(500).fontSize(12).textOverflow({
          overflow:TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END)
          .maxLines(1).fontColor($r('app.color.theme_color'))
          .textAlign(TextAlign.Center)
      }
      .margin({ right: 16, bottom: 16 })
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width(68)
      .backgroundColor('rgba(252, 121, 0, 0.12)')
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
       // Image($r('app.media.sort')).width(12).height(12).offset({x:18,y:-12})
     }
     // .backgroundImage($r('app.media.sort'))
     // .backgroundImagePosition({x:-12,y:12})
     // .backgroundImageSize({width:'100%',height:12})
     .margin({ right: 16, bottom: 16 })
     .justifyContent(FlexAlign.Center)
     .alignItems(VerticalAlign.Center)
     .width(68)
     .backgroundColor('rgba(0, 0, 0, 0.04)').padding({left:16,right:16,top:6,bottom:6})
   }
  }

  @State @Watch('watchFolder')group:folderList = new folderList(0,'',0,$r('app.media.folder_test'),'')
  @State changeNumber:number = 0
  @State isShow:boolean = false
  groupInfoDialog: CustomDialogController | null = new CustomDialogController({
    builder: FolderInfoDialog({
      itemData:this.group,
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
    this.groupInfoDialog?.close()
  }

  watchFolder(){
    if (this.changeNumber === 1) {
      updateDateGroup(this.group)
    }
  }
  @State isShowBookFolderInfoDialog:boolean = false
  @State folderType:string = ''
  @Builder bookFolderInfoDialog(){
    Column(){
      FolderManageDialog({
        folderType:this.folderType
      })
    }.padding(15)
  }

}