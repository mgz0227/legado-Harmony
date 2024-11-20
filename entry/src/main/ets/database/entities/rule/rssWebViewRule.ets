/**
 * @author 2008
 * @datetime 2024/7/15 14:59
 * @className: rssWebViewRule
 */
export class rssWebViewRule{
  //启用JavaScript
  enableJs:boolean = true
  //加载 BaseUrl
  loadWithBaseUrl:boolean = true
  //内容规则
  ruleContent?:string
  //样式规则
  style?:string
  //注入规则
  injectJs?:string
  //白名单
  contentWhitelist?:string
  //黑名单
  contentBlacklist?:string
  //链接拦截
  shouldOverrideUrlLoading?:string
}