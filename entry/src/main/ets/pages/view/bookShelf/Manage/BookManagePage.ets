import router from '@ohos.router';
import bookListManage from './bookManage/bookListManage';
import { BookList } from '../../../../componets/dataList/bookList';
import {showMessage} from '../../../../componets/common/promptShow'
import CommonConstants from '../../../../common/constants/CommonConstants';
import addBookTypeDialog from '../../../../componets/common/addBookTypeDialog';
import confirmDialogExample from '../../../../componets/common/confirmDialog';
import { initBookListData, shortDateList, updateBookListData } from '../../../../storage/bookListData';
import { folderList } from '../../../../componets/dataList/folderList';
import BookFolderManages from './bookManage/BookFolderManages';
import newBookShelf from './bookManage/newBookShelf';
import newAddShelf from './bookManage/newAddShelf';
import hideDialogExample from '../../../../componets/common/hideDialog';
import ShelfBookList from '../Shelf/ShelfBookList';
import booksDao from '../../../../database/dao/BooksDao';
import { Books } from '../../../../database/entities/Books';
import { buttonList } from '../../../../componets/dataList/buttonList';
import booksUtil from '../../../../common/utils/booksUtils';
import BookSelectGroupDialog from '../components/dialog/BookSelectGroupDialog';
import BookGroupsDao from '../../../../database/dao/BookGroupsDao';
import { BookGroups } from '../../../../database/entities/BookGroups';
import PaddingConstants from '../../../../common/constants/PaddingConstants';
import bookGroupUtil from '../../../../common/utils/bookGroupUtils';
import catalogAddShelf from './components/catalogAddShelf';

class routerParams {
  currentIndex:number
  EXHIBIT:string
  bookTypeNumber:number
  constructor(param:routerParams) {
    this.currentIndex = param.currentIndex
    this.EXHIBIT = param.EXHIBIT
    this.bookTypeNumber = param.bookTypeNumber
  }
}
/**
 * 管理跳转页面
 */
@Entry
@Component
struct BookManagePage {
  @State currentIndex: number = (router.getParams() as routerParams).currentIndex
  @State EXHIBIT: string = (router.getParams() as routerParams).EXHIBIT
  @State bookTypeNumber:number = (router.getParams() as routerParams).bookTypeNumber
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0

  @State isAddShelfShow:boolean = false

  @State topTitle:string = '置顶'
  @State bookList:Books[] = []
  @State checkList:string[] = []
  @State bookGroups:BookGroups[] = []
  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  @StorageLink('BOOK_IS_BOOK_GROUPS_REFRESHING') @Watch('getGroupList')BOOK_IS_BOOK_GROUPS_REFRESHING: number = 0

  selectIsAllTop(){
    let allTopNumber = 0
    let allNotTopNumber = 0
    this.checkList.forEach((index)=>{
      //从bookList更具id查询是否都isTop
      if (this.bookTypeNumber === 5){

      } else if (this.bookTypeNumber === 1){
        this.bookGroups.filter((item)=>{
          if (item.isTop && Number(index) === item.groupId){
            allTopNumber++
          }
          if (!item.isTop && Number(index) === item.groupId){
            allNotTopNumber++
          }
        })
      } else {
        this.bookList.filter((item)=>{
          if (item.isTop && Number(index) === item.id){
            allTopNumber++
          }
          if (!item.isTop && Number(index) === item.id){
            allNotTopNumber++
          }
        })
      }
   
    })
  
    if (allTopNumber === this.checkList.length && allTopNumber > 0) {
      this.topTitle = '取消置顶'
    }
    if (allNotTopNumber === this.checkList.length && allNotTopNumber > 0) {
      this.topTitle = '置顶'
    }
  }
  getBookList(){
    this.checkList = []
    booksDao.search({
      type:this.currentIndex,
      bookGroup:this.bookTypeNumber
    }).then((val)=>{
      this.bookList = val
    })
  }

  getGroupList(){
    this.checkList = []
    BookGroupsDao.search({
      type:this.currentIndex
    }).then((val)=>{
      this.bookGroups = val
    })
  }


  changeCheckNumber(){

  }

  @StorageLink('GROUP_LIST_DATA') groupData:folderList[] = []


  onPageShow(): void {
    if (this.bookTypeNumber === 1) {
      this.getGroupList()
      this.isMoveStatus = 1
    } else if (this.bookTypeNumber !== 5){
      this.getBookList()
      this.isMoveStatus = 0
    } else if (this.bookTypeNumber === 5){
      this.isMoveStatus = 2
      // this.getBookList() //todo 获取书单
    }

  }

