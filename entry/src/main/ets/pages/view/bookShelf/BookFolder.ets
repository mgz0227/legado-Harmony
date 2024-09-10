import { it } from '@ohos/hypium'
import BookOverlay from '../../../componets/bookDetail/BookOverlay'
import { showMessage } from '../../../componets/common/promptShow'
import { folderList } from '../../../componets/dataList/folderList'
import BookGroupsDao from '../../../database/dao/BookGroupsDao'
import { BookGroups } from '../../../database/entities/BookGroups'
import BookManageDialog from './components/dialog/BookManageDialog'
import FolderInfoDialog from './components/dialog/FolderInfoDialog'

/**
 * 文件夹
 */
@Component
export default struct BookFolder {
  @Prop EXHIBIT:string
  currentIndex:number = 0
  @State changeNumber:number = 0
  @State isShowBookFolderInfoDialog:boolean = false
  @StorageLink('BOOK_IS_BOOK_GROUPS_REFRESHING') @Watch('getGroupList')BOOK_IS_BOOK_GROUPS_REFRESHING: number = 0

  aboutToAppear(): void {
    this.getGroupList()
  }
  @State groupList:BookGroups[] = []
  getGroupList(){
    BookGroupsDao.search({
      type:this.currentIndex
    }).then((val)=>{
      this.groupList = val
    })
  }
  @State isShow:boolean = false


  build() {
    GridRow({
      columns:this.EXHIBIT === '宫格'?3:1
    }){
      ForEach(this.groupList,(item:BookGroups)=>{
        if(item.show && !item.isSystem){
          GridCol(){
            Column(){
              if (this.EXHIBIT === '宫格'){
                this.bookInfoGrid(item)
              } else {
                this.bookFolderInfo(item)
              }
            }
          }
          .gesture(
            LongPressGesture({ repeat: true,duration:500 })
              .onAction((event: GestureEvent) => {
                if (event.repeat) {
                  if (!this.isShow) {
                    this.dialogGroupData = item
                    this.isShow = true
                    this.changeNumber = 1
                    this.groupInfoDialog?.open()
                  }
                }
              }))
          .onClick(()=>{
            this.isShowBookFolderInfoDialog = true
            this.clickGroup = item
          })
        }
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
  @Prop clickGroup:BookGroups
  @Builder bookFolderInfoDialog(){
    Column(){
      BookManageDialog({
        title:this.clickGroup.groupName,
        currentIndex:this.currentIndex,
        bookTypeNumber:this.clickGroup.groupId,
      })
    }
  }

  @Builder bookInfoGrid(item: BookGroups){
    Column({
      space:5
    }) {
      Column(){
        Column(){
          Stack(){
            Stack(){
              Stack(){
                if (item.isTop){
                  Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
                    .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
                }
                Image(item.coverUrl)
                  .draggable(false)
                  .alt($r('app.media.icon_book_default_cover_one'))
                  .width(88)
                  .height(120)
              }.alignContent(Alignment.BottomStart)
            }
            .zIndex(2)

            if (item.coverType !== 2){
              Row(){
                Image($r('app.media.occlusion1')).draggable(false)
              }
              .zIndex(1)
              .width(95).height(110)

              Row(){
                Image($r('app.media.occlusion2'))
              }.zIndex(0)
              .width(100).height(100)
            }
          }
          .align(Alignment.BottomStart)
        }

        Row().width(100).height(20).backgroundColor('rgba(255, 255, 255, 0.6)').borderRadius(10)
      }
      Text(item.groupName)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)
      Text(`共${item.bookIds?.length||0}本`).fontSize(12).fontColor('rgb(174,174,174)')
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .fontWeight(500)
        .maxLines(1)
    }
    .borderRadius(8)
    .alignItems(HorizontalAlign.Start)
    .padding({ left:8,right:8,bottom:5,top:5 })
  }

  @Builder bookFolderInfo(group:BookGroups){
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
          bookImage:group.coverUrl,
          isTop:group.isTop,
          coverType:group.coverType
        })
        Column({
          space:24
        })
        {
          Text(group.groupName)
            .fontWeight(700)
          Column(){
            Text(`共${group.bookIds?.length||0}本`).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(400)
              .maxLines(1)
              .lineHeight(20)
            // Text(group.newUpdateBook?group.newUpdateBook:'暂无更新')
            //   .fontSize(12)
            //   .fontWeight(400)
            //   .textOverflow({
            //     overflow:TextOverflow.Ellipsis
            //   })
            //   .ellipsisMode(EllipsisMode.END)
            //   .maxLines(1)
            //   .lineHeight(20)
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
    this.isShow = false
    this.changeNumber = 0
    this.groupInfoDialog?.close()
  }

}