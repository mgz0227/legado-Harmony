import PaddingConstants from '../../../../../common/constants/PaddingConstants';
import bookGroupUtil from '../../../../../common/utils/bookGroupUtils';
import booksUtil from '../../../../../common/utils/booksUtils';
import confirmDialogExample from '../../../../../componets/common/confirmDialog';
import Header from '../../../../../componets/common/Header';
import hideDialogExample from '../../../../../componets/common/hideDialog';
import { showMessage } from '../../../../../componets/common/promptShow';
import { BookList } from '../../../../../componets/dataList/bookList';
import { buttonList } from '../../../../../componets/dataList/buttonList';
import IndexSearchType from '../../../../../componets/head/IndexSearchType';
import BookGroupsDao from '../../../../../database/dao/BookGroupsDao';
import booksDao from '../../../../../database/dao/BooksDao';
import { BookGroups } from '../../../../../database/entities/BookGroups';
import { Books } from '../../../../../database/entities/Books';
import BookSelectGroupDialog from './BookSelectGroupDialog';
import BookFolderManages from '../../Manage/bookManage/BookFolderManages';
import bookListManage from '../../Manage/bookManage/bookListManage';
import newAddShelf from '../../Manage/bookManage/newAddShelf';
import newBookShelf from '../../Manage/bookManage/newBookShelf';
import catalogAddShelf from '../../Manage/components/catalogAddShelf';
import ShelfBookList from '../../Shelf/ShelfBookList';


/**
 * 分组页面单击跳转页面
 */
@Component
export default  struct BookManageDialog {
  @Prop currentIndex: number
  @State EXHIBIT: string = '标签'
  @Prop title:string
  @Prop bookTypeNumber:number
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State isAddShelfShow:boolean = false
  @State isManage:boolean = false
  @State topTitle:string = '置顶'
  @State bookList:Books[] = []
  @State @Watch('listenCheckList')checkLists: Record<number, boolean> = {}
  @State checkListNumber:number[] = []
  @State bookGroups:BookGroups[] = []
  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  @StorageLink('BOOK_IS_BOOK_GROUPS_REFRESHING') @Watch('getGroupList')BOOK_IS_BOOK_GROUPS_REFRESHING: number = 0
  //判断是否全部置顶或取消置顶
  selectIsAllTop(){
    let allTopNumber = 0
    if (this.checkListNumber.length <= 0){
      this.topTitle = '置顶'
      return
    }
    this.checkListNumber.forEach((index)=>{
      //从bookList更具id查询是否都isTop
      if (this.bookTypeNumber === 5){
        //todo 书单

      } else if (this.bookTypeNumber === 1){
        this.bookGroups.filter((item)=>{
          if (item.isTop && Number(index) === item.groupId && !item.isSystem){
            allTopNumber++
          }
          if (!item.isTop && Number(index) === item.groupId && !item.isSystem){
          }
        })
      } else {
        this.bookList.filter((item)=>{
          if (item.isTop && Number(index) === item.id){
            allTopNumber++
          }
          if (!item.isTop && Number(index) === item.id){
          }
        })
      }
   
    })
    if (allTopNumber === this.checkListNumber.length) {
      this.topTitle = '取消置顶'
    } else {
      this.topTitle = '置顶'
    }
  }
  //书籍
  getBookList(){
    booksDao.search({
      type:this.currentIndex,
      bookGroup:this.bookTypeNumber
    }).then((val)=>{
      this.bookList = val
    })
  }
  //分组
  getGroupList(){
    BookGroupsDao.search({
      type:this.currentIndex
    }).then((val)=>{
      this.bookGroups = val
    })
  }
  //初始
  aboutToAppear(): void {
    if (this.bookTypeNumber === 1) {
      this.getGroupList()
      this.isMoveStatus = 1
    } else if (this.bookTypeNumber === 5){
      this.isMoveStatus = 2
      // this.getBookList() //todo 获取书单
    } else {
      this.getBookList()
      this.isMoveStatus = 0
    }
  }

