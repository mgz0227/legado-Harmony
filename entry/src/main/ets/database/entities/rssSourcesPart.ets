/**
 * @author 2008
 * @datetime 2024/7/14 23:19
 * @className: rssSources
 * 订阅源Part
 */
@Observed
export class rssSourcesPart {
  //名称
  sourceName:string = ''
  //地址url
  sourceUrl:string = ''
  // 分组
  sourceGroup?:string

  //是否启用
  enabled?: boolean = true
  // 自定义变量说明
  variableComment?:string
  // 分类地址
  sortUrl?:string
  // 单URL
  singleUrl?:boolean
  //最后更新时间
  lastUpdateTime:number = 0
  // 排序编号
  customOrder:number = 0
  //设置源变量
  variable?:string
  //订阅源类型0.常规网站 1.订阅源
  sourceType?: number = 1

  showRecentIcon:boolean = true
}