  folderCheckNumber(){

  }
  @State isCatalogAddShelf:boolean = false
  @State showNumber:number = 0
  @State addCheckShelf:BookList[] = [
    new BookList('1','开局长生万古，苟到天荒地老','这个世界，有儒;有道；有佛书;有妖;有术士。警校毕业的许七安幽幽醒来，发现自己将要远赴','更新至·第340章 镇压',$r('app.media.shelf_book'),'玄幻')]
  build() {
    Column(){
      Column(){
        if (this.showNumber === 0){
          this.bookManage()
        } else if(this.showNumber === 1){
          newBookShelf({
            addCheckShelf:this.addCheckShelf,
            showNumber:this.showNumber,
            isAddShelfShow:this.isAddShelfShow
          })
        } else if (this.showNumber === 2){
          newAddShelf({
            addCheckShelf:this.addCheckShelf,
            showNumber:this.showNumber,
            isAddShelfShow:this.isAddShelfShow
          })
        }
      }
      .backgroundColor(Color.White)
      .margin({
        top:this.topRectHeight,
        bottom:this.bottomRectHeight
      })
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
    // .height('100%')
    // .linearGradient({
    //   direction: GradientDirection.Bottom, // 渐变方向
    //   colors: [["rgb(254, 203, 169)", 0.1],["RGB(245, 245, 245)", 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    // })
    // .borderRadius({ bottomRight: 5, bottomLeft: 5 })

  }
  @Builder bookManage(){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }) {
      Column(){
        this.headTitle()
        Scroll(){
          if (this.bookTypeNumber === 5){
            ShelfBookList({
              EXHIBIT:this.EXHIBIT,
              isShowCheck:true
            })
          } else {
            if (this.bookTypeNumber === 1){
              BookFolderManages({
                EXHIBIT:this.EXHIBIT,
                bookGroups:this.bookGroups
              })
            } else {
              bookListManage({
                EXHIBIT:this.EXHIBIT,
                bookList:this.bookList,
                checkList:this.checkList,
                shelfType:this.currentIndex
              })
            }
          }
        }
        .layoutWeight(1)
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
      }
      Column(){
        Divider()
        if (this.bookTypeNumber === 5){
          this.footerDel()
        } else {
          this.footerTitle()
        }
      }
    }
  }
  @Builder dialogCatalogAddShelf(){
    Column(){
      catalogAddShelf({
        onClickShelf:(val:boolean)=>{
          this.isCatalogAddShelf = val
        }
      })
    }
  }


  @State fullActive:boolean = false
  @Builder headTitle(){
    Flex(
      {
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.SpaceBetween
      }
    ){
      Row({
        space:5
      }){
        if (this.fullActive){
          CheckboxGroup({ group: 'checkboxGroup'})
            .checkboxShape(CheckBoxShape.CIRCLE)
            .selectedColor(0xff6600)
            .onChange((value:CheckboxGroupResult) => {
              this.checkList = []
              if (value.name) {
                value.name.forEach((item) => {
                  this.checkList.push(item)
                })
              }
              this.selectIsAllTop()
              if (this.checkList.length === 0) {
                this.topTitle = '置顶'
              }
            })
        } else {
          CheckboxGroup({ group: 'checkboxGroup'})
            .checkboxShape(CheckBoxShape.CIRCLE)
            .selectedColor(0xff6600)
            .onChange((value:CheckboxGroupResult) => {
              this.checkList = []
              if (value.name) {
                value.name.forEach((item) => {
                  this.checkList.push(item)
                })
              }
              this.selectIsAllTop()
              if (this.checkList.length === 0) {
                this.topTitle = '置顶'
              }
            })
        }
        Text() {
          Span('全选')
        }
      }.width('33%')


      Column(){
        Text(`已选${this.checkList.length}项目`).fontSize(20).fontWeight(600)
      }
      .alignItems(HorizontalAlign.Center)
      .width('33%')


      Column(){
        Text('完成')
          .fontSize(16)
      }
      .onClick(()=>{
        router.back()
        setTimeout(()=>{
          this.isBookRefreshing++
        },100)
      })
      .width('33%')
      .alignItems(HorizontalAlign.End)
    }
    .padding(10)
  }

  @Builder footerDel(){
    Column(){
      Text('删除').fontSize(16).fontWeight(500).lineHeight(24).fontColor('#EF4444')
    }.onClick(()=>{

    })
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Center)
    .height('10%')
    .padding(20)
  }
  @State buttonListInfo5:buttonList[] = [
    new buttonList(1,'置顶',$r('app.media.top')),
    new buttonList(2,'移动至',$r('app.media.folder')),
    new buttonList(3,'加入书单',$r('app.media.shelf')),
    new buttonList(4,'隐藏分组',$r('app.media.hide')),
    new buttonList(5,'删除',$r('app.media.ic_public_delete'))
  ]

  @State buttonListInfo4:buttonList[] = [
    new buttonList(1,'置顶',$r('app.media.top')),
    new buttonList(2,'移动至',$r('app.media.folder')),
    new buttonList(3,'加入书单',$r('app.media.shelf')),
    new buttonList(5,'删除',$r('app.media.ic_public_delete'))
  ]
  
