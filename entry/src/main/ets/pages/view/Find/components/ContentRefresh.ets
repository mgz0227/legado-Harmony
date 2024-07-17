import PaddingConstants from '../../../../common/constants/PaddingConstants'
import noSourceFind from '../../../../componets/common/noSourceFind'
import RefreshComponent from '../../../../componets/common/RefreshComponent'
import { BookSource } from '../../../../database/entities/BookSource'
import BookFindContent from './BookFindContent'
import { JSON } from '@kit.ArkTS'

interface ExploreItemStyle {
  layout_flexGrow: number;
  layout_flexBasisPercent: number;
}

export interface ExploreItem {
  title: string,
  url: string,
  style: ExploreItemStyle
}

@Component
export default struct ContentRefresh {
  currentIndex: number = 0
  @Prop bookSource: BookSource = {
    bookSourceUrl: '',
    bookSourceName: '',
    bookSourceType: 0,
    customOrder: 0,
    enabled: false,
    enabledExplore: false,
    lastUpdateTime: 0,
    respondTime: 0,
    weight: 0
  }
  @State isRefreshing: boolean = false
  @State RefreshingTitle: string = '松开刷新'
  @State counter: number = 0
  @Link hasExploreUrl: boolean
  @State pageSize: number = 4
  @State pageNum: number = 1
  @State exploreList: ExploreItem[] = []
  @State showExploreList: ExploreItem[] = []

  aboutToAppear() {
    try {
      console.info('TagInfo: 书源地址：', this.bookSource.bookSourceUrl)
      console.info('TagInfo: 发现地址：', JSON.stringify(JSON.parse(this.bookSource.exploreUrl ?? '[]')))
      const exploreList = JSON.parse(this.bookSource.exploreUrl ?? '[]') as ExploreItem[]
      this.exploreList = exploreList.filter(item =>!!item.url)
      this.pageNum = 1
      this.getShowExploreList()
    } catch (err) {
      console.info('TagInfo', JSON.stringify(err))
    }
  }

  getShowExploreList() {
    this.showExploreList = this.exploreList.slice(0, this.pageNum * this.pageSize)
  }

  build() {
    if (!this.bookSource.exploreUrl) {
      noSourceFind({
        setOnclick: () => {
          this.hasExploreUrl = true
        }
      })
        .margin({
          top: PaddingConstants.PADDING_20
        })
    } else {
      Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
        Scroll() {
          Column() {
            ForEach(this.exploreList, (item: ExploreItem) => {
              BookFindContent({
                currentIndex: this.currentIndex,
                bookSourceUrl: this.bookSource.bookSourceUrl,
                exploreItem: item,
                counter: this.counter
              })
            })
          }
          .padding({ left: 16, right: 16 })
        }
        .padding({ bottom: 16 })
        .scrollBar(BarState.Off)
        .onReachEnd(() => {
          this.pageNum += 1
          this.getShowExploreList()
        })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        if (refreshStatus === 1 || refreshStatus === 2) {
          this.RefreshingTitle = '松开刷新'
        } else {
          this.RefreshingTitle = '刷新中...'
        }
      })
      .height('100%')
      .onRefreshing(() => {
        setTimeout(() => {
          this.pageNum = 1
          this.getShowExploreList()
          this.counter++
          this.isRefreshing = false
        }, 1000)
      })
    }
  }

  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }
}