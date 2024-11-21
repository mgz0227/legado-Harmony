/**
 * @author 2008
 * @datetime 2024/7/20 15:51
 * @className: rssSourcesHistory
 */
import { SUBSCRIPTION_GROUP_TYPE } from './rssSources'

@Observed
export class rssSourcesHistory{
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
  //最后更新时间
  lastUpdateTime:number = 0
  //是否新增或则更新点击过
  showRecentIcon:boolean = true
  //自定义文字
  customizeTitle:string = ''
}