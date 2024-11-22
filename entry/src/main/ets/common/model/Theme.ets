export interface ThemeColorItem {
  mainColor: string // 主色 前景色
  secondColor: string // 次色 背景色
}

export interface ThemeItem {
  color: ThemeColorItem
  text: string
  appIcon?: PixelMap
  bgi?: PixelMap // 页面顶部背景图
  wbgi?: PixelMap // 欢迎页背景图
}
