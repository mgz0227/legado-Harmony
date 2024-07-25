@Observed
export class BookSourcePart {
  // 地址，包括 http/https
  bookSourceUrl: string = ""
  // 名称
  bookSourceName: string = ""
  // 分组
  bookSourceGroup?: string
  bookSourceGrade?: number = 2
  bookSourceScore?: string
  // 手动排序编号
  customOrder: number = 0
  // 是否启用
  enabled: boolean = true
  // 启用发现
  enabledExplore: boolean = true
  // 是否有登录地址
  hasLoginUrl: boolean = false
  // 最后更新时间，用于排序
  lastUpdateTime: number = 0
  // 响应时间，用于排序
  respondTime: number = 180000
  // 智能排序的权重
  weight: number = 0
  // 是否有发现url
  hasExploreUrl: boolean = false
  // 是否置顶
  isTop: boolean = false
  //是否新增或则更新点击过
  showRecentIcon: boolean = true
  showExplore: boolean = true
}