/**
 * @author 2008
 * @datetime 2024/7/23 12:18
 * @className: BookContentRefresh
 */
import { showMessage } from '../../../../componets/common/promptShow'
import RefreshComponent from '../../../../componets/common/RefreshComponent'
import BookFolder from '../BookFolder'
import WorksBookLists from '../Shelf/WorksBookLists'
import BookContent from './BookContent'
import BookHistoryContent from './BookHistoryContent'

@Component
export default struct BookContentRefresh {
  @State @Watch('changeRefreshing')isRefreshing: boolean = false
  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  @StorageLink('BOOK_IS_BOOK_GROUPS_REFRESHING') isGroupRefreshing: number = 0
  @StorageLink('BOOK_IS_BOOK_WORKS_BOOK_LIST') isWorksBookListRefreshing: number = 0
  @StorageLink('BOOK_IS_BOOK_HISTORY_REFRESHING') isBookHistoryRefreshing: number = 0
  @State counter: number = 0
  @State RefreshingTitle: string = '松开刷新'
  @Prop currentIndex: number = 0
  @Link EXHIBIT: string
  @Link GROUP: string
  @Prop searchValue: string
  @Link bookTypeNumber:number
  @State checkGroup:Record<number, boolean> = {}
  changeRefreshing(){
    if (this.isRefreshing) {
      switch (this.bookTypeNumber){
        case 1:
          this.isGroupRefreshing++
          break;
        case 5:
          this.isWorksBookListRefreshing++
          break;
        default:
          this.isBookRefreshing++
          break
      }
      if (this.searchValue === '浏览历史') {
        this.isBookHistoryRefreshing++
      }
    }
  }
  build() {
    Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
      if (this.bookTypeNumber !== 5 && this.bookTypeNumber !== 1 && this.searchValue !== '浏览历史' ){
        BookContent({
          currentIndex:this.currentIndex,
          bookTypeNumber:this.bookTypeNumber,
          EXHIBIT: this.EXHIBIT,
          searchValue: this.searchValue
        })
      } else {
        Scroll() {
          Column() {
            if (this.bookTypeNumber === 5 && this.searchValue !== '浏览历史') {
              WorksBookLists({
                checkGroup: this.checkGroup,
                EXHIBIT: this.EXHIBIT,
                currentIndex:this.currentIndex,
                isShowCheck:false
              })
            } else {
              if (this.searchValue === '浏览历史') {
                BookHistoryContent({
                  currentIndex:this.currentIndex,
                  searchValue: this.searchValue
                })
              } else {
                BookFolder({
                  EXHIBIT: this.EXHIBIT,
                  currentIndex:this.currentIndex
                })
              }
            }
          }
          .padding({ left: 10, right: 10, bottom: 30 })
        }
        .scrollBar(BarState.Off)
      }
    }
    .height('100%')
    .margin({ top: this.searchValue === '浏览历史' ? 0 : 30 })
    .onStateChange((refreshStatus: RefreshStatus) => {
      if (refreshStatus === 1 || refreshStatus === 2) {
        this.RefreshingTitle = '松开刷新'
      } else {
        this.RefreshingTitle = '刷新中...'
      }
    })
    .onRefreshing(() => {
      setTimeout(() => {
        this.counter++
        this.isRefreshing = false
      }, 1000)
      showMessage('刷新成功')
    })
  }
  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }
}