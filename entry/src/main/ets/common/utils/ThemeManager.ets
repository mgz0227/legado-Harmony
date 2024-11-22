import { ThemeColor, ThemeStorageKey } from "../constants/Theme";
import { ThemeColorItem, ThemeItem } from "../model/Theme";
import { image } from "@kit.ImageKit";
import { resourceManager } from "@kit.LocalizationKit";
import { BusinessError } from "@kit.BasicServicesKit";

export class ThemeManager {
  init() {
    AppStorage.setOrCreate<ThemeItem>(ThemeStorageKey.THEME, {text: '主题1', color: ThemeColor.ORANGE})
  }

  setTheme(newTheme: ThemeItem) {
    AppStorage.set<ThemeItem>(ThemeStorageKey.THEME, newTheme)
  }

  isSetTheme(): boolean {
    if (AppStorage.get<ThemeItem>(ThemeStorageKey.THEME)) {
      return true;
    } else {
      return false
    }
  }
}

// 单例模式
export const themeManager = new ThemeManager()