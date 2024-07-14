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
  @State errorExplore: boolean = false
  @State contentExplore: string = ''

  aboutToAppear() {
    this.getList()
  }

  getList() {
    let url = this.exploreItem.url.replace('{{page}}', "1")
    if (!isNetworkUrl(url)) {
      url = this.bookSourceUrl + url
    }
    console.info('TagInfo 请求地址：', url)
    // TODO 需要可正常使用的进行调试
    axios.get(url).then((res: AxiosResponse) => {
      console.info('TagInfo 请求成功：', JSON.stringify(res.data))
      this.contentExplore = JSON.stringify(res.data)
    }).catch((err: AxiosError) => {
      console.log('TagInfo 请求失败：', JSON.stringify(err.message));
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
        if (this.errorExplore) {
          noFind().padding({
            top: 75
          })
        } else {
          Text('请求成功，需要解析')
          Text(this.contentExplore)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .maxLines(8)
        }
      }
      .padding({left: 16, right: 16, bottom: 16})
      .borderRadius(12)
      .backgroundColor(Color.White)
      // .height(436)
    }
    .margin({ top: 12 })
  }
}