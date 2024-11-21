/**
 * @author 2008
 * @datetime 2024/7/14 23:19
 * @className: rssSources
 * 订阅源Date
 */
import { GSON } from '../../common/utils/utils'
import { rssListRule } from './rule/rssListRule'
import { rssWebViewRule } from './rule/rssWebViewRule'

@Observed
export class rssSources{
  id?:number
  //订阅源类型0.常规网站 1.订阅源
  sourceType:number = 0
  //名称
  sourceName:string = ''
  //地址url
  sourceUrl:string = ''
  //图标
  sourceIcon:string = ''
  // 图标是否使用链接
  sourceIconIsUrl:boolean = false
  // 分组
  sourceGroup:string = SUBSCRIPTION_GROUP_TYPE[4]
  //源注解
  sourceComment?:string
  //是否启用
  enabled: boolean = true
  // 自定义变量说明
  variableComment?:string
  // js库
  jsLib?:string
  // 启用okhttp CookieJAr 自动保存每次请求的cookie
  enabledCookieJar:boolean = false
  // 并发率
  concurrentRate?:string
  // 请求头
  header?:string
  // 登录地址
  loginUrl?:string
  // 登录UI
  loginUi?:string
  // 登录检测js
  loginCheckJs?:string
  // 封面解密js
  coverDecodeJs?:string
  // 分类地址
  sortUrl?:string
  // 单URL
  singleUrl:boolean = true
  // 文章样式
  articleStyle?:string
  //最后更新时间
  lastUpdateTime:number = 0
  // 排序编号
  customOrder:number = 0
  //设置源变量
  variable?:string
  //是否新增或则更新点击过
  showRecentIcon:boolean = true
  //自动补全
  autoComplete:boolean = true
  //自定义文字
  customizeTitle:string = ''
  //列表
  rssListRule?:rssListRule
  //webView
  rssWebViewRule?:rssWebViewRule
}

export interface rssGroupList {
  title: string
  list: rssSources[]
}

export class rssArticles{
  origin:string = ''
  sort:string = ''
  title:string = ''
  order:number = 0
  link:string = ''
  pubDate:string = ''
  description?:string
  content?:string
  image?:string
  read:number = 0
  variable?:string
}

export class rssReadRecords{
  record:string = ''
  read:number = 0
}


export class rssStars {
  origin:string = ''
  sort:string = ''
  title:string = ''
  starTime?:Date
  link:string = ''
  pubDate:string = ''
  description?:string
  content?:string
  image?:string
  read:number = 0
  variable?:string
}

//订阅源分组类别
export const SUBSCRIPTION_GROUP_TYPE: Record<number, string> ={
  0: '小说',
  1: '漫画',
  2: '影视',
  3: '资讯',
  4: '收藏夹'
}

//订阅源分组类别
export const SUBSCRIPTION_TYPE: Record<number, string> ={
  0: '常规网站',
  1: '订阅源'
}

export const WEB_USER_AGENT: string[] = [
  'Mozilla/5.0 (Linux; Android 13; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Mobile Safari/537.36',
  'Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Mobile/15E148 Safari/604.1',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36',
  'Mozilla/5.0 (Custom Device; Custom OS 1.0; Custom Build) AppleWebKit/537.36 (KHTML, like Gecko) CustomBrowser/1.0 CustomSafari/537.36'
]


export interface rssSourceDb extends Omit<rssSources, 'rssListRule' | 'rssWebViewRule'> {
  //列表
  rssListRule?: string
  //webView
  rssWebViewRule?: string
}


export const ToRssSources = (rssSourceDb: rssSourceDb) => {
  const rssListRule = GSON.toJson<rssListRule>(rssSourceDb.rssListRule);
  const rssWebViewRule = GSON.toJson<rssWebViewRule>(rssSourceDb.rssWebViewRule);
  const rssSources: rssSources = {
    id: rssSourceDb.id,
    sourceType: rssSourceDb.sourceType,
    sourceName: rssSourceDb.sourceName,
    sourceUrl: rssSourceDb.sourceUrl,
    sourceIcon: rssSourceDb.sourceIcon,
    sourceIconIsUrl: rssSourceDb.sourceIconIsUrl,
    sourceGroup: rssSourceDb.sourceGroup,
    sourceComment: rssSourceDb.sourceComment,
    enabled: rssSourceDb.enabled,
    variableComment: rssSourceDb.variableComment,
    jsLib: rssSourceDb.jsLib,
    enabledCookieJar: rssSourceDb.enabledCookieJar,
    concurrentRate: rssSourceDb.concurrentRate,
    header: rssSourceDb.header,
    loginUrl: rssSourceDb.loginUrl,
    loginUi: rssSourceDb.loginUi,
    loginCheckJs: rssSourceDb.loginCheckJs,
    coverDecodeJs: rssSourceDb.coverDecodeJs,
    sortUrl: rssSourceDb.sortUrl,
    singleUrl: rssSourceDb.singleUrl,
    articleStyle: rssSourceDb.articleStyle,
    lastUpdateTime: rssSourceDb.lastUpdateTime,
    customOrder: rssSourceDb.customOrder,
    variable: rssSourceDb.variable,
    autoComplete: rssSourceDb.autoComplete,
    showRecentIcon:rssSourceDb.showRecentIcon,
    customizeTitle:rssSourceDb.customizeTitle,
    rssListRule,
    rssWebViewRule
  }
  return rssSources
}


export const ToRssSourcesDb = (rssSource: rssSources) => {
  const rssListRule = GSON.toString(rssSource.rssListRule);
  const rssWebViewRule = GSON.toString(rssSource.rssWebViewRule);
  const rssSourcesDb: rssSourceDb = {
    id: rssSource.id,
    sourceType: rssSource.sourceType,
    sourceName: rssSource.sourceName,
    sourceUrl: rssSource.sourceUrl,
    sourceIcon: rssSource.sourceIcon,
    sourceIconIsUrl: rssSource.sourceIconIsUrl,
    sourceGroup: rssSource.sourceGroup,
    sourceComment: rssSource.sourceComment,
    enabled: rssSource.enabled,
    variableComment: rssSource.variableComment,
    jsLib: rssSource.jsLib,
    enabledCookieJar: rssSource.enabledCookieJar,
    concurrentRate: rssSource.concurrentRate,
    header: rssSource.header,
    loginUrl: rssSource.loginUrl,
    loginUi: rssSource.loginUi,
    loginCheckJs: rssSource.loginCheckJs,
    coverDecodeJs: rssSource.coverDecodeJs,
    sortUrl: rssSource.sortUrl,
    singleUrl: rssSource.singleUrl,
    articleStyle: rssSource.articleStyle,
    lastUpdateTime: rssSource.lastUpdateTime,
    customOrder: rssSource.customOrder,
    variable: rssSource.variable,
    autoComplete: rssSource.autoComplete,
    showRecentIcon: rssSource.showRecentIcon,
    customizeTitle: rssSource.customizeTitle,
    rssListRule,
    rssWebViewRule
  }
  return rssSourcesDb
}