  @State isCatalogAddShelf:boolean = false
  @State showNumber:number = 0
  @State addCheckShelf:BookList[] = [
    new BookList('1','开局长生万古，苟到天荒地老','这个世界，有儒;有道；有佛书;有妖;有术士。警校毕业的许七安幽幽醒来，发现自己将要远赴','更新至·第340章 镇压',$r('app.media.shelf_book'),'玄幻')]
  build() {
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
    .margin({
      bottom:this.bottomRectHeight
    })
  }
  //主要操作页面
  @Builder bookManage(){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }) {
      Column(){
        if (!this.isManage){
          this.headTitleManage()
        } else {
          Header({
            customLeftBuilder: () => {
              this.selectAll()
            },
            title:`已选${this.checkListNumber.length}项`,
            customRightBuilder: () => {
              this.complete()
            },
            paddingTop:-30
          })
        }
        Scroll(){
          if (this.bookTypeNumber === 5){
            ShelfBookList({
              EXHIBIT:this.EXHIBIT,
              isShowCheck:true
            })
          } else {
            if (this.bookTypeNumber === 1){
              BookFolderManages({
                checkGroup:this.checkLists,
                EXHIBIT:this.EXHIBIT,
                bookGroups:this.bookGroups,
                isManage:this.isManage
              })
            } else {
              bookListManage({
                checkGroup:this.checkLists,
                EXHIBIT:this.EXHIBIT,
                bookList:this.bookList,
                isManage:this.isManage
              })
            }
          }
        }
        .layoutWeight(1)
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
      }
      if (this.isManage){
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
    .height('100%')
  }
  @State titleManage:string = '最近阅读'
  @State searchValue: string = '最近阅读'
  @Builder headTitleManage(){
    Flex(
      {
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.Center
      }
    ){
      Column(){
        IndexSearchType({ title: this.titleManage, searchValue: this.searchValue })
      }
      .alignItems(HorizontalAlign.Start)
      .width('33%')
      Column(){
        Text(`${this.title}`)
          .textAlign(TextAlign.Center)
          .fontSize(16).fontWeight(500).fontColor($r('app.string.color_black_88'))
      }
      .width('33%')
      .onClick(()=>{

      })
      Row(
        {
          space:12
        }
      ){
        Text(this.EXHIBIT === '列表'?'宫格':'列表')
          .textAlign(TextAlign.Center)
          .fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
          .onClick(()=>{
            if (this.EXHIBIT === '列表') {
              this.EXHIBIT = '宫格'
            } else {
              this.EXHIBIT = '列表'
            }
          })

        Divider()
          .vertical(true)
          .height(15)
          .color('#989797')
          .opacity(0.3)
          .strokeWidth(1)

        Text('管理')
          .textAlign(TextAlign.Center)
          .fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
          .onClick(()=>{
            this.isManage = !this.isManage
          })
      }
      .justifyContent(FlexAlign.End)
      .width('33%')
    }
    .padding(PaddingConstants.PADDING_20)
  }


  //书单弹窗
  @Builder dialogCatalogAddShelf(){
    Column(){
      catalogAddShelf({
        onClickShelf:(val:boolean)=>{
          this.isCatalogAddShelf = val
        }
      })
    }
  }
  @State allCheck:boolean = false
  @Builder
  selectAll() {
    Row({
      space:5
    }) {
      Checkbox()
        .select(this.allCheck)
        .selectedColor(0xff6600)
        .onClick(() => {
          if (this.verificationDate()) {
            return
          }
          this.allCheck = !this.allCheck
          this.dataMoveCheckList(this.allCheck)
        })
      Text(!this.allCheck?'全选':'取消全选')
    }

    .alignItems(VerticalAlign.Center)
  }
  //校验是否存页面数据内容
  verificationDate() {
    switch (this.bookTypeNumber){
      case 1:
        if (this.bookGroups.length === 0){
          showMessage('页面暂无操作数据')
          return true
        }
        break
      case 5:
        break
      default:
        if (this.bookList.length === 0){
          showMessage('页面暂无操作数据')
          return true
        }
        break
    }
    return false
  }


  //遍历列表数据
  dataMoveCheckList(value:boolean){

    this.checkLists = {};
    if (this.bookTypeNumber === 1){
      this.bookGroups.forEach((item)=>{
        item.groupId && !item.isSystem && item.show ?this.checkLists[item.groupId] = value:''
      })
    } else if (this.bookTypeNumber === 5){

    } else {
      this.bookList.forEach((item)=>{
        item.id?this.checkLists[item.id] = value:''
      })
    }
    if(!value){
      this.allCheck = false;
    }
  }


  @Builder
  complete() {
    Column() {
      Text('完成')
    }
    .onClick(async () => {
      this.isManage = !this.isManage
      setTimeout(()=>{
        this.refreshData()
      },100)
    })
  }
  //书单底部操作栏
  @Builder footerDel(){
    Column(){
      Text('删除').fontSize(16).fontWeight(500).lineHeight(24).fontColor('#EF4444')
    }.onClick(()=>{

    })
    .margin({
      top:PaddingConstants.PADDING_10
    })
    .alignItems(HorizontalAlign.Center)
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
  //底部操作栏
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
      .margin({
        top:PaddingConstants.PADDING_10
      })
    }
  //底部操作栏功能
  bookInfoButton(index:number){
    if (this.checkListNumber.length <= 0) {
      showMessage('请选择要操作的内容');
      return
    }
    this.dataCheckList()
    switch (index){
      case 1 :
       this.manageTop(); break;
      case 2 :
        this.bookMoveGroup?.open(); break;
      case 3 :
        this.isCatalogAddShelf = true
        showMessage('加入书单'); break;
      case 4 :
        this.clickHideDialog?.open()
        break
      case 5 :
        this.delDialog?.open(); break;
    }
  }
  //置顶功能
  manageTop(){
    if (this.bookTypeNumber === 5) {

    } else if(this.bookTypeNumber === 1){
      bookGroupUtil.isTopGroup(this.checkListNumber, this.topTitle==='置顶'?true:false)
    } else {
      booksUtil.isTopBook(this.checkListNumber, this.topTitle==='置顶'?true:false)
    }
    setTimeout(()=>{
      this.refreshData()
      this.checkListNumber = []
      this.checkLists = {}
      this.topTitle = '置顶'
    },500)
    showMessage('操作成功')
  }
  //删除确认弹窗
  @State delCache:boolean = false
  delDialog: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: ()=> { this.manageDelete() },
      delCache:this.delCache
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })
  //删除功能
  manageDelete(){
    this.checkListNumber.forEach((item:number)=>{
      if (this.bookTypeNumber !== 1 && this.bookTypeNumber !== 5) {
        booksUtil.delBooksById(item)
      } else if(this.bookTypeNumber === 1){
        bookGroupUtil.delGroupById(item)
      }
    })
    setTimeout(()=>{
      this.refreshData()
      showMessage('已删除')
    },500)
    this.delDialog?.close()
  }
  //是否隐藏分组弹窗
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
  //隐藏操作
  clickHideAccept() {
   bookGroupUtil.updateGroupShow(this.checkListNumber)
    setTimeout(()=>{
      this.refreshData()
      showMessage('已隐藏')
    },500)
  }

  //操作状态
  @State isMoveStatus:number = 0
  //移动分组弹窗
  bookMoveGroup: CustomDialogController | null = new CustomDialogController({
    builder: BookSelectGroupDialog({
      moveGroup: ()=> {
        setTimeout(()=>{
          this.refreshData()
        },500)
        this.bookMoveGroup?.close()
      },
      currentIndex:this.currentIndex,
      Ids:this.checkListNumber,
      isMoveStatus:this.isMoveStatus
    }),
    height: 400,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  //刷新数据方法
  refreshData(){
   switch (this.bookTypeNumber){
     case 1:
       this.getGroupList();
       this.BOOK_IS_BOOK_GROUPS_REFRESHING++
       break;
     case 5:
       break;
       default:
         this.getBookList();
         this.isBookRefreshing++
         break;
   }
   this.dataMoveCheckList(false)
  }

  //将checkLists取key值转换为string[]
  dataCheckList(){
    const keys = Object.keys(this.checkLists)
      .filter(key => this.checkLists[Number(key)])
      .map(key => Number(key));
    this.checkListNumber = keys
  }
  //判断checkLists变化值当key的值为false移除当前值
  listenCheckList() {
    this.dataCheckList()
    this.selectIsAllTop()
    this.allCheck = this.checkListNumber.length !== 0
  }
}