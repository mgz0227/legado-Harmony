import { showMessage } from '../../componets/common/promptShow';
import rssSourceGroupDao from '../../database/dao/rssSourceGroupDao';
import rssSourcesHistoryDao from '../../database/dao/RssSourcesHistoryDao';
import { rssSources } from '../../database/entities/rssSources';
import { rssSourcesHistory } from '../../database/entities/rssSourcesHistory';

export class rssSourcesUtils{
 async pushRssSourcesHistory(item:rssSources|rssSourcesHistory){
  let rssSourcesHistory:rssSourcesHistory = {
   sourceType: item.sourceType,
   sourceName: item.sourceName,
   sourceUrl: item.sourceUrl,
   sourceIcon: item.sourceIcon||'',
   sourceIconIsUrl: item.sourceIconIsUrl,
   sourceGroup: item.sourceGroup,
   lastUpdateTime: Date.now(),
   showRecentIcon: item.showRecentIcon,
   customizeTitle: item.customizeTitle||''
  }
  rssSourcesHistoryDao.insert(rssSourcesHistory)
  }

 async addGroupType(newGroupType:string){
  let isInsert = false
  let group = await this.getRssSourcesGroup();
  group.map((data:string)=>{
   if(data === newGroupType){
    isInsert = true
   }
  })
  if (isInsert) {
   showMessage('分组名称重复')
   isInsert = false
   return false
  } else {
   this.insertRssSourceGroup(newGroupType)
   showMessage(`添加分组${newGroupType}成功!`)
   return true
  }
 }

  //获取订阅分组
 async getRssSourcesGroup(){
  let rssSourcesGroup = await rssSourceGroupDao.search();
  //根据排序顺序存储到string[]
  let rssSourcesGroupName:string[] = [];
  for(let i=0;i<rssSourcesGroup.length;i++){
   rssSourcesGroupName.push(rssSourcesGroup[i].rssGroupName)
  }
  return rssSourcesGroupName
  }

  //新增分组
 async insertRssSourceGroup(rssGroupName:string){
   await rssSourceGroupDao.insert({
    rssGroupName: rssGroupName,
    isTop: false,
    isDelete: true
   })
 }
}
let rssSourcesUtil = new rssSourcesUtils();
export default rssSourcesUtil as rssSourcesUtils;