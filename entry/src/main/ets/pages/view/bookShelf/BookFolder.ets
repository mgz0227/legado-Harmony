import { it } from '@ohos/hypium'
import BookOverlay from '../../../componets/bookDetail/BookOverlay'
import { showMessage } from '../../../componets/common/promptShow'
import { folderList } from '../../../componets/dataList/folderList'
import { updateDateGroup } from '../../../storage/groupData'
import FolderInfoDialog from '../dialog/FolderInfoDialog'
import FolderManageDialog from '../dialog/FolderManageDialog'

/**
 * 文件夹
 */
@Component
export default struct BookFolder {
  @Prop EXHIBIT:string
  @State groupCheckList:folderList[] = []
  @State isShow:boolean = false
  @State @Watch('watchFolder')group:folderList = new folderList(0,'',0,$r('app.media.folder_test'),'')
  @StorageProp('GROUP_LIST_DATA') groupData:folderList[] = []
  @State changeNumber:number = 0

  watchFolder(){
    if (this.changeNumber === 1) {
      updateDateGroup(this.group)
    }
  }

  @State isShowBookFolderInfoDialog:boolean = false



  build() {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
      ForEach(this.groupData, (item: folderList,index:number) => {
        Column(){
          if(!item.isShow){
            if (this.EXHIBIT === '宫格'){
              this.bookInfoGrid(item)
            } else {
              this.bookFolderInfo(item)
            }
          }
        }
        .onClick(()=>{
          this.isShowBookFolderInfoDialog = true
          this.folderType = item.title
          showMessage(item.title)
        })
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
  }
  @State folderType:string = ''
  @Builder bookFolderInfoDialog(){
    Column(){
      FolderManageDialog({
        folderType:this.folderType
      })
    }.padding(15)
  }

  @Builder bookInfoGrid(item: folderList){
    Column({
      space:5
    }) {
      Column(){
        Column(){
          Stack(){
            Column(){

            }
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
            .width(88).height(120)
            .backgroundImage(item.bookImage)
            .backgroundImageSize({width:88,height:120})
            .zIndex(2)

            Row(){
              Image($r('app.media.occlusion1'))
            }
            .zIndex(1)
            .width(95).height(110)

            Row(){
              Image($r('app.media.occlusion2'))
            }.zIndex(0)
            .width(100).height(100)
          }
          .align(Alignment.BottomStart)
        }

        Row().width(100).height(20).backgroundColor('rgba(255, 255, 255, 0.6)').borderRadius(10)
      }
      Text(item.title)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)
      Text(`共${item.countNumber}本`).fontSize(12).fontColor('rgb(174,174,174)')
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .fontWeight(500)
        .maxLines(1)
    }
    .alignItems(HorizontalAlign.Start)
    .width('33%')
    .padding({ left:8,right:8,bottom:5,top:5 })
    .backgroundColor('rgba(244,244,244,0.8)')
  }

  @Builder bookFolderInfo(group:folderList){
    Flex(
      {
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.SpaceBetween
      }
    ) {
      Row({
        space:20
      }){
        BookOverlay({
          bookImage:group.bookImage,
          isTop:group.isTop
        })
          .gesture(
          LongPressGesture({ repeat: true,duration:500 })
            .onAction((event: GestureEvent) => {
              if (event.repeat) {

                if (!this.isShow) {
                  this.group = group
                  this.isShow = true
                  this.changeNumber = 1
                  this.groupInfoDialog?.open()
                }
              }
            }))
        Column({
          space:24
        })
        {
          Text(group.title)
            .fontWeight(700)
          Column(){
            Text(`共${group.countNumber}本`).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(400)
              .maxLines(1)
              .lineHeight(20)
            Text(group.newUpdateBook?group.newUpdateBook:'暂无更新')
              .fontSize(12)
              .fontWeight(400)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(1)
              .lineHeight(20)
          }
          .width('60%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
      }
    }
    .padding(10)
    .borderRadius(10)
  }


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
    this.isShow = false
    this.changeNumber = 0
    this.groupInfoDialog?.close()
    showMessage('退出了')
  }

}