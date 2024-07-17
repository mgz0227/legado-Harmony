/**
 * @author 2008
 * @datetime 2024/5/25 11:53
 * @className: groupData
 * 分组类型
 */
import CommonConstants from '../common/constants/CommonConstants'

import { folderList } from '../componets/dataList/folderList'
export const groupData:folderList[] = [
  new folderList(1,'玄幻',12,$r('app.media.folder_test'),'玄幻','宿命之环等3本有更新',true),
  new folderList(2,'都市',13,$r('app.media.folder_test'),'都市'),
  new folderList(3,'仙侠',12,$r('app.media.folder_test'),'仙侠'),
  new folderList(4,'武侠',12,$r('app.media.folder_test'),'武侠'),
  new folderList(5,'奇幻',12,$r('app.media.folder_test'),'奇幻'),
  new folderList(6,'科幻',12,$r('app.media.folder_test'),'科幻'),
  new folderList(7,'历史',12,$r('app.media.folder_test'),'历史'),
  new folderList(8,'游戏',12,$r('app.media.folder_test'),'游戏'),
  new folderList(9,'悬疑',12,$r('app.media.folder_test'),'悬疑')
]

export const groupInitAppData = ()=>{
  AppStorage.setOrCreate(CommonConstants.GROUP_LIST_DATA,groupData)
}

export const updateDateGroup = (group:folderList)=>{
  let groupData = getGroupData()
  //将group替换groupData对应的id的数据
  for (let i = 0; i < groupData.length; i++) {
    if (groupData[i].id === group.id) {
      groupData[i] = group
      break
    }
  }
  AppStorage.set(CommonConstants.GROUP_LIST_DATA,showGroupSort(groupData))
}

const getGroupData = ()=>{
  let groupList = AppStorage.get<folderList>(CommonConstants.GROUP_LIST_DATA) || []
  let groupListData = groupList as folderList[]
  console.log(JSON.stringify(groupListData))
  return groupListData
}

export const delGroupById = (id:number)=>{
  let groupList = getGroupData()
  groupList = groupList.filter(group => group.id !== id);
  AppStorage.set(CommonConstants.GROUP_LIST_DATA,showGroupSort(groupList))
}



const showGroupSort = (group:folderList[]) =>{
  return group.sort((a, b) => {
    if (a.isTop && !b.isTop) {
      return -1
    } else if (!a.isTop && b.isTop) {
      return 1
    } else {
      return b.topUpdateTime.getTime() - a.topUpdateTime.getTime()
      // return 0
    }
  })
}