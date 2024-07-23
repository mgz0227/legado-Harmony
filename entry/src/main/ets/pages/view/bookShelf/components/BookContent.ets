/**
 * @author 2008
 * @datetime 2024/7/23 14:16
 * @className: BookContent
 * 书籍详细列
 */
import { showMessage } from '../../../../componets/common/promptShow'
import booksDao from '../../../../database/dao/BooksDao'
import { Books } from '../../../../database/entities/Books'
import BookInfoGrids from './BookInfoGrids'
import BookInfos from './BookInfos'

@Component
export default struct BookContent {
  @State bookList:Books[] = []
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  aboutToAppear(): void {
    this.getBookList()
  }
  @Prop EXHIBIT:string
  @Prop searchValue:string
  @Prop @Watch('changeBookType')currentIndex: number
  @Prop @Watch('changeBookType')bookType:string
  //更新数据累加刷新数据页面
  @StorageLink('BOOK_IS_BOOK_REFRESHING') @Watch("isRefresh")isBookRefreshing: number = 0
  isRefresh(){
    if (this.isBookRefreshing >= 0) {
      this.getBookList()
    }
  }

  changeBookType(){
    showMessage(JSON.stringify(`${this.bookType},${this.currentIndex}`))
    this.getBookList()
    this.isBookRefreshing++
  }
  getBookList(){
    booksDao.search().then((val)=>{
      this.bookList = val
    })
  }

  build() {
    if (this.bookList.length === 0){
      Column() {
        Image($r('app.media.no_record')).width(200).height(200)
        Text('暂无浏览记录')
          .fontSize(12)
          .fontColor('rgba(96, 96, 96, 0.6)')
          .fontWeight(500)
          .padding(5)
      }
      .margin({ top: 120 })
    } else {
      Column(
        {space:10}
      ){
        if (this.EXHIBIT === '宫格' && this.searchValue !== '浏览历史') {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
            ForEach(this.bookList, (item: Books,index:number) => {
              BookInfoGrids({
                book:item
              }).width('33%')
            })
          }
        } else {
          Column(
            { space: 10 }
          ) {
            ForEach(this.bookList, (item: Books,index:number) => {
              BookInfos({
                book:item,
                searchValue: this.searchValue,
              })
            })
          }
          .backgroundColor('rgba(255,250,247,0.8)')
        }
      }
    }
  }
}