/**
 * @author 2008
 * @datetime 2024/7/25 13:44
 * @className: BookSelectGroupDialog
 * 移动分组弹窗
 */
import CommonConstants from '../../../../../common/constants/CommonConstants'
import PaddingConstants from '../../../../../common/constants/PaddingConstants'
import addBookTypeDialog from '../../../../../componets/common/addBookTypeDialog'
import { showMessage } from '../../../../../componets/common/promptShow'
import TitleContentDialog from '../../../../../componets/common/TitleContentDialog'
import BookGroupsDao from '../../../../../database/dao/BookGroupsDao'
import BooksDao from '../../../../../database/dao/BooksDao'
import { BookGroups } from '../../../../../database/entities/BookGroups'

@Component
@CustomDialog
export default struct BookSelectGroupDialog{
  controller?: CustomDialogController
  currentIndex:number = 0
  booId:number = 0
  moveGroup:Function = ()=>{

  }
  @StorageLink('BOOK_IS_BOOK_GROUPS_REFRESHING') BOOK_IS_BOOK_GROUPS_REFRESHING: number = 0
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

  build() {
    Column() {
      Column(){
        Text('移动分组')
          .fontSize(16)
          .fontWeight(700)
          .lineHeight(24)

      }.padding({right:20,left:20,top:12,bottom:12})

      Divider().strokeWidth(0.5)
      Scroll(){
        GridRow({
          columns:3
        }){
          GridCol(){
            this.title()
          }
          ForEach(this.groupList,(item:BookGroups)=>{
            if (item.groupId && item.groupId > 5) {
              GridCol(){
                this.title(item)
              }
            }
          })
        }.padding(PaddingConstants.PADDING_20)
      }
      .align(Alignment.Top)
      .height('65%')
      .scrollBar(BarState.Off)
      Divider().strokeWidth(0.5)
      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(()=>{
        this.controller?.close()
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 32,
        right:32,
        top: 16
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }
  @State moveGroupId:number = 0
  @Builder title(item?:BookGroups) {
    Column() {
      if (item){
        Text(item.groupName).fontSize(14).textOverflow({
          overflow:TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END).maxLines(1)
      } else {
        Image($r('app.media.add')).width(24)
      }
    }
    .onClick(()=>{
      if(!item){
        this.addBookType?.open()
        return
      }
      if (item.groupId) {
        this.moveGroupId = item.groupId
        this.clickBookTypeDialog?.open()
      }
    })
    .margin({
      bottom:PaddingConstants.PADDING_16
    })
    .width(85).height(36)
    .backgroundColor('rgba(0, 0, 0,0.06)')
    .padding({
      left:16,
      right:16,
      top:8,
      bottom:8
    })
  }

  @State bookType:string = ''
  addBookType: CustomDialogController | null = new CustomDialogController({
    builder: addBookTypeDialog({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      bookType: this.bookType
    }),
    cancel: this.exitDialog,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25
  })
  //退出弹框
  exitDialog(){
    this.bookType = ''
  }
  //取消
  onCancel(){
    this.bookType = ''
  }
  //确定
  onAccept(){
    let isInsert = true
    //对比bookType看是否BooTypeList数组中存在
    this.groupList.forEach((element:BookGroups) => {
      if (element.groupName === this.bookType) {
        showMessage(`已存${this.bookType}分组`)
        this.bookType= ''
        isInsert = false
      }
    })
    if(isInsert){
      let bookGroups = new BookGroups()
      bookGroups.groupName = this.bookType
      bookGroups.groupType = this.currentIndex
      bookGroups.coverUrl = 'app.media.cover_list'
      BookGroupsDao.insert(bookGroups)
      this.bookType= ''
      showMessage(`已添加${this.bookType}分组`)
      setTimeout(()=>{
        this.BOOK_IS_BOOK_GROUPS_REFRESHING++
        this.getGroupList()
      },500)
    }
  }

  //是否确认移动分组
  clickBookTypeDialog: CustomDialogController | null = new CustomDialogController({
    builder: TitleContentDialog({
      confirm: ()=> {
        this.clickBookAccept()
      },
      title:`移动分组至${this.bookType}`
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  clickBookAccept() {
    BooksDao.updateBookGroup(this.booId,this.moveGroupId)
    this.moveGroup()
  }

}