import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { showMessage } from '../../../componets/common/promptShow';
import ImportCommon from '../../../componets/import/ImportCommon';
import { BookSource } from '../../../database/entities/BookSource';
import { isNetworkUrl, sleep } from '../../../common/utils/utils';
import axios, { AxiosResponse } from '@ohos/axios';
import SubscriptionImport from '../../../componets/import/SubscriptionImport';
import { rssSources } from '../../../database/entities/rssSources';

interface RouteParams {
  url: string,
}

@Entry
@Component
@Preview
struct RssWebView {
  @State sourcesUrl:string = ''
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  controller: webview.WebviewController = new webview.WebviewController();
  regex:string = `/booksource/importonline\\?src=(http[s]?://[^/]+/[^\"']+)`;
  regexRss:string = `/rsssource/importonline\\?src=(http[s]?://[^/]+/[^\"']+)`;
  legadoRegex:string = `/import/auto\\?src=(http[s]?://[^/]+/[^\"']+)`
  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    this.sourcesUrl = params.url
  }

  build() {
    Column(){
      Row({ space: 15 }) {
        Image($r('app.media.return_left'))
          .width(25)
          .height(25)
          .onClick(()=>{
            router.back()
          })
      }
      .height(30)
      .margin({left:5})
      .width("100%")
      Column(){
        Web({ src: this.sourcesUrl||'www.baidu.com', controller: this.controller })
          .onPageBegin((event) => {
            //设置setCustomUserAgent为手机
            this.controller.setCustomUserAgent('Mozilla/5.0 (Linux; Android 13; M2007J3SC Build/TP1A.220624.014; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.101 Mobile Safari/537.36')
          })
          .layoutWeight(1)
          .onPageEnd((event) => {
            this.getOnclickUrl(event.url)
          })
          .onScroll((event) => {
            showMessage("x = " + event.xOffset)
            showMessage("y = " + event.yOffset)
            console.info("x = " + event.xOffset);
            console.info("y = " + event.yOffset);
          })
      }
      Flex()
        .bindSheet($$this.isShowImportBookSource, this.dialogImportBookFunction(), {
          detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE, 200],
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isShowImportBookSource = false
          }
        })

      Flex()
        .bindSheet($$this.isShowImportRssSources, this.dialogImportRssFunction(), {
          detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE, 200],
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isShowImportRssSources = false
          }
        })
    }
    .padding({ top: this.topRectHeight, bottom: this.bottomRectHeight + 20 })
  }
  @State isShowImportBookSource: boolean = false
  @State sourceList: BookSource[] = []
  @Builder
  dialogImportBookFunction() {
    Flex() {
      ImportCommon({ sourceList: this.sourceList, show: this.isShowImportBookSource })
    }
  }
  @State subscriptionList:rssSources[] = []
  @State isShowImportRssSources:boolean = false
  @Builder dialogImportRssFunction() {
    Flex() {
      SubscriptionImport({ subscriptionList:this.subscriptionList,show: this.isShowImportRssSources})
    }
  }
  getOnclickUrl(postUrl:string) {
    let url = decodeURIComponent(postUrl);
    //如果url存在匹配返回false
    // if (url.match(this.regex) || url.match(this.regexRss) || url.match(this.legadoRegex)) {
    //   return false
    // }
    const match = url.match(this.regex);
    if (match  && match[1]) {
      let urlBook = decodeURIComponent(match[1]);
      this.pasteAnalyzeBookSource(urlBook)
      this.controller.backward()
      this.controller.scrollTo(0, 0)
      return false
    }
    const matchRss = url.match(this.regexRss);
    if (matchRss  && matchRss[1]) {
      let urlRss = decodeURIComponent(matchRss[1]);
      this.pasteAnalyzeRssSource(urlRss)
      this.controller.backward()
      return false
    }
    const legadoMatch = url.match(this.legadoRegex);
    if (legadoMatch  && legadoMatch[1]) {
      let urlLegado= decodeURIComponent(legadoMatch[1]);
      showMessage(urlLegado) //todo 替换规则导入
      this.controller.backward()
      return false
    }
    return true
  }
  // 发现
  async pasteAnalyzeBookSource(url:string) {
    try {
      if (!url) {
        showMessage('未获取到相关Url，请求默认数据')
        url = 'https://node.wisdoms.xin/static/file/20240704/sy.json'
        await sleep()
      }
      if (!isNetworkUrl(url ?? '')) {
        showMessage('链接不正确')
        return
      }
      const res: AxiosResponse = await axios.get(url ?? 'https://node.wisdoms.xin/static/file/20240704/sy.json');
      if (res) {
        console.log('res', JSON.stringify(res))
        this.sourceList = res.data;
        this.isShowImportBookSource = true;
      } else {
        showMessage('订阅源解析失败')
      }
    } catch (err) {
      showMessage('订阅源解析失败')
      console.error('错误 ' + err);
    }
  }
  // 订阅
  async pasteAnalyzeRssSource(url:string) {
    try {
      if (!url) {
        showMessage('未获取到相关Url，请求默认数据')
        url = 'http://yuedu.miaogongzi.net/shuyuan/miaogongziDY.json'
        await sleep()
      }
      if (!isNetworkUrl(url ?? '')) {
        showMessage('链接不正确')
        return
      }
      const res: AxiosResponse = await axios.get(url ?? 'http://yuedu.miaogongzi.net/shuyuan/miaogongziDY.json');
      if (res) {
        console.log('res', JSON.stringify(res))
        this.subscriptionList = res.data;
        this.isShowImportRssSources = true;
      } else {
        showMessage('订阅源解析失败')
      }

    } catch (err) {
      showMessage('订阅源解析失败')
      console.error('错误 ' + err);
    }
  }
}