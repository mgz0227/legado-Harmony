import { ThemeStorageKey } from '../../../../../common/constants/Theme'
import { ThemeItem } from '../../../../../common/model/Theme'
import { showMessage } from '../../../../../componets/common/promptShow'
import groupTypeSearch from '../../../../../componets/group/GroupTypeSearch'
import booksDao from '../../../../../database/dao/BooksDao'
import { Books } from '../../../../../database/entities/Books'
import BookInfoManage from './BookInfoManage'
/**
 * 添加书籍
 */
@Component
export default struct newAddShelf{
  @State searchValue:string = ''
  @Prop currentIndex:number
  @State bookList:Books[] = []
  addBookList:Function = (_selectBookId:number[])=>{

  }
  @Prop lastBookIds:number []
  close:Function = ()=>{}
  @State @Watch('dataCheckList')selectBookId:Record<number, boolean> = {}
  @State selectBookIdList:number[] = []
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State @Watch('getBookList')bookTypeNumber:number = 2
  @State groupCoverShow: boolean = false
  @State @Watch('searchBook')searchBookList:number[] = []

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  //用于分组弹窗添加书籍
  searchBook(){
    if (this.searchBookList.length === 0 ) return
    if (this.searchBookList.length > 0) {
      this.searchBookList.forEach((item)=>{
        this.selectBookId[item] = true
      })
      this.searchBookList = []
      this.groupCoverShow = false
    }
  }
  aboutToAppear(): void {
    if (this.lastBookIds) {
      this.lastBookIds.forEach((item)=>{
        this.selectBookId[item] = true
      })
    }
    this.getBookList()
  }
  //书籍
  getBookList(){
    booksDao.search({
      type:this.currentIndex,
      searchKey:this.searchValue,
      bookGroup:this.bookTypeNumber
    }).then((val)=>{
      this.bookList = val
      this.allSelect = this.bookList.length === this.selectBookIdList.length
    })
  }
  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }
    ){
     Column(){
       Column({
         space:5
       }) {
         Flex({
           alignItems:ItemAlign.Center,
           justifyContent:FlexAlign.Center
         }){
           Image($r('app.media.close'))
             .width(25)
             .height(25)
             .fillColor('rgba(0, 0, 0, 0.88)')
             .onClick(()=>{
               this.close()
             })
           Column(){
             Text('添加书籍')
               .fontSize(16)
               .lineHeight(24)
               .fontWeight(500)
               .textAlign(TextAlign.Center)
               .fontColor('rgba(0, 0, 0, 0.88)')
           }
           .margin({right:20})
           .width('100%')
         }
         Search({placeholder:'搜索',value:this.searchValue})
           .onChange((value:string)=>{
             if (this.searchValue !== value) {
               this.searchValue = value
               this.getBookList()
             }
             if(value.length === 0){
               this.allSelect = this.bookList.length === this.selectBookIdList.length
             }
           })
       }
       .padding({left:20,right:20,top:12,bottom:12})
       .align(Alignment.Center)
     }
    Stack(){
      groupTypeSearch({
        bookTypeNumber:this.bookTypeNumber,
        groupCoverShow:this.groupCoverShow,
        searchBookList:this.searchBookList
      })
        .zIndex(9)
      Column(){
        Scroll(){
          Column(){
            ForEach(this.bookList, (item: Books,index:number) => {
              BookInfoManage({
                bookData:item,
                isManage:true,
                checkGroup:this.selectBookId
              })
            })
          }
        }
        .layoutWeight(1)
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off).padding({left:15,right:15})
        Divider().strokeWidth(0.5)
        this.footerTitle()
      }
      .margin({top:30})
    }
    .layoutWeight(1)
    .alignContent(Alignment.Top)
    }
    .padding({
      top:this.topRectHeight,
      bottom:this.bottomRectHeight
    })
  }
  @State allSelect:boolean = false
  @Builder
  footerTitle() {
      Flex({
        justifyContent:FlexAlign.SpaceBetween
      }){
        Column(){
          Text(!this.allSelect?'全选':'取消全选')
            .fontSize(16)
            .fontWeight(400)
            .fontColor('rgba(0, 0, 0, 0.88)')
        }
        .onClick(()=>{
          if (this.bookList.length === 0) {
            showMessage('页面暂无操作数据')
            return
          }
           this.allSelect = !this.allSelect
           this.dataMoveCheckList(this.allSelect)
        })
        .justifyContent(FlexAlign.Center)
        .width('50%')
        Row(){
          Text('添加').fontSize(16)
            .fontWeight(400)
            .fontColor(this.selectBookIdList.length === 0?this.theme.secondColor:this.theme.mainColor)
          Text(`(${this.selectBookIdList.length??0})`)
            .fontSize(16)
            .fontWeight(400)
            .fontColor(this.selectBookIdList.length === 0?this.theme.secondColor:this.theme.mainColor)
        }
        .justifyContent(FlexAlign.Center)
        .width('50%')
        .onClick(()=>{
          this.dataCheckList()
          this.addBookList(this.selectBookIdList)
        })
      }
      .padding({
        top:16,
        bottom:16,
        left:32,
        right:32
      })
      .backgroundColor(Color.White)
  }

  //遍历列表数据
  dataMoveCheckList(value:boolean){
    this.selectBookId = {};
    this.bookList.forEach((item)=>{
      item.id?this.selectBookId[item.id] = value:''
    })
    this.dataCheckList()
  }

  dataCheckList(){
    const keys = Object.keys(this.selectBookId)
      .filter(key => this.selectBookId[Number(key)])
      .map(key => Number(key));
    this.selectBookIdList = keys
    this.allSelect = this.bookList.length === this.selectBookIdList.length
  }
}
