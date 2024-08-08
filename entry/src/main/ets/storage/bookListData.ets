import CommonConstants from '../common/constants/CommonConstants'

/**
 * 初始化页面公用变量
 */

export const initBookListData = ()=>{
  AppStorage.setOrCreate(CommonConstants.BOOK_IS_BOOK_REFRESHING, 0)
  AppStorage.setOrCreate(CommonConstants.BOOK_IS_BOOK_GROUPS_REFRESHING, 0)
  AppStorage.setOrCreate(CommonConstants.BOOK_IS_BOOK_WORKS_BOOK_LIST, 0)
  AppStorage.setOrCreate(CommonConstants.BOOK_IS_BOOK_HISTORY_REFRESHING,0)
  AppStorage.setOrCreate(CommonConstants.RSS_SOURCES_REFRESHING, 0)
}
