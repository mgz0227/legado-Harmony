import CommonConstants from '../common/constants/CommonConstants';
import dataPreferences from '@ohos.data.preferences';

// 获取context
let context = getContext(this);
export default class bookDataPreferences {

  static shared = new bookDataPreferences();
  preferences?: dataPreferences.Preferences;
  preferencesName: string = CommonConstants.PREFERENCES_BOOK_DATA_KEY;

  // 初始化preferences实例
  initPreferences() {
    this.preferences = dataPreferences.getPreferencesSync(context, { name: this.preferencesName });
  }

  // 设置数据
  set(key: string, value: dataPreferences.ValueType) {
    if (!this.preferences) {
      this.initPreferences();
    }
    console.log('setinitPreferences', key, value)
    this.preferences?.putSync(key, value);
    this.preferences?.flush();
  }

  // 获取数据
  get(key: string): dataPreferences.ValueType | null | undefined {
    if (!this.preferences) {
      this.initPreferences();
    }
    let value = this.preferences?.getSync(key, null);;
    return value;
  }

  // 删除数据
  delete(key: string) {
    if (!this.preferences) {
      this.initPreferences();
    }
    if (this.preferences?.hasSync(key)) {
      this.preferences.deleteSync(key);
      this.preferences.flush();
    }
  }
}

