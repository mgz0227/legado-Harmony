/**
 * @author 2008
 * @datetime 2024/7/17 19:30
 * @className: programDataPreferences
 * 程序基础数据定义
 */
import CommonConstants from '../common/constants/CommonConstants'
import bookDataPreferences from '../common/utils/DataPreferencesUtils'

export class programDataPreferences {
  readonly rssSourcesGroup: string[] = ['小说', '漫画', '影视', '咨询', '收藏夹']
  initProgramDataPreferences = () => {
    //内容数据持久化
    //订阅源分组数据
    bookDataPreferences.shared.set(CommonConstants.RSS_SOURCES_GROUP_LIST_DATA_KEY, programPreferences.rssSourcesGroup)
  }
  //分组初始化标识
  initRssSourcesListData = () =>{
    bookDataPreferences.shared.set(CommonConstants.RSS_SOURCES_GROUP_INIT, true)
  }
  updateRssSourcesListData = (data:string[] ) =>{
    bookDataPreferences.shared.set(CommonConstants.RSS_SOURCES_GROUP_LIST_DATA_KEY,data)
  }


  updateRssSourcesData = (data:string ) =>{
    let group = bookDataPreferences.shared.get(CommonConstants.RSS_SOURCES_GROUP_LIST_DATA_KEY) as string[]
    group.push(data)
    bookDataPreferences.shared.set(CommonConstants.RSS_SOURCES_GROUP_LIST_DATA_KEY, group)
  }

  getRssSourcesListData = () => {
    return bookDataPreferences.shared.get(CommonConstants.RSS_SOURCES_GROUP_LIST_DATA_KEY) as string[]
  }
}

const programPreferences = new programDataPreferences()
export default programPreferences