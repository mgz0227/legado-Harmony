import CommonConstants from '../common/constants/CommonConstants'

export const initFindData = () => {
  AppStorage.setOrCreate(CommonConstants.HAS_EXPLORE_URL, true)
}