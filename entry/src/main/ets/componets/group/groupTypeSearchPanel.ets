import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'
import BookGroupsDao from '../../database/dao/BookGroupsDao'
import { BookGroups } from '../../database/entities/BookGroups'
import BookManageDialog from '../../pages/view/bookShelf/components/dialog/BookManageDialog'
import { showMessage } from '../common/promptShow'


@Component
export default struct groupTypeSearchPanel{
  @Link groupCoverShow:boolean
  @Prop showGroupList:BookGroups[] = []
  @State hideList:BookGroups[] = []
  @Prop currentIndex:number = 0
  @Prop clickGroup:BookGroups
  @Link searchBookList:number[]
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
          Image($r('app.media.close')).width(24).height(20).onClick(()=>{
            this.groupCoverShow = false
          })
        }
      }

      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
        justifyContent:FlexAlign.Start
      }){
        ForEach(this.showGroupList,(item:BookGroups,index:number)=>{
          if (item.show && item.show && item.groupId != 1 && item.groupId != 5) {
            Row(){
              if (index === 0){
                this.GroupTypeColor(item.groupName)
              } else {
                this.GroupType(item.groupName)
              }
            }.width('25%')
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
          Text('点击进入').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
        }.alignItems(VerticalAlign.Bottom)
      }
      if (this.hideList.length > 0){
        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center
        }){
          ForEach(this.hideList, (item: BookGroups,index:number) => {
              Row(){
                this.GroupType(item.groupName)
              }
              .onClick(()=>{
                this.clickGroup = item
                this.isShowBookFolderInfoDialog = true
              })
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
  @State isShowBookFolderInfoDialog:boolean = false
  @Builder bookFolderInfoDialog(){
    Column(){
      BookManageDialog({
        title:this.clickGroup.groupName,
        currentIndex:this.currentIndex,
        bookTypeNumber:this.clickGroup.groupId,
        isManage:true,
        isManageSearch:true,
        searchCheck:(val:number[])=>{
          this.searchBookList = val
          this.isShowBookFolderInfoDialog = false
        }
      })
    }
  }

}