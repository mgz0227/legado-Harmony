/**
 * @author 2008
 * @datetime 2024/7/20 16:34
 * @className: rssSourcesHistoryDao
 * 订阅源
 */
import DbUtil from '../../common/utils/DbUtil';
import { showMessage } from '../../componets/common/promptShow';
import AppDatabaseUtil from '../AppDatabaseUtil';
import { rssSourcesHistory } from '../entities/rssSourcesHistory';
import { ColumnInfo } from '../types/ColumnInfo';

class RssSourcesHistoryDao {
  TABLE_NAME: string = 'rss_sources_history'

  async initRssSourcesHistoryTable() {
    try {
      const createSql = AppDatabaseUtil.getCreateSql(this.TABLE_NAME);
      if (!createSql) {
        return
      }
      await DbUtil.createTable(createSql)
      AppDatabaseUtil.existsTable(this.TABLE_NAME)
      return
    } catch (err) {
      console.info('TagInfo', JSON.stringify(err))
    }
  }

  async search(sourceUrl?:string) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      let sql = `SELECT * FROM ${this.TABLE_NAME}`;
      // 动态添加 WHERE 子句
      let whereClause: string[] = [];
      if (sourceUrl) {
        whereClause.push(`(
        sourceUrl LIKE '%${sourceUrl}%'
      )`);

      }
      // 如果有 where 子句，添加 WHERE 关键字
      if (whereClause.length > 0) {
        sql += ` WHERE ${whereClause.join(' AND ')}`;
      }
      sql += `
  ORDER BY
    lastUpdateTime DESC
`;
      const rssSourcesDbList = await DbUtil.querySqlForList<rssSourcesHistory>(sql, column);
      console.log("TagInfo", '书源数量：' + rssSourcesDbList.length)
      return rssSourcesDbList
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }

  async batchInsert(history: rssSourcesHistory[]) {
    try {
      for (let index = 0; index < history.length; index++) {
        const rssHistory = history[index];
        await this.insert(rssHistory)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async insert(rssHistory: rssSourcesHistory) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('sourceUrl', rssHistory.sourceUrl)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count > 0) {
        this.update(rssHistory)
        return true
      }
      rssHistory.lastUpdateTime = Date.now()
      await DbUtil.insert(this.TABLE_NAME, rssHistory, column)
      console.log('TagInfo', '创建成功')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async update(rssHistory: rssSourcesHistory) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('sourceUrl', rssHistory.sourceUrl)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count === 0 && rssHistory instanceof rssSourcesHistory) {
        this.insert(rssHistory)
        return true
      }
      rssHistory.lastUpdateTime = Date.now()
      rssHistory.showRecentIcon = true
      await DbUtil.update(predicates, rssHistory, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }

  }

  //批量删除订阅源历史记录
  async deleteRssSourcesHistoryList(rssHistory: rssSourcesHistory[]) {
    try {
      for (let index = 0; index < rssHistory.length; index++) {
        await this.deleteRssSourcesHistory(rssHistory[index].sourceUrl)
      }
      showMessage('清除最近使用')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  //删除订阅源历史记录
  async deleteRssSourcesHistory(rssHistoryUrl: string) {
    try {
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('sourceUrl', rssHistoryUrl)
      await DbUtil.delete(predicates)
      return true
    }  catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }
}


const rssSourcesHistoryDao = new RssSourcesHistoryDao()
export default rssSourcesHistoryDao as RssSourcesHistoryDao