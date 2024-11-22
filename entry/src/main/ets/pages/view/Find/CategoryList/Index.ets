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
import { ThemeColorItem, ThemeItem } from '../../../../common/model/Theme';
import { ThemeStorageKey } from '../../../../common/constants/Theme';

interface RouteParams {
  bookSourceUrl: string,
  exploreItem: ExploreItem,
  exploreRule: ExploreRule,
  currentIndex: number
}

@Entry
@Component
struct CateGoryListPage {
  @State bookSourceUrl: string = ''
  @State exploreItem: ExploreItem = {
    title: '',
    url: ''
  }
  @State exploreRule: ExploreRule = {}
  @State pageNum: number = 1
  @State pageSize: number = 10
  @State bookList: ExploreRule[] = []
  @State startLoading: boolean = false
  @State loading: boolean = false
  @State isRefreshing: boolean = false
  @State RefreshingTitle: string = '松开刷新'
  @State currentIndex:number = 0

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  async aboutToAppear() {
    this.startLoading = true
    const params = router.getParams() as RouteParams;
    this.currentIndex = params.currentIndex
    console.log('TagInfo', JSON.stringify(params))
    this.bookSourceUrl = params.bookSourceUrl
    this.exploreItem = params.exploreItem
    this.exploreRule = params.exploreRule
    await this.getList()
    this.startLoading = false
  }

  async getList() {
    let url = this.exploreItem.url.replace('{{page}}', this.pageNum.toString())
    if (!isNetworkUrl(url)) {
      url = this.bookSourceUrl + url
    }
    const exploreQuery: ExploreQuery = {
      url,
      bookList: this.exploreRule.bookList,
      pageSize: this.pageSize,
      name: this.exploreRule.name,
      author: this.exploreRule.author,
      intro: this.exploreRule.intro,
      kind: this.exploreRule.kind,
      lastChapter: this.exploreRule.lastChapter,
      bookUrl: this.exploreRule.bookUrl,
      coverUrl: this.exploreRule.coverUrl,
      wordCount: this.exploreRule.wordCount
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
          item.coverUrl = this.bookSourceUrl + item.coverUrl
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
                    .color(this.theme.mainColor)
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