/**
 * @author 2008
 * @datetime 2024/7/14 21:54
 * @className: BookFind
 * 发现公用书籍展示组件
 */
import axios, { AxiosResponse, AxiosError } from '@ohos/axios'
import { isNetworkUrl } from '../../../../common/utils/utils'
import noFind from '../../../../componets/common/noFind'
import { ExploreRule } from '../../../../database/entities/rule'
import { ExploreItem, ExploreQuery } from '../../../../database/types/BookSourceType'
import mayAlsoLike from '../mayAlsoLike'
import { CardItem } from './CardItem'
import { router } from '@kit.ArkUI'
import CommonConstants from '../../../../common/constants/CommonConstants';
import { BookSource } from '../../../../database/entities/BookSource'

@Component
export default struct BookFindContent {
  @Prop currentIndex: number
  @Prop exploreItem: ExploreItem
  @Prop @Watch('getList') counter: number = 0
  @State loading: boolean = true
  @State errorExplore: boolean = false
  @State bookList: ExploreRule[] = []
  @Prop bookSource?: BookSource
  handleClick: () => void = () => {
  }

  aboutToAppear() {
    this.getList()
    if (!this.bookSource) return
  }

  getList() {
    if (!this.bookSource) return
    const bookSourceUrl = this.bookSource.bookSourceUrl
    const exploreRule = this.bookSource.ruleExplore
    const searchRule = this.bookSource.ruleSearch
    this.loading = true
    let url = this.exploreItem.url.replace('{{page}}', "1")
    if (!isNetworkUrl(url)) {
      url = bookSourceUrl + url
    }
    const exploreQuery: ExploreQuery = {
      url,
      pageSize: 3,
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
    console.info('解析参数:', JSON.stringify(exploreQuery))
    axios.post(CommonConstants.BASE_URL + '/common/analysisRules', exploreQuery).then((res: AxiosResponse) => {
      console.info('TagInfo, 解析内容：', JSON.stringify(res.data))
      this.bookList = (res.data as ExploreRule[]).map(item => {
        if (item.coverUrl && !isNetworkUrl(item.coverUrl)) {
          item.coverUrl = bookSourceUrl + item.coverUrl
        }
        return item
      })
      this.loading = false
      this.errorExplore = false
    }).catch((err: AxiosError) => {
      console.log('TagInfo 请求失败：', JSON.stringify(err.message));
      this.loading = false
      this.errorExplore = true
    })
  }

  build() {
    Column({
      space: 16
    }) {
      Column() {
        mayAlsoLike({
          mayAlsoLike: this.exploreItem.title,
          handleClick: this.handleClick
        })
        if (this.loading) {
          Column() {
            LoadingProgress()
              .color(0xff6600)
              .width('50%')
            Text('内容加载中...')
          }
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
        } else if (this.errorExplore) {
          noFind({
            onclick: () => {
              this.getList()
            }
          })
        } else if (this.bookList.length === 0) {
          noFind({
            hintIndex: 0
          })
        } else {
          Column() {
            ForEach(this.bookList, (item: ExploreRule, index) => {
              CardItem({ item: item ,currentIndex:this.currentIndex})
            })
            if (this.bookList.length === 3) {
              Column() {
                Text('查看更多')
                  .lineHeight(20)
                  .fontColor('#73000000')
              }
              .width('100%')
              .padding({ top: 8, bottom: 8 })
              .margin({ top: 20 })
              .backgroundColor('#0F000000')
              .borderRadius(4)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/view/Find/CategoryList/Index',
                  params: {
                    bookSource: this.bookSource,
                    exploreItem: this.exploreItem,
                    currentIndex: this.currentIndex
                  }
                })
              })
            }
          }
          .height('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
        }
      }
      .padding({
        left: 16,
        right: 16,
        top: 20,
        bottom: 20
      })
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)
    }
    .margin({ top: 12 })
  }
}