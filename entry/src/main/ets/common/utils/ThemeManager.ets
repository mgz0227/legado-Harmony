import { ThemeColor, ThemeStorageKey } from "../constants/Theme";
import { ThemeColorItem } from "../model/Theme";

export class ThemeManager {
  color: ThemeColorItem = ThemeColor.GREEN // 主题色
  bgiList: ResourceStr[] = [
    $r('app.media.my_theme_config_bg0'),
    $r('app.media.my_theme_config_bg1'),
    $r('app.media.my_theme_config_bg2'),
    $r('app.media.my_theme_config_bg3'),
    $r('app.media.my_theme_config_bg4'),
    $r('app.media.my_theme_config_bg5'),
    $r('app.media.my_theme_config_bg6'),
    $r('app.media.my_theme_config_bg7'),
  ] // 页面顶部背景图片数组
  activeBgiIndex: number = 0 // 当前设置的页面顶部背景图片在数组的索引
  wbgi: ResourceStr = '' // 欢迎背景图片
  isSetWgi: boolean = false // 是否设置了欢迎页背景

  appIcon: ResourceStr = '' // app的启动图标

  init() {
    AppStorage.setOrCreate<ThemeColorItem>(ThemeStorageKey.COLOR, this.color)
    // 删除自定义主题逻辑中至少要求保留一个主题，所以这里无须考虑数组越界
    AppStorage.setOrCreate<ResourceStr>(ThemeStorageKey.BGI, this.bgiList[this.activeBgiIndex])
    if (this.isSetWgi) {
      AppStorage.setOrCreate<ResourceStr>(ThemeStorageKey.WBGI, this.wbgi)
    } else {
      AppStorage.setOrCreate<ResourceStr>(ThemeStorageKey.WBGI, '')
    }
  }

  setColor(newColor: ThemeColorItem) {
    AppStorage.set<ThemeColorItem>(ThemeStorageKey.COLOR, newColor)
  }

  setBgi(newBgi: ResourceStr) {
    AppStorage.set<ResourceStr>(ThemeStorageKey.BGI, newBgi)
  }

  setWbgi(newWbgi: ResourceStr) {
    AppStorage.set<ResourceStr>(ThemeStorageKey.WBGI, newWbgi)
  }
}

// 单例模式
export const themeManager = new ThemeManager()