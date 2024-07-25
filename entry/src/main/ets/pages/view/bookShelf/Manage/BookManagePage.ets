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
import InsideCircleIcon from '../../../../componets/common/InsideCircleIcon';
import booksUtil from '../../../../common/utils/booksUtils';
import BookSelectGroupDialog from '../components/dialog/BookSelectGroupDialog';

class routerParams {
  currentIndex:number
  EXHIBIT:string
  GROUPName:string
  bookTypes:string
  bookTypeNumber:number
  constructor(param:routerParams) {
    this.currentIndex = param.currentIndex
    this.EXHIBIT = param.EXHIBIT
    this.GROUPName = param.GROUPName
    this.bookTypes = param.bookTypes
    this.bookTypeNumber = param.bookTypeNumber
  }
}
/**
 * 管理跳转页面
 */
@Entry
@Component
struct BookManagePage {
  @State GROUPName:string = (router.getParams() as routerParams).GROUPName
  @State currentIndex: number = (router.getParams() as routerParams).currentIndex
  @State EXHIBIT: string = (router.getParams() as routerParams).EXHIBIT
  @State bookTypes: string = (router.getParams() as routerParams).bookTypes
  @State bookTypeNumber:number = (router.getParams() as routerParams).bookTypeNumber
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State isClear:boolean = false
  @State allCheck:boolean = false
  @State @Watch('changeCheckNumber')checkNumber:number = 0

  @State changeTop:boolean = false
  @State isShow:boolean = false

  @State isAddShelfShow:boolean = false



  @State bookType:string = ''

  @State BooTypeList:string[] = ['玄幻','修真', '都市', '穿越', '网游', '科幻', '历史']

  @State ShelfList:string[] = ['玄幻神作', '精品小说,亲自品鉴', '冷门小说不容错过','冷门小说不容错过']

  @State clickBookType:string = ''

  @State topTitle:string = '置顶'
  @State bookList:Books[] = []
  @State checkList:string[] = []
  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  selectIsAllTop(){
    let allTopNumber = 0
    let allNotTopNumber = 0
    this.checkList.forEach((index)=>{
      //从bookList更具id查询是否都isTop
      this.bookList.filter((item)=>{
        if (item.isTop && Number(index) === item.id){
          allTopNumber++
        }
        if (!item.isTop && Number(index) === item.id){
          allNotTopNumber++
        }
      })
    })
    if (allTopNumber === this.checkList.length && allTopNumber > 0) {
      this.topTitle = '取消置顶'
    }
    if (allNotTopNumber === this.checkList.length && allNotTopNumber > 0) {
      this.topTitle = '置顶'
    }
  }
  getBookList(){
    booksDao.search({
      type:this.currentIndex,
      bookGroup:this.bookTypeNumber
    }).then((val)=>{
      this.bookList = val
    })
  }

  changeCheckNumber(){
    if (this.checkNumber !== 0 && this.checkNumber === this.bookList.length) {
        this.allCheck = true
    }
  }

  @StorageLink('GROUP_LIST_DATA') groupData:folderList[] = []


  onPageShow(): void {
    this.getBookList()
  }

