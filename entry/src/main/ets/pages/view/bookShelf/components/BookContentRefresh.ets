/**
 * @author 2008
 * @datetime 2024/7/23 12:18
 * @className: BookContentRefresh
 */
import RefreshComponent from '../../../../componets/common/RefreshComponent'
import BookFolder from '../BookFolder'
import ShelfBookList from '../Shelf/ShelfBookList'
import BookContent from './BookContent'

@Component
export default struct BookContentRefresh {
  @State @Watch('changeRefreshing')isRefreshing: boolean = false
  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  @State counter: number = 0
  @State RefreshingTitle: string = '松开刷新'
  @Link bookType:string
  @Prop currentIndex: number = 0
  @Link EXHIBIT: string
  @Link GROUP: string
  @Link searchValue: string
  @Prop isClear: boolean = false

  changeRefreshing(){
    if (this.isRefreshing) {
      this.isBookRefreshing++
    }
  }
  build() {
    Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
      Scroll() {
        Column() {
          if (this.bookType === '书单' && this.searchValue !== '浏览历史') {
            ShelfBookList({
              EXHIBIT: this.EXHIBIT,
              isClear: this.isClear
            })
          } else {
            if (this.GROUP === '标签') {
              BookContent({
                currentIndex:this.currentIndex,
                bookType:this.bookType,
                EXHIBIT: this.EXHIBIT
              })
            } else {
              BookFolder({
                EXHIBIT: this.EXHIBIT
              })
            }
          }
        }
        .padding({ left: 10, right: 10, bottom: 30 })
      }
      .scrollBar(BarState.Off)
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

    })
  }
  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }
}