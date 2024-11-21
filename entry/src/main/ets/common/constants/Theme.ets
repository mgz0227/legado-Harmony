import { ThemeColorItem } from "../model/Theme";

// 配置主题颜色
export class ThemeColor {
  static readonly ORANGE: ThemeColorItem = {mainColor: '#ff6600', secondColor: '#ffece0'}
  static readonly RED: ThemeColorItem = {mainColor: '#ef4444', secondColor: '#fde8e8'}
  static readonly YELLOW: ThemeColorItem = {mainColor: '#ff9500', secondColor: '#fff2e0'}
  static readonly BLUE: ThemeColorItem = {mainColor: '#188bff', secondColor: '#e3f1ff'}
  static readonly GREEN: ThemeColorItem = {mainColor: '#24b277', secondColor: '#e4f5ee'}
}

// AppStorage key 标识
export class ThemeStorageKey {
  static readonly COLOR: string = 'color' // 主题颜色key
  static readonly BGI: string = 'bgi' // 页面顶部背景图key
  static readonly WBGI: string = 'wbgi' // 欢迎页背景图key
}