  @State folderCheckList:folderList[] = []
  folderCheckNumber(){
    this.checkNumber = this.folderCheckList.length

  }
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
    }
    .backgroundColor(Color.White)
    .padding({
      top:this.topRectHeight,
      bottom:this.bottomRectHeight
    })
    .backgroundColor("rgb(245, 245, 245)")
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [["rgb(254, 203, 169)", 0.0], ["RGB(245, 245, 245)", 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
  }
  @Builder bookManage(){
    Column() {
      this.headTitle()
      Flex({
        justifyContent:FlexAlign.Center
      }){
        Scroll(){
          if (this.bookTypes === '书单'){
            ShelfBookList({
              EXHIBIT:this.EXHIBIT,
              isShowCheck:true
            })
          } else {
            if (this.GROUPName === '文件夹' || this.bookTypes === '分组'){
              BookFolderManages({
                folderList:this.groupData,
                folderCheckList:this.folderCheckList,
                changeTop:this.changeTop,
                EXHIBIT:this.EXHIBIT
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
        .height('88%')
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
      }

      if (this.bookTypes === '书单'){
        this.footerDel()
      } else {
        this.footerTitle()
      }
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


      Text(`已选${this.checkList.length}项目`).fontSize(20).fontWeight(600)
        .width('33%')

      Column(){
        Text('完成')
          .fontSize(16)
      }
      .onClick(()=>{
        this.allCheck = false
        router.back()
        setTimeout(()=>{
          this.isBookRefreshing++
        },100)
      })
      .alignItems(HorizontalAlign.End)
      .width('33%')
    }
    .padding(10)
  }

  @Builder footerDel(){
    Column(){
      Text('删除').fontSize(16).fontWeight(500).lineHeight(24).fontColor('#EF4444')
    }.onClick(()=>{
        showMessage('测试删除')
      this.isClear = true
    })
    .alignItems(HorizontalAlign.Center)
    .height('10%')
    .padding(20)
  }
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'置顶',$r('app.media.top')),
    new buttonList(2,'移动至',$r('app.media.folder')),
    new buttonList(3,'加入书单',$r('app.media.shelf')),
    new buttonList(4,'删除',$r('app.media.ic_public_delete'))
  ]
  @Builder footerTitle(){
    GridRow({
      columns:4
    }){
      ForEach(this.buttonListInfo,(item:buttonList)=>{
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
    .height('10%')
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
        showMessage('加入书单'); break;
      case 4 :
        if (this.checkList.length <= 0) {
          showMessage('请选择要操作的内容');
          return
        }
        this.bookDelDialog?.open(); break;
    }
  }

  isBookTop(){
    if ( this.checkList.length === 0){
      showMessage('请选择要操作的内容')
      return
    }
    if (this.GROUPName !== '分组' && this.GROUPName !== '书单') {
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
       showMessage('已置顶')
       this.topTitle = '置顶'
       this.fullActive = !this.fullActive
     },500)
    }
  }
  @State delCache:boolean = false
  //弹窗
  bookDelDialog: CustomDialogController | null = new CustomDialogController({
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
    this.bookDelDialog?.close()
  }

  isBookDelete(){
    if (this.checkList.length === 0){
      showMessage('请选择要删除的内容')
      return
    }
    if (this.GROUPName !== '分组' && this.GROUPName !== '书单') {
      this.checkList.forEach((item:string)=>{
        //将item转换为number
        let bookId = Number(item)
        if (bookId) {
          booksUtil.delBooksById(bookId)
        }
      })
      this.checkList = []
      setTimeout(()=>{
        this.getBookList()
        showMessage('已删除')
        this.fullActive = !this.fullActive
      },500)
    }
  }

  @Builder catalogAddShelf() {
    Column() {
      Column(){
        Text('加入书单').fontSize(16).fontWeight(700).lineHeight(24)
      }.padding({right:20,left:20,top:12,bottom:12})
      Divider().strokeWidth(0.5)
      Flex(){
        this.ColumnTitle('')
      }
      Scroll(){
        Column(){
          ForEach(this.ShelfList,(item:string)=>{
            this.ColumnTitle(item)
          })
        }
      }
      .height('45%')
      .scrollBar(BarState.Off)
      Divider().strokeWidth(0.5)
      Row({
        space:20
      }) {
        Column(){
          Text('取消').fontSize(16).fontWeight(400).fontColor($r('app.color.theme_color'))
            .lineHeight(24)
            .padding({left:32,right:32,bottom:12,top:12})
        }
        .width('50%')
        .borderRadius(20)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('rgba(255, 102, 0, 0.12)')
        Column(){
          Text('确定').fontSize(16).fontWeight(400).fontColor(Color.White)
            .lineHeight(24)
            .padding({left:32,right:32,bottom:12,top:12})
        }
        .width('50%')
        .borderRadius(20)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor($r('app.color.theme_color'))
      }
      .onClick(()=>{
        this.isAddShelfShow = false
      })
      .padding({
        left: 32,
        right:32,
        top: 16
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder ColumnTitle(title:string) {
    Column() {
      if (title === ''){
        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems:ItemAlign.Center
        }){
          Row({
            space:12
          }){
            Image($r('app.media.add')).width(24).fillColor($r('app.color.theme_color'))
            Text('新建书单').fontSize(14).fontColor($r('app.color.theme_color')).fontWeight(400).lineHeight(22)
          }.onClick(()=>{
            this.showNumber = 1
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
           Text(title).fontSize(14).fontWeight(400).lineHeight(22).textOverflow({
             overflow:TextOverflow.Ellipsis
           }).ellipsisMode(EllipsisMode.END).maxLines(1)
         }

         if (false) {
           Image($r('app.media.ic_public_return_right')).width(24).height(24)
         } else {
           Text('已在书单').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
         }
       }
      }
    }
    .onClick(()=>{

    })
    .padding({
      left:20,
      right:20,
      top:12,
      bottom:12
    })
  }

  //是否隐藏分组
  clickHideDialog: CustomDialogController | null = new CustomDialogController({
    builder: hideDialogExample({
      cancel: ()=> { this.clickHideCancel() },
      confirm: ()=> { this.clickHideAccept() },
      title:``
    }),
    cancel: this.hideDialog,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  clickHideCancel() {

  }

  clickHideAccept() {
  }

  hideDialog() {
  }

  //移动分组
  //弹窗
  bookMoveGroup: CustomDialogController | null = new CustomDialogController({
    builder: BookSelectGroupDialog({
      moveGroup: ()=> {
        this.bookMoveGroup?.close()
        setTimeout(()=>{
          this.isBookRefreshing++
        },500)
        showMessage('移动成功')
      },
      currentIndex:this.currentIndex,
      //将this.checkList转换为number
      bookIds:this.checkList.map((item:string)=>{
        return Number(item)
      })
    }),
    height: 400,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

}