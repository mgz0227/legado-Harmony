import { initBookListData } from './bookListData'
import { shelfInitAppData } from './shelfListData'

let APP_INDEX_SCROLLABLE = 'APP_INDEX_SCROLLABLE'

const APP_INDEX_SCROLLABLE_DATA = false

export const initAppData = ()=>{
  AppStorage.setOrCreate(APP_INDEX_SCROLLABLE,APP_INDEX_SCROLLABLE_DATA)
  shelfInitAppData()
  initBookListData()
}

export const updateAppData = (INDEX_SCROLLABLE:boolean)=>{
  AppStorage.set(APP_INDEX_SCROLLABLE,INDEX_SCROLLABLE)
}



