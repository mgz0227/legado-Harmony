import Header from '../../../../componets/common/Header';
import { router } from '@kit.ArkUI';
import { ExploreItem, ExploreQuery } from '../../../../database/types/BookSourceType';
import { ExploreRule } from '../../../../database/entities/rule';
import RefreshComponent from '../../../../componets/common/RefreshComponent';
import { isNetworkUrl } from '../../../../common/utils/utils';
import axios, { AxiosResponse } from '@ohos/axios';
import noFind from '../../../../componets/common/noFind';
import { CardItem } from '../components/CardItem';
import CommonConstants from '../../../../common/constants/CommonConstants';
import { BookSource } from '../../../../database/entities/BookSource';

interface RouteParams {
  bookSource: BookSource,
  exploreItem: ExploreItem,
  currentIndex: number
}

@Entry
@Component
struct CateGoryListPage {
  @State exploreItem: ExploreItem = {
    title: '',
    url: ''
  }
  @State bookSource?: BookSource = {
    bookSourceUrl: '',
    bookSourceName: '',
    bookSourceType: 0,
    customOrder: 0,
    enabled: false,
    enabledExplore: false,
    lastUpdateTime: 0,
    respondTime: 0,
    weight: 0,
    isTop: false,
    showRecentIcon: false,
    showExplore: true
  }
  @State pageNum: number = 1
  @State pageSize: number = 10
  @State bookList: ExploreRule[] = []
  @State startLoading: boolean = false
  @State loading: boolean = false
  @State isRefreshing: boolean = false
  @State RefreshingTitle: string = '松开刷新'
  @State currentIndex:number = 0
  async aboutToAppear() {
    this.startLoading = true
    const params = router.getParams() as RouteParams;
    this.currentIndex = params.currentIndex
    console.log('TagInfo', JSON.stringify(params))
    this.bookSource = params.bookSource
    this.exploreItem = params.exploreItem
    await this.getList()
    this.startLoading = false
  }

  async getList() {
    if (!this.bookSource) return
    const bookSourceUrl = this.bookSource.bookSourceUrl
    const exploreRule = this.bookSource.ruleExplore
    const searchRule = this.bookSource.ruleSearch
    let url = this.exploreItem.url.replace('{{page}}', this.pageNum.toString())
    if (!isNetworkUrl(url)) {
      url = bookSourceUrl + url
    }
    const exploreQuery: ExploreQuery = {
      url,
      pageSize: this.pageSize,
      bookList: exploreRule?.bookList || searchRule?.bookList,
      name: exploreRule?.name || searchRule?.name,
      author: exploreRule?.author || searchRule?.author,
      intro: exploreRule?.intro || searchRule?.intro,
      kind: exploreRule?.kind || searchRule?.kind,
      lastChapter: exploreRule?.lastChapter || searchRule?.lastChapter,
      bookUrl: exploreRule?.bookUrl || searchRule?.bookUrl,
      coverUrl: exploreRule?.coverUrl || searchRule?.coverUrl,
      wordCount: exploreRule?.wordCount || searchRule?.wordCount
    }
    if (this.pageNum * this.pageSize - this.bookList.length >= this.pageSize * 2 && !this.startLoading) {
      return
    }
    this.loading = true
    try {
      const res: AxiosResponse = await axios.post(CommonConstants.BASE_URL + '/common/analysisRules', exploreQuery)
      console.info('TagInfo, 解析内容：', JSON.stringify(res.data))
      const bookList = (res.data as ExploreRule[]).map(item => {
        if (item.coverUrl && !isNetworkUrl(item.coverUrl)) {
          item.coverUrl = bookSourceUrl + item.coverUrl
        }
        return item
      })
      if (this.pageNum === 1) {
        this.bookList = bookList
      } else {
        this.bookList = this.bookList.concat(bookList)
      }
      this.loading = false
    } catch (err) {
      console.log('TagInfo 请求失败：', JSON.stringify(err.message));
      this.loading = false
    }
  }

  build() {
    Column() {
      Header({
        title: this.exploreItem.title
      })

      Column() {
        Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
          Scroll() {
            Column() {
              if (this.startLoading) {
                Row() {
                  LoadingProgress()
                    .color(0xff6600)
                    .width(35)
                  Text('内容加载中...')
                }
                .height('100%')
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
              } else if (this.bookList.length === 0) {
                noFind({
                  hintIndex: 0
                })
              } else {
                ForEach(this.bookList, (item: ExploreRule, index) => {
                  CardItem({ item: item , currentIndex:this.currentIndex })
                })
              }
            }
            .padding({ left: 16, right: 16 })
          }
          .padding({ bottom: 16 })
          .scrollBar(BarState.Off)
          .onReachEnd(() => {
            this.pageNum += 1
            this.getList()
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
          setTimeout(async () => {
            this.pageNum = 1
            this.startLoading = true
            await this.getList()
            this.startLoading = false
            this.isRefreshing = false
          }, 1000)
        })
      }
      .layoutWeight(1)

    }
    .height('100%')
    .width('100%')
  }

  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }
}