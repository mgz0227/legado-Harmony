/**
 * @author 2008
 * @datetime 2024/7/26 20:35
 * @className: catalogAddShelf
 * 加入书单弹窗
 */
import CommonConstants from '../../../../../common/constants/CommonConstants'
import { ThemeStorageKey } from '../../../../../common/constants/Theme'
import { ThemeItem } from '../../../../../common/model/Theme'
import bookGroupUtil from '../../../../../common/utils/bookGroupUtils'
import worksListsUtils from '../../../../../common/utils/WorksListsUtils'
import { showMessage } from '../../../../../componets/common/promptShow'
import worksListsDao from '../../../../../database/dao/WorksListsDao'
import { WorksBookList } from '../../../../../database/entities/WorksBookList'
import { WorksLists } from '../../../../../database/entities/WorksLists'
import newBookShelf from '../bookManage/newBookShelf'

@Component
export default struct catalogAddShelf{
  onClickShelf:Function = (_isCatalogAddShelf:boolean)=>{
  }
  @Prop ids:number[]
  @Prop bookOrFolder:number = 0
  @Prop currentIndex:number = 0
  @Prop showNumber:number = 0
  @State worksBook:WorksLists = new WorksLists()
  @State worksLists:WorksLists[] =[]
  @State newBookIds:number[] = []
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  getWorkLists() {
    worksListsDao.search({
      type:this.currentIndex
    }).then((val)=>{
      this.worksLists = val
    })
  }

  async aboutToAppear(): Promise<void> {
    if (this.bookOrFolder === 1){
      let bookId =  await bookGroupUtil.queryBookByGroupId(this.ids)
      if (bookId.length) {
        this.newBookIds = bookId
      }
    } else {
      this.newBookIds = this.ids
    }
    this.getWorkLists()
  }

  //校验书单中存放的书籍bookIds和newBookIds都存在就为true
  isExistBook(worksBookList: WorksBookList[]): boolean {
    if (!worksBookList || worksBookList.length === 0 || this.newBookIds.length === 0) {
      return false;
    }
    const bookIds = worksListsUtils.getBookIds(worksBookList);
    return this.newBookIds.every(item => bookIds.includes(item));
  }


  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      alignContent:FlexAlign.Center,
      direction:FlexDirection.Column
    }) {
      Column(){
        Column(){
          Text('加入书单').fontSize(16).fontWeight(700).lineHeight(24)
        }
        .padding({right:20,left:20,top:12,bottom:12})
        Divider().strokeWidth(0.5)
        Flex(){
          this.ColumnTitle()
        }
        Scroll(){
          Column(){
            ForEach(this.worksLists,(item:WorksLists)=>{
              this.ColumnTitle(item)
            })
          }
        }
        .align(Alignment.TopStart)
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      Column(){
        Divider().strokeWidth(0.5)

        Text('取消')
          .onClick(() => {
            this.onClickShelf(false)
          })
          .margin({
            top:12,bottom:12
          })

      }
      .padding(20)

      Flex()
        .bindContentCover($$this.isShowEditBook, this.showEditBook(), {
          modalTransition: ModalTransition.DEFAULT,
          onDisappear: () => {
            this.isShowEditBook = false;
          }
        })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }
  @Prop workBookListStatus:number = 1
  @State isShowEditBook:boolean = false
  @Builder showEditBook(){
    Column(){
      newBookShelf({
        currentIndex:this.currentIndex,
        changeShowNumber:()=>{
          this.isShowEditBook = false
          setTimeout(()=>{
            this.getWorkLists()
          },200)
        },
        submit:()=>{
          this.isShowEditBook = false
          this.onClickShelf(false)
        },
        workBookListStatus:this.workBookListStatus,
        lastWorkBookList:this.worksBook,
        bookIds: this.newBookIds
      })
    }
    .backgroundColor(Color.White)
  }

  @Builder ColumnTitle(work?:WorksLists) {
    Column() {
      if (!work){
        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems:ItemAlign.Center
        }){
          Row({
            space:12
          }){
            Image($r('app.media.add')).width(24).fillColor(this.theme.mainColor)
            Text('新建书单').fontSize(14).fontColor(this.theme.mainColor).fontWeight(400).lineHeight(22)
          }.onClick(()=>{
            this.workBookListStatus = 0
            this.isShowEditBook = true
          })
        }
      } else {
        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems:ItemAlign.Center
        }){
          Row({
            space:12
          }){
            Image($r('app.media.shelf')).width(24)
            Text(work.worksName)
              .fontSize(14)
              .fontWeight(400)
              .lineHeight(22)
              .textOverflow({
              overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(1)
          }

          if (this.isExistBook(work.worksBookList ?? [])) {
            Text('已在书单').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
          } else {
            Image($r('app.media.ic_public_return_right')).width(24).height(24)
          }
        }
        .onClick(() => {
          if (this.newBookIds.length === 0){
            showMessage('暂无相关内容可加入')
            return
          }
          if (!this.isExistBook(work.worksBookList ?? [])) {
            if (work) {
              this.worksBook = work
            }
            this.workBookListStatus = 2
            this.isShowEditBook = true
          }
        })
      }
    }
    .padding({
      left:20,
      right:20,
      top:12,
      bottom:12
    })
  }
}