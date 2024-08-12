import BasicDataSource from '../../../../common/LazyIDataSource/BasicDataSource'
import booksDao from '../../../../database/dao/BooksDao'
import { Books } from '../../../../database/entities/Books'
import BookInfoGrids from './BookInfoGrids'
import BookInfos from './BookInfos'

@Component
export default struct BookContent {
  @State bookList:Books[] = []
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Provide('booksDataSource') booksDataSource: BasicDataSource<Books> = new BasicDataSource<Books>()

  async aboutToAppear(): Promise<void> {
    this.bookCount =  await booksDao.getBookCount({
      type:this.currentIndex,
      bookGroup:this.bookTypeNumber,
    })
    if (this.booksDataSource.totalCount() === 0) {
      this.getBookList()
    }
  }
  @State bookCount:number = 0
  @Prop EXHIBIT:string
  @Prop @Watch('changeBookType')searchValue:string
  @Prop @Watch('changeBookType')currentIndex: number
  @Prop @Watch('changeBookType')bookTypeNumber:number
  //更新数据累加刷新数据页面
  @StorageLink('BOOK_IS_BOOK_REFRESHING') @Watch("isRefresh")isBookRefreshing: number = 0
  isRefresh(){
    this.currentPage = 1
    if (this.booksDataSource.totalCount() > 0){
      this.booksDataSource.clear()
    }
    if (this.isBookRefreshing >= 0) {
      this.getBookList()
    }
  }

  changeBookType(){
    this.currentPage = 1
    if (this.bookTypeNumber !== 1 && this.bookTypeNumber !== 5) {
      if (this.booksDataSource.totalCount() > 0) {
        this.booksDataSource.clear()
      }
      this.getBookList()
    }
  }

  async getBookList(){
    this.bookList =  await booksDao.searchPage({
      type:this.currentIndex,
      bookGroup:this.bookTypeNumber,
      order:this.searchValue
    }, this.currentPage)
    if (this.booksDataSource.totalCount() < this.bookCount) {
      this.booksDataSource.pushAllData(this.bookList)
    }
  }

  @State isLoading: boolean = false
  @State currentPage:number = 1
  async loadMoreBooks() {
    if (!this.isLoading) {
      this.isLoading = true;
      this.currentPage += 1;

      const moreBooks = await booksDao.searchPage({
        type:this.currentIndex,
        bookGroup:this.bookTypeNumber,
        order:this.searchValue,
      }, this.currentPage);
      if (moreBooks.length > 0) {
        this.booksDataSource.pushAllData(moreBooks);
      }
      this.isLoading = false;
    }
  }

  build() {
    if (this.isLoading) {
      Row(){
        LoadingProgress()
          .color(0xff6600)
          .width('50%')
        Text('加载中...')
      }
    } else if (this.bookList.length === 0){
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
      List({
        space:10
      }){
        LazyForEach(this.booksDataSource, (item: Books,index:number) => {
          ListItem(){
            if (this.EXHIBIT === '宫格') {
              BookInfoGrids({
                book:item
              })
            } else {
              BookInfos({
                book:item
              })
            }
          }
        })
      }
      .layoutWeight(1)
      .lanes(this.EXHIBIT === '宫格' ? 3 : 1)
      .scrollBar(BarState.Off)
      .onReachEnd(() => {
        if (this.booksDataSource.totalCount() < this.bookCount) {
          this.loadMoreBooks()
        }
      })
      .margin({
        bottom: 20
      })
    }
  }
}