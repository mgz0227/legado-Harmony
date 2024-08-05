import bookHistoryDao from '../../../../database/dao/BookHistoryDao'
import { BookHistory } from '../../../../database/entities/BookHistory'
import BookHistoryInfo from './BookHistoryInfo'

@Component
export default struct BookHistoryContent {
  @State bookHistory:BookHistory[] = []
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Prop searchValue:string
  @Prop @Watch('changeBookType')currentIndex: number
  //更新数据累加刷新数据页面
  @StorageLink('BOOK_IS_BOOK_HISTORY_REFRESHING') @Watch('getBookHistoryList') isBookHistoryRefreshing: number = 0
  aboutToAppear(): void {
    this.getBookHistoryList()
  }
  changeBookType(){
    this.getBookHistoryList()
    this.isBookHistoryRefreshing++
  }
  getBookHistoryList(){
    bookHistoryDao.search({
      type:this.currentIndex,
      sort:0
    }).then((val)=>{
      this.bookHistory = val
    })
  }

  build() {
    if (this.bookHistory.length === 0){
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
        Column(
          { space: 10 }
        ) {
          ForEach(this.bookHistory, (item: BookHistory) => {
            BookHistoryInfo({
              bookHistory:item
            })
          })
        }
        .backgroundColor('rgba(255,250,247,0.8)')
      }
    }
  }
}