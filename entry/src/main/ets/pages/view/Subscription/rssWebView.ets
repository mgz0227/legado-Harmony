import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { showMessage } from '../../../componets/common/promptShow';
import ImportCommon from '../../../componets/import/ImportCommon';
import { BookSource } from '../../../database/entities/BookSource';
import { isNetworkUrl, sleep } from '../../../common/utils/utils';
import axios, { AxiosResponse } from '@ohos/axios';
import SubscriptionImport from '../../../componets/import/SubscriptionImport';
import { rssSources, SUBSCRIPTION_GROUP_TYPE } from '../../../database/entities/rssSources';
import CommonConstants from '../../../common/constants/CommonConstants';
import PaddingConstants from '../../../common/constants/PaddingConstants';
import SubscriptionDao from '../../../database/dao/SubscriptionDao';
import subscriptionDao from '../../../database/dao/SubscriptionDao';
import WebSetup from './components/WebSetup';

interface RouteParams {
  url: string, //id不传默认用url校验是否存在订阅源有存
  id:number //id是订阅源页面跳转用来传递的用于删除的其它页面可不传
}

@Entry
@Component
@Preview
struct RssWebView {
  @State sourcesUrl:string = ''
  @State sourcesId:number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  controller: webview.WebviewController = new webview.WebviewController();
  regex:string = `/booksource/importonline\\?src=(http[s]?://[^/]+/[^\"']+)`;
  regexRss:string = `/rsssource/importonline\\?src=(http[s]?://[^/]+/[^\"']+)`;
  legadoRegex:string = `/import/auto\\?src=(http[s]?://[^/]+/[^\"']+)`
  @State isCollection:boolean = false
  @StorageLink(CommonConstants.RSS_SOURCES_REFRESHING) refreshing: number = 0
  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as RouteParams;
    this.sourcesUrl = params.url
    this.sourcesId = params.id??0
    this.isCollection = await subscriptionDao.queryByUrl(this.sourcesUrl) //是否收藏
  }

  onBackPress(){
    this.webOnBackPress()
    return true
  }

  //是否后退网页
  webOnBackPress(){
    let canGoForward = this.controller.accessForward()//是否可前进
    let canGoBackward =this.controller.accessBackward() //是否可以后退
    if (canGoBackward) {
      this.controller.backward() // 后退一个页面
    }
    if (!canGoBackward) {
      router.back()
      setTimeout(() => {
        this.refreshing++
      }, 200)
    }
  }


  @State webTitle:string = ''
  @State formModel: rssSources = {
    sourceName: '',
    sourceUrl: '',
    sourceIcon: '',
    sourceType: 0,
    sourceIconIsUrl: false,
    enabledCookieJar: false,
    lastUpdateTime: new Date().getTime(),
    customOrder: 0,
    autoComplete: false,
    sourceGroup: SUBSCRIPTION_GROUP_TYPE[4],
    enabled: true,
    singleUrl: true,
    showRecentIcon: true,
    customizeTitle: ''
  }

  build() {
    Column(){
      Column(){
        Web({ src: this.sourcesUrl||'www.baidu.com', controller: this.controller })
          .onPageBegin((event) => {
            //设置setCustomUserAgent为手机
            this.controller.setCustomUserAgent('Mozilla/5.0 (Linux; Android 13; M2007J3SC Build/TP1A.220624.014; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.101 Mobile Safari/537.36')
          })
          .layoutWeight(1)
          .onPageEnd((event) => {
            this.getOnclickUrl(event?.url || '')
            this.formModel.sourceUrl = event.url ?? ''
            this.formModel.sourceName = this.controller.getTitle().slice(0, 19)
            this.webTitle = this.controller.getTitle()
          })
          .onScroll((event) => {
            showMessage("x = " + event.xOffset)
            showMessage("y = " + event.yOffset)
            console.info("x = " + event.xOffset);
            console.info("y = " + event.yOffset);
          })
        this.webFooter()
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
    .padding({ top: this.topRectHeight, bottom: this.bottomRectHeight})
  }

  @Builder
  webFooter() {
    Row({
      space:PaddingConstants.PADDING_16
    }) {
      Image($r('app.media.return_left'))
        .width(25)
        .height(25)
        .onClick(()=>{
          router.back()
          setTimeout(() => {
            this.refreshing++
          }, 10)
        })
      Row(){
        Row({
          space:PaddingConstants.PADDING_12
        }){
          Text(this.webTitle??'')
            .font({
              size:12,
              weight:500,
              family: CommonConstants.FAMILY_PingFANG
            })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .layoutWeight(1)
            .onClick(() => {

            })
          Row(){
            Text('搜书')
              .font({
                size:10,
                weight:400,
                family: CommonConstants.FAMILY_PingFANG
              })
              .fontColor(Color.White)
              .padding({
                left:PaddingConstants.PADDING_12,
                right:PaddingConstants.PADDING_12
              })
              .textAlign(TextAlign.Center)
          }
          .padding(5)
          .backgroundColor($r('app.string.color_black_88'))
          .borderRadius(4)
        }
        .padding(5)
      }
      .layoutWeight(1)
      .border({
        width:2,
        color:$r('app.string.color_black_88')
      })
      .borderRadius(8)

      Image(this.isCollection?$r('app.media.icon_collect_selected'):$r('app.media.icon_collect_unselected'))
        .width(24)
        .height(24)
        .onClick(async ()=>{
          if (this.isCollection) {
            subscriptionDao.deleteRssSourcesById({
              id:this.sourcesId,
              url:this.sourcesUrl
            })
            this.isCollection = false
          } else {
            SubscriptionDao.insert(this.formModel)
            this.isCollection = true
          }
          showMessage(this.isCollection?'收藏成功':'取消收藏')
        })

      Image($r('app.media.icon_browser_more'))
        .width(24)
        .height(24)
        .onClick(()=>{
         this.webSetupDialog?.open()
        })
    }
    .padding({left:20,right:20,top:14})
  }

  webSetupDialog: CustomDialogController | null = new CustomDialogController({
    builder: WebSetup({
      refreshing:()=>{
        this.controller.refresh()
      }
    }),
    cancel: this.exitDialog,
    autoCancel: true,
    width:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true
  })
  //退出弹框
  exitDialog(){
    this.webSetupDialog?.close()
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