export interface BookSourceSearchParams {
  // 搜索关键词
  searchKey?: string,
  // 源类型 0 小说；1 漫画；2 有声书；
  type?: number,
  // 是否启用
  enabled?: boolean,
  // TODO 排序，还未实现
  order?: number,
  // 等级
  bookSourceGrade?: number,
  // TODO 校验，还未实现
  verify?: number,
  // 是否存在登录
  hasLoginUrl?: boolean,
  // 是否存在发现
  hasExploreUrl?: boolean
}