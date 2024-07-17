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
  sourceGroup:string = SUBSCRIPTION_GROUP_TYPE[0]
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
  //自动补全
  autoComplete:boolean = true
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
  3: '咨询',
  4: '收藏夹'
}

//订阅源分组类别
export const SUBSCRIPTION_TYPE: Record<number, string> ={
  0: '常规网站',
  1: '订阅源'
}


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
    rssListRule,
    rssWebViewRule
  }
  return rssSources
}


export const ToRssSourcesDb = (rssSourceDb: rssSources) => {
  const rssListRule = GSON.toString(rssSourceDb.rssListRule);
  const rssWebViewRule = GSON.toString(rssSourceDb.rssWebViewRule);
  const rssSourcesDb: rssSourceDb = {
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
    rssListRule,
    rssWebViewRule
  }
  return rssSourcesDb
}


