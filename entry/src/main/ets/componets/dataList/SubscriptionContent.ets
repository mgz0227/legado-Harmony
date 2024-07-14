/**
 * @author 2008
 * @datetime 2024/7/14 23:19
 * @className: SubscriptionContent
 * 订阅源Date
 */
export interface Subscription{
  subscriptionName?:string; //分组名称
  subscriptionId?:string; //分组Id
  enabled: boolean //是否启用
  SubscriptionWebsite?:SubscriptionWebsite //常规网站
  SubscriptionContent?:SubscriptionContent //订阅源
  SubscriptionList?:SubscriptionList //列表
  SubscriptionWebView?:SubscriptionWebView //WebView
}

export interface SubscriptionWebsite{
  name?:string; //名称
  icon?:string| Resource; // 图标
  type?:string; //类型SUBSCRIPTION_TYPE
  subType?:string //订阅源分组SUBSCRIPTION_GROUP_TYPE
  isIconLink?:string //图标是否使用链接
  iconLinkContent?:string //图标链接
  enabled: boolean //是否启用
}


//订阅源
export interface SubscriptionContent{
  name?:string; //名称
  icon?:string| Resource; // 图标
  subType?:string //订阅源分组SUBSCRIPTION_GROUP_TYPE
  isIconLink?:string //图标是否使用链接
  iconLinkContent?:string //图标链接
  sourceAnnotate?:string //源注解
  classificationUrl?:string // 分类URL
  loginUrl?: string; //登录URL
  loginUi?: string; //登录UI
  loginCheckJs?: string; // 登录检查JS
  bookUrlPattern?: string; //封面解密
  header?: string; //请求头
  variableComment?: string; //变量说明
  concurrentRate?: string; //并发率
  jsLib?: string; // jsLib
  enabled?: boolean //是否启用
  enabledCookieJar?: boolean; //是否启用CookieJar
  enabledAutoComplete?:boolean //自动补全
  variableSource?:string //变量源
}

//列表
export interface SubscriptionList{
  listRule?:string //列表规则
  listRuleNextPage?:string //列表下一页规则
  titleRule?:string //标题规则
  timeRule?:string //时间规则
  describeRule?:string //描述规则
  imgRule?:string //图片URL规则
  linkRule?:string //链接规则
}

//WEB VIEW
export interface SubscriptionWebView{
  enableJavaScript?:boolean //是否启用javaScript
  lodBaseUrl?:boolean //加载 BaseUrl
  contentRule?:string //内容规则
  style?:string //样式
  injectUs?:string //注入Us
  whiteList?:string //白名单
  blackList?:string //黑名单
  urlIntercept?:string //url跳转拦截
}



//订阅源分组类别
export const SUBSCRIPTION_GROUP_TYPE: Record<number, string> ={
  0: '收藏夹',
  1: '小说',
  2: '漫画',
  3: '影视',
  4: '咨询'
}

//订阅源分组类别
export const SUBSCRIPTION_TYPE: Record<number, string> ={
  0: '常规网站',
  1: '订阅源'
}


