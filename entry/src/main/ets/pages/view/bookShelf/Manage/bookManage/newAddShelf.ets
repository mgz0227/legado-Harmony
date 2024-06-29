/**
 * 添加书籍
 */
import CommonConstants from '../../../../../common/constants/CommonConstants'
import { BookList } from '../../../../../componets/dataList/bookList'
import BookType from '../../../../../componets/head/BookType'
import BookInfo from '../../BookInfo'
import BookInfoManage from './BookInfoManage'

@Component
export default struct newAddShelf{
  @Link showNumber:number
  @Link isAddShelfShow:boolean
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageProp(CommonConstants.KEY_NOVEL_BOOK_DATA)
  bookList:BookList[] = []
  @State searchList:BookList[] = []
  @State @Watch('changeTextValue') TextValue:string = ''
  @State allCheck:boolean = false
  @State changeTop:boolean = false
  @State checkNumber:number = 0
  @State @Watch('changeCheckNumber')checkBookList:BookList[] = []
  @Link addCheckShelf:BookList[]
  @Prop topIsShow:boolean = true
  changeTextValue(){
    console.log('模糊匹配中')
    //更具TextValue值模糊匹配bookList的显示值
    this.searchList = this.bookList.filter((item)=>{
      return item.title.indexOf(this.TextValue) !== -1
    })
  }

  changeCheckNumber(){
    if (this.checkNumber !== 0 && this.checkNumber === this.checkBookList.length) {
      this.allCheck = true
    }
  }
  removeListByIndex(bookId:string){
    console.log('test')
  }
  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }
    ){
     Column(){
       if (this.topIsShow){
         Blank(this.topRectHeight)
       }
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
               this.showNumber=1
             })
           Column(){
             Text('添加书籍').fontSize(16).lineHeight(24).fontWeight(500).textAlign(TextAlign.Center).fontColor('rgba(0, 0, 0, 0.88)')
           }.margin({right:20}).width('100%')
         }
         Search({placeholder:'搜索',value:$$this.TextValue})
         this.bookTypeTitle()
       }
       .padding({left:20,right:20,top:12,bottom:12})
       .align(Alignment.Center)
     }
      Scroll(){
        Column(){
          ForEach(this.TextValue.length>0?this.searchList:this.bookList, (item: BookList,index:number) => {
            BookInfoManage({
              bookData:item,
              allCheck:this.allCheck,
              changeTop:this.changeTop,
              checkBookList:this.checkBookList,
              isManage:true
            })
          })
        }
      }
      .height('75%')
      .align(Alignment.TopStart)
      .scrollBar(BarState.Off).padding({left:15,right:15})
      Divider().strokeWidth(0.5)
      this.footerTitle()
    }
  }
  @Builder
  footerTitle() {
      Flex({
        justifyContent:FlexAlign.SpaceBetween
      }){
        Column(){
          Text(!this.allCheck?'全选':'取消选择').fontSize(16).fontWeight(400).fontColor('rgba(0, 0, 0, 0.88)')
        }
        .onClick(()=>{
          this.allCheck = !this.allCheck
        })

        .justifyContent(FlexAlign.Center)
        .width('50%')
        Row(){
          Text('添加').fontSize(16).fontWeight(400).fontColor(this.checkBookList.length === 0?'rgba(252, 102, 0, 0.5)':$r('app.color.theme_color'))
          Text(`(${this.checkBookList.length})`).fontSize(16).fontWeight(400).fontColor(this.checkBookList.length === 0?'rgba(252, 102, 0, 0.5)':$r('app.color.theme_color'))
        }
        .justifyContent(FlexAlign.Center)
        .width('50%')
        .onClick(()=>{
          this.addBookShelf()
        })
      }.padding({top:16,bottom:this.bottomRectHeight+16,left:32,right:32}).backgroundColor(Color.White)
  }
  addBookShelf(){
    //checkBookList的数据存放到addCheckShelf中判断如果addCheckShelf中有存在同意id就不添加
    for (let i = 0; i < this.checkBookList.length; i++) {
      if (this.addCheckShelf.findIndex((item)=>{
        return item.bookId === this.checkBookList[i].bookId
      }) === -1) {
        this.addCheckShelf.push(this.checkBookList[i])
      }
    }
    this.showNumber = 1
    console.log('添加成功' + JSON.stringify(this.addCheckShelf))

  }
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0

  @State bookType:string = '全部'
  @Builder bookTypeTitle() {
    Flex(
      {
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.SpaceBetween
      }
    ) {
      Scroll() {
        Row({ space: 10 }) {
          BookType({ title: '全部', bookType: this.bookType }).onClick(() => {
            this.bookType = '全部'
          })
          BookType({ title: '未分组', bookType: this.bookType }).onClick(() => {
            this.bookType = '未分组'
          })
          BookType({ title: '本地', bookType: this.bookType }).onClick(() => {
            this.bookType = '本地'
          })
          BookType({ title: '书单', bookType: this.bookType }).onClick(() => {
            this.bookType = '书单'
          })
          BookType({ title: '玄幻', bookType: this.bookType }).onClick(() => {
            this.bookType = '玄幻'
          })
          BookType({ title: '修仙', bookType: this.bookType }).onClick(() => {
            this.bookType = '修仙'
          })
          BookType({ title: '女同', bookType: this.bookType }).onClick(() => {
            this.bookType = '女同'
          })
          BookType({ title: '军事', bookType: this.bookType }).onClick(() => {
            this.bookType = '军事'
          })
          BookType({ title: '国漫', bookType: this.bookType }).onClick(() => {
            this.bookType = '国漫'
          })
          BookType({ title: '日漫', bookType: this.bookType }).onClick(() => {
            this.bookType = '日漫'
          })
          BookType({ title: '广播', bookType: this.bookType }).onClick(() => {
            this.bookType = '广播'
          })
          BookType({ title: '深夜电台', bookType: this.bookType }).onClick(() => {
            this.bookType = '深夜电台'
          })

        }
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      Row(){
        Image($r('app.media.more_search')).width(25).height(25)
      }.width('10%')
    }
  }
}