@Builder footerTitle(){
    GridRow({
      columns:this.bookTypeNumber===1?5:4
    }){
      ForEach(this.bookTypeNumber===1?this.buttonListInfo5:this.buttonListInfo4,(item:buttonList)=>{
        GridCol(){
          if (item.id === 1) {
            Column({
              space:5
            }){
              Image(item.icon).width(25)
              Text(this.topTitle).fontSize(14).fontWeight(500)
            }
            .onClick(()=>{
              this.bookInfoButton(item.id)
            })
          } else {
            Column({
              space:5
            }){
              Image(item.icon).width(25)
              Text(item.title).fontSize(14).fontWeight(500)
            }
            .onClick(()=>{
              this.bookInfoButton(item.id)
            })
          }
        }
      })
    }
    .padding({
      top:10,
      bottom:10
    })
    .backgroundColor(Color.White)
  }

  bookInfoButton(index:number){
    switch (index){
      case 1 :
       this.isBookTop(); break;
      case 2 :
        if (this.checkList.length <= 0) {
          showMessage('请选择要操作的内容');
          return
        }
        this.bookMoveGroup?.open(); break;
      case 3 :
        this.isCatalogAddShelf = true
        showMessage('加入书单'); break;
      case 4 :
        if (this.checkList.length <= 0) {
          showMessage('请选择要操作的内容');
          return
        }
        this.clickHideDialog?.open()
        break
      case 5 :
        if (this.checkList.length <= 0) {
          showMessage('请选择要操作的内容');
          return
        }
        this.delDialog?.open(); break;
    }
  }

  isBookTop(){
    if ( this.checkList.length === 0){
      showMessage('请选择要操作的内容')
      return
    }
    if (this.bookTypeNumber === 5) {

    } else if(this.bookTypeNumber === 1){
      this.checkList.forEach((item:string)=>{
        //将item转换为number
        let bookId = Number(item)
        if (bookId) {
          bookGroupUtil.isTopGroup(bookId, this.topTitle==='置顶'?true:false)
        }
      })
      this.checkList = []
      setTimeout(()=>{
        this.getGroupList()
        this.topTitle = '置顶'
        this.fullActive = !this.fullActive
      },500)
    } else {
      this.checkList.forEach((item:string)=>{
        //将item转换为number
        let bookId = Number(item)
        if (bookId) {
          booksUtil.isTopBook(bookId, this.topTitle==='置顶'?true:false)
        }
      })
      this.checkList = []
      setTimeout(()=>{
        this.getBookList()
        this.topTitle = '置顶'
        this.fullActive = !this.fullActive
      },500)
    }
    showMessage('操作成功')
  }
  @State delCache:boolean = false
  //弹窗
  delDialog: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: ()=> { this.deleteGroup() },
      delCache:this.delCache
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  deleteGroup() {
    this.isBookDelete()
    this.delDialog?.close()
  }

  isBookDelete(){
    if (this.checkList.length === 0){
      showMessage('请选择要删除的内容')
      return
    }
    this.checkList.forEach((item:string)=>{
      let bookId = Number(item)
      if (this.bookTypeNumber !== 1 && this.bookTypeNumber !== 5) {
        if (bookId) {
          booksUtil.delBooksById(bookId)
        }
      } else if(this.bookTypeNumber === 1){
        if (bookId) {
          bookGroupUtil.delGroupById(bookId)
        }
      }
    })
    this.checkList = []
    setTimeout(()=>{
      this.getBookList()
      this.getGroupList()
      this.BOOK_IS_BOOK_GROUPS_REFRESHING++
      this.isBookRefreshing++
      showMessage('已删除')
      this.fullActive = !this.fullActive
    },500)

  }
  //是否隐藏分组
  clickHideDialog: CustomDialogController | null = new CustomDialogController({
    builder: hideDialogExample({
      confirm: ()=> { this.clickHideAccept() }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  clickHideAccept() {
   bookGroupUtil.updateGroupShow(this.checkList.map((item:string)=>{
     return Number(item)
   }))
    setTimeout(()=>{
      this.getGroupList()
      this.BOOK_IS_BOOK_GROUPS_REFRESHING++
      this.fullActive = !this.fullActive
      showMessage('已隐藏')
    },500)
  }

  //操作状态
  @State isMoveStatus:number = 0

  bookMoveGroup: CustomDialogController | null = new CustomDialogController({
    builder: BookSelectGroupDialog({
      moveGroup: ()=> {
        this.bookMoveGroup?.close()
        setTimeout(()=>{
          this.isBookRefreshing++
          this.BOOK_IS_BOOK_GROUPS_REFRESHING++
        },500)
        showMessage('移动成功')
      },
      currentIndex:this.currentIndex,
      //将this.checkList转换为number
      Ids:this.checkList.map((item:string)=>{
        return Number(item)
      }),
      isMoveStatus:this.isMoveStatus
    }),
    height: 400,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

}