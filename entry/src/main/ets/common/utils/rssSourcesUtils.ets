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
}
let rssSourcesUtil = new rssSourcesUtils();
export default rssSourcesUtil as rssSourcesUtils;