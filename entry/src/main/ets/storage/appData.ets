import CommonConstants from '../common/constants/CommonConstants'
import { showMessage } from '../componets/common/promptShow'
import bookDataPreferences from '../common/utils/DataPreferencesUtils'
import { initBookListData } from './bookListData'
import { groupInitAppData } from './groupData'
import { shelfInitAppData } from './shelfListData'
import { initBookPreferences } from '../preferences/bookDataPreferences'
import { initFindData } from './findData'
import programDataPreferences from '../preferences/programDataPreferences'


let APP_INDEX_SCROLLABLE = 'APP_INDEX_SCROLLABLE'

const APP_INDEX_SCROLLABLE_DATA = false

export const initAppData = ()=>{
  AppStorage.setOrCreate(APP_INDEX_SCROLLABLE,APP_INDEX_SCROLLABLE_DATA)
  shelfInitAppData()
  if (!bookDataPreferences.shared.get(CommonConstants.PREFERENCES_BOOK_INIT_KEY) as boolean) {
    initBookPreferences()
  }
  if (!bookDataPreferences.shared.get(CommonConstants.RSS_SOURCES_GROUP_INIT) as boolean) {
    programDataPreferences.initProgramDataPreferences()
    programDataPreferences.initRssSourcesListData()
  }
  initBookListData()
  groupInitAppData()
  initFindData()
}

export const updateAppData = (INDEX_SCROLLABLE:boolean)=>{
  AppStorage.set(APP_INDEX_SCROLLABLE,INDEX_SCROLLABLE)
}



