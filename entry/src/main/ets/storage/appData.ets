import CommonConstants from '../common/constants/CommonConstants'
import { showMessage } from '../componets/common/promptShow'
import bookDataPreferences from '../common/utils/DataPreferencesUtils'
import { initBookListData } from './bookListData'
import { groupInitAppData } from './groupData'
import { shelfInitAppData } from './shelfListData'
import { initBookPreferences } from '../preferences/bookDataPreferences'

let APP_INDEX_SCROLLABLE = 'APP_INDEX_SCROLLABLE'

const APP_INDEX_SCROLLABLE_DATA = false

export const initAppData = ()=>{
  AppStorage.setOrCreate(APP_INDEX_SCROLLABLE,APP_INDEX_SCROLLABLE_DATA)
  shelfInitAppData()
  if (!bookDataPreferences.shared.get(CommonConstants.PREFERENCES_BOOK_INIT_KEY) as boolean) {
    initBookPreferences()
    showMessage(`初始化成功${CommonConstants.PREFERENCES_BOOK_DATA_KEY} ${bookDataPreferences.shared.get(CommonConstants.PREFERENCES_BOOK_INIT_KEY) as boolean}`)
  } else {
    showMessage(`已经初始化过${CommonConstants.PREFERENCES_BOOK_DATA_KEY} ${bookDataPreferences.shared.get(CommonConstants.PREFERENCES_BOOK_INIT_KEY) as boolean}`)
  }
  initBookListData()
  groupInitAppData()
}

export const updateAppData = (INDEX_SCROLLABLE:boolean)=>{
  AppStorage.set(APP_INDEX_SCROLLABLE,INDEX_SCROLLABLE)
}



