/**
 * @author 2008
 * @datetime 2024/7/14 21:54
 * @className: BookFind
 * 发现公用书籍展示组件
 */
import axios, { AxiosResponse, AxiosError } from '@ohos/axios'
import { isNetworkUrl } from '../../../../common/utils/utils'
import noFind from '../../../../componets/common/noFind'
import mayAlsoLike from '../mayAlsoLike'
import { ExploreItem } from './ContentRefresh'

@Component
export default struct BookFindContent {
  @Prop currentIndex: number
  @Prop bookSourceUrl: string
  @Prop exploreItem: ExploreItem
  @Prop @Watch('getList')counter: number = 0
  @State loading: boolean = true
  @State errorExplore: boolean = false
  @State contentExplore: string = ''

  aboutToAppear() {
    this.getList()
  }

  getList() {
    this.loading = true
    let url = this.exploreItem.url.replace('{{page}}', "1")
    if (!isNetworkUrl(url)) {
      url = this.bookSourceUrl + url
    }
    console.info('TagInfo 请求地址：', url)
    // TODO 需要可正常使用的进行调试
    axios.get(url).then((res: AxiosResponse) => {
      this.loading = false
      console.info('TagInfo 请求成功：', JSON.stringify(res.data))
      this.contentExplore = JSON.stringify(res.data)
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
          mayAlsoLike: this.exploreItem.title
        })
        if (this.loading) {
          Column() {
            LoadingProgress()
              .color(0xff6600)
              .width('50%')
            Text('加载中...')
          }
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
        } else if (this.errorExplore) {
          noFind().padding({
            top: 75
          })
        } else {
          Text('请求成功，需要解析')
          Text(this.contentExplore)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .maxLines(15)
        }
      }
      .padding({left: 16, right: 16, top: 20, bottom: 20})
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)
    }
    .margin({ top: 12 })
  }
}