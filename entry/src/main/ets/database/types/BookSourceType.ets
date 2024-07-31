export interface BookSourceSearchParams {
  // 搜索关键词
  searchKey?: string,
  // 源类型 0 小说；1 漫画；2 有声书；
  type?: number,
  // 是否启用
  enabled?: boolean,
  // 排序 0 按评分排序 1 按时间排序
  order?: number,
  // 等级
  bookSourceGrade?: number,
  // TODO 校验，还未实现
  verify?: number,
  // 是否存在登录
  hasLoginUrl?: boolean,
  // 是否存在发现
  hasExploreUrl?: boolean
  // 是否显示的发现
  showExplore?: boolean
}

export interface ExploreQuery {
  url: string,
  pageSize: number,
  bookList?: string
  name?: string
  author?: string
  intro?: string
  kind?: string
  lastChapter?: string
  bookUrl?: string
  coverUrl?: string
  wordCount?: string
}

export interface ExploreItemStyle {
  layout_flexGrow?: number;
  layout_flexBasisPercent?: number;
}

export interface ExploreItem {
  title: string,
  url: string,
  style?: ExploreItemStyle
}