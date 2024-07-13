import { GSON } from '../../common/utils/utils'
import { BookSourcePart } from './BookSourcePart'
import { BookInfoRule, ContentRule, ExploreRule, ReviewRule, SearchRule, TocRule } from './rule'

// class BaseBookSource {
//   // 地址，包括 http/https
//   bookSourceUrl: string = ""
//   // 名称
//   bookSourceName: string = ""
//   // 分组
//   bookSourceGroup?: string
//   // 类型，0 文本，1 音频, 2 图片, 3 文件（指的是类似知轩藏书只提供下载的网站）
//   bookSourceType: number = 0
//   bookSourceGrade?: number = 2
//   bookSourceScore?: string
//   // 详情页url正则
//   bookUrlPattern?: string
//   // 手动排序编号
//   customOrder: number = 0
//   // 是否启用
//   enabled: boolean = true
//   // 启用发现
//   enabledExplore: boolean = true
//   // js库
//   jsLib?: String
//   // 启用okhttp CookieJAr 自动保存每次请求的cookie
//   enabledCookieJar?: boolean = true
//   // 并发率
//   concurrentRate?: string
//   // 请求头
//   header?: string
//   // 登录地址
//   loginUrl?: string
//   // 登录UI
//   loginUi?: string
//   // 登录检测js
//   loginCheckJs?: string
//   // 封面解密js
//   coverDecodeJs?: string
//   // 注释
//   bookSourceComment?: string
//   // 自定义变量说明
//   variableComment?: string
//   // 最后更新时间，用于排序
//   lastUpdateTime: number = 0
//   // 响应时间，用于排序
//   respondTime: number = 180000
//   // 智能排序的权重
//   weight: number = 0
//   // 发现url
//   exploreUrl?: string
//   // 发现筛选规则
//   exploreScreen?: string
//   // 搜索url
//   searchUrl?: string
//
//   constructor(bookSource: Partial<BaseBookSource>) {
//     this.bookSourceUrl = bookSource.bookSourceUrl || "";
//     this.bookSourceName = bookSource.bookSourceName || "";
//     this.bookSourceGroup = bookSource.bookSourceGroup;
//     this.bookSourceType = bookSource.bookSourceType ?? 0;
//     this.bookSourceGrade = bookSource.bookSourceGrade;
//     this.bookSourceScore = bookSource.bookSourceScore;
//     this.bookUrlPattern = bookSource.bookUrlPattern;
//     this.customOrder = bookSource.customOrder ?? 0;
//     this.enabled = bookSource.enabled ?? true;
//     this.enabledExplore = bookSource.enabledExplore ?? true;
//     this.jsLib = bookSource.jsLib;
//     this.enabledCookieJar = bookSource.enabledCookieJar ?? true;
//     this.concurrentRate = bookSource.concurrentRate;
//     this.header = bookSource.header;
//     this.loginUrl = bookSource.loginUrl;
//     this.loginUi = bookSource.loginUi;
//     this.loginCheckJs = bookSource.loginCheckJs;
//     this.coverDecodeJs = bookSource.coverDecodeJs;
//     this.bookSourceComment = bookSource.bookSourceComment;
//     this.variableComment = bookSource.variableComment;
//     this.lastUpdateTime = bookSource.lastUpdateTime ?? 0;
//     this.respondTime = bookSource.respondTime ?? 180000;
//     this.weight = bookSource.weight ?? 0;
//     this.exploreUrl = bookSource.exploreUrl;
//     this.exploreScreen = bookSource.exploreScreen;
//     this.searchUrl = bookSource.searchUrl;
//   }
// }

@Observed
export class BookSource {
  // 地址，包括 http/https
  bookSourceUrl: string = ""
  // 名称
  bookSourceName: string = ""
  // 分组
  bookSourceGroup?: string
  // 类型，0 文本，1 音频, 2 图片, 3 文件（指的是类似知轩藏书只提供下载的网站）
  bookSourceType: number = 0
  bookSourceGrade?: number = 2
  bookSourceScore?: string
  // 详情页url正则
  bookUrlPattern?: string
  // 手动排序编号
  customOrder: number = 0
  // 是否启用
  enabled: boolean = true
  // 启用发现
  enabledExplore: boolean = true
  // js库
  jsLib?: string
  // 启用okhttp CookieJAr 自动保存每次请求的cookie
  enabledCookieJar?: boolean = true
  // 并发率
  concurrentRate?: string
  // 请求头
  header?: string
  // 登录地址
  loginUrl?: string
  // 登录UI
  loginUi?: string
  // 登录检测js
  loginCheckJs?: string
  // 封面解密js
  coverDecodeJs?: string
  // 注释
  bookSourceComment?: string
  // 自定义变量说明
  variableComment?: string
  // 最后更新时间，用于排序
  lastUpdateTime: number = 0
  // 响应时间，用于排序
  respondTime: number = 180000
  // 智能排序的权重
  weight: number = 0
  // 发现url
  exploreUrl?: string
  // 发现筛选规则
  exploreScreen?: string
  // 搜索url
  searchUrl?: string
  // 发现规则
  ruleExplore?: ExploreRule
  // 搜索规则
  ruleSearch?: SearchRule
  // 书籍信息页规则
  ruleBookInfo?: BookInfoRule
  // 目录页规则
  ruleToc?: TocRule
  // 正文页规则
  ruleContent?: ContentRule
  // 段评规则
  ruleReview?: ReviewRule

  // constructor(bookSource: Partial<BookSource>) {
  //   this.bookSourceUrl = bookSource.bookSourceUrl || "";
  //   this.bookSourceName = bookSource.bookSourceName || "";
  //   this.bookSourceGroup = bookSource.bookSourceGroup;
  //   this.bookSourceType = bookSource.bookSourceType ?? 0;
  //   this.bookSourceGrade = bookSource.bookSourceGrade;
  //   this.bookSourceScore = bookSource.bookSourceScore;
  //   this.bookUrlPattern = bookSource.bookUrlPattern;
  //   this.customOrder = bookSource.customOrder ?? 0;
  //   this.enabled = bookSource.enabled ?? true;
  //   this.enabledExplore = bookSource.enabledExplore ?? true;
  //   this.jsLib = bookSource.jsLib;
  //   this.enabledCookieJar = bookSource.enabledCookieJar ?? true;
  //   this.concurrentRate = bookSource.concurrentRate;
  //   this.header = bookSource.header;
  //   this.loginUrl = bookSource.loginUrl;
  //   this.loginUi = bookSource.loginUi;
  //   this.loginCheckJs = bookSource.loginCheckJs;
  //   this.coverDecodeJs = bookSource.coverDecodeJs;
  //   this.bookSourceComment = bookSource.bookSourceComment;
  //   this.variableComment = bookSource.variableComment;
  //   this.lastUpdateTime = bookSource.lastUpdateTime ?? 0;
  //   this.respondTime = bookSource.respondTime ?? 180000;
  //   this.weight = bookSource.weight ?? 0;
  //   this.exploreUrl = bookSource.exploreUrl;
  //   this.exploreScreen = bookSource.exploreScreen;
  //   this.searchUrl = bookSource.searchUrl;
  // }
}

export interface GroupList {
  title: string
  list: BookSource[]
}

export interface GroupPartList {
  title: string
  list: BookSourcePart[]
}


export const GRADE_TYPE: Record<number, string> = {
  0: '常规',
  1: '优质',
  2: '精品'
}

export const BOOK_SOURCE_TYPE: Record<number, string> = {
  0 : '小说',
  1 : '漫画',
  2 : '有声'
}

export interface BookSourceDb extends Omit<BookSource, 'ruleExplore' | 'ruleSearch' | 'ruleBookInfo' | 'ruleToc' | 'ruleContent' | 'ruleReview'> {
  // 发现规则
  ruleExplore?: string
  // 搜索规则
  ruleSearch?: string
  // 书籍信息页规则
  ruleBookInfo?: string
  // 目录页规则
  ruleToc?: string
  // 正文页规则
  ruleContent?: string
  // 段评规则
  ruleReview?: string
}

export const ToBookSource = (bookSourceDb: BookSourceDb) => {
  const ruleExplore = GSON.toJson<ExploreRule>(bookSourceDb.ruleExplore);
  const ruleSearch = GSON.toJson<SearchRule>(bookSourceDb.ruleSearch);
  const ruleBookInfo = GSON.toJson<BookInfoRule>(bookSourceDb.ruleBookInfo);
  const ruleToc = GSON.toJson<TocRule>(bookSourceDb.ruleToc);
  const ruleContent = GSON.toJson<ContentRule>(bookSourceDb.ruleContent);
  const ruleReview = GSON.toJson<ReviewRule>(bookSourceDb.ruleReview);
  const bookSource: BookSource = {
    bookSourceUrl: bookSourceDb.bookSourceUrl,
    bookSourceName: bookSourceDb.bookSourceName,
    bookSourceGroup: bookSourceDb.bookSourceGroup,
    bookSourceType: bookSourceDb.bookSourceType,
    bookSourceGrade: bookSourceDb.bookSourceGrade,
    bookSourceScore: bookSourceDb.bookSourceScore,
    bookUrlPattern: bookSourceDb.bookUrlPattern,
    customOrder: bookSourceDb.customOrder,
    enabled: bookSourceDb.enabled,
    enabledExplore: bookSourceDb.enabledExplore,
    jsLib: bookSourceDb.jsLib,
    enabledCookieJar: bookSourceDb.enabledCookieJar,
    concurrentRate: bookSourceDb.concurrentRate,
    header: bookSourceDb.header,
    loginUrl: bookSourceDb.loginUrl,
    loginUi: bookSourceDb.loginUi,
    loginCheckJs: bookSourceDb.loginCheckJs,
    coverDecodeJs: bookSourceDb.coverDecodeJs,
    bookSourceComment: bookSourceDb.bookSourceComment,
    variableComment: bookSourceDb.variableComment,
    lastUpdateTime: bookSourceDb.lastUpdateTime,
    respondTime: bookSourceDb.respondTime,
    weight: bookSourceDb.weight,
    exploreUrl: bookSourceDb.exploreUrl,
    exploreScreen: bookSourceDb.exploreScreen,
    searchUrl: bookSourceDb.searchUrl,
    ruleExplore,
    ruleSearch,
    ruleBookInfo,
    ruleToc,
    ruleContent,
    ruleReview
  }
  return bookSource
}

export const ToBookSourceDb = (bookSource: BookSource) => {
  const ruleExplore = GSON.toString(bookSource.ruleExplore);
  const ruleSearch = GSON.toString(bookSource.ruleSearch);
  const ruleBookInfo = GSON.toString(bookSource.ruleBookInfo);
  const ruleToc = GSON.toString(bookSource.ruleToc);
  const ruleContent = GSON.toString(bookSource.ruleContent);
  const ruleReview = GSON.toString(bookSource.ruleReview);
  const bookSourceDb: BookSourceDb = {
    bookSourceUrl: bookSource.bookSourceUrl,
    bookSourceName: bookSource.bookSourceName,
    bookSourceGroup: bookSource.bookSourceGroup,
    bookSourceType: bookSource.bookSourceType,
    bookSourceGrade: bookSource.bookSourceGrade,
    bookSourceScore: bookSource.bookSourceScore,
    bookUrlPattern: bookSource.bookUrlPattern,
    customOrder: bookSource.customOrder,
    enabled: bookSource.enabled,
    enabledExplore: bookSource.enabledExplore,
    jsLib: bookSource.jsLib,
    enabledCookieJar: bookSource.enabledCookieJar,
    concurrentRate: bookSource.concurrentRate,
    header: bookSource.header,
    loginUrl: bookSource.loginUrl,
    loginUi: bookSource.loginUi,
    loginCheckJs: bookSource.loginCheckJs,
    coverDecodeJs: bookSource.coverDecodeJs,
    bookSourceComment: bookSource.bookSourceComment,
    variableComment: bookSource.variableComment,
    lastUpdateTime: bookSource.lastUpdateTime,
    respondTime: bookSource.respondTime,
    weight: bookSource.weight,
    exploreUrl: bookSource.exploreUrl,
    exploreScreen: bookSource.exploreScreen,
    searchUrl: bookSource.searchUrl,
    ruleExplore,
    ruleSearch,
    ruleBookInfo,
    ruleToc,
    ruleContent,
    ruleReview
  }
  return bookSourceDb
}