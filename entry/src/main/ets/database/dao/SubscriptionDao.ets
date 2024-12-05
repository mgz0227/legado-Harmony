/**
 * @author 2008
 * @datetime 2024/7/15 1:34
 * @className: SubscriptionDao
 * 订阅源
 */
import DbUtil from '../../common/utils/DbUtil';
import rssSourcesUtils from '../../common/utils/rssSourcesUtils';
import AppDatabaseUtil from '../AppDatabaseUtil';
import { rssSourceDb, rssSources, ToRssSources, ToRssSourcesDb } from '../entities/rssSources';
import { ColumnInfo } from '../types/ColumnInfo';
import { rssSourcesTypeParams } from '../types/rssSourcesType';
import rssSourcesHistoryDao from './RssSourcesHistoryDao';

interface delParams {
  url?: string,
  id:number
}

class SubscriptionDao {
  TABLE_NAME: string = 'rssSources'

  // 创建book_subscription数据表
  async initSubscriptionTable() {
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

  async search(searchParams?: rssSourcesTypeParams) {
    const searchKey = searchParams?.searchKey ?? '';

    const enabled = searchParams?.enabled;

    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      let sql = `SELECT * FROM ${this.TABLE_NAME}`;
      // 动态添加 WHERE 子句
      let whereClause: string[] = [];

      if (enabled !== undefined) {
        whereClause.push(`enabled = ${enabled ? 1 : 0}`);
      }

      if (searchKey) { // 确保 searchKey 不为空或未定义
        whereClause.push(`(
        sourceName LIKE '%${searchKey}%'
        OR sourceGroup LIKE '%${searchKey}%'
      )`);
      }

      // 如果有 where 子句，添加 WHERE 关键字
      if (whereClause.length > 0) {
        sql += ` WHERE ${whereClause.join(' AND ')}`;
      }

      sql += `
  ORDER BY
    lastUpdateTime DESC,
    customOrder ASC
`;
      const rssSourcesDbList = await DbUtil.querySqlForList<rssSourceDb>(sql, column);
      const rssSourcesList = rssSourcesDbList.map((item): rssSources => ToRssSources(item));
      console.log("TagInfo", '书源数量：' + rssSourcesList.length)
      return rssSourcesList
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }

  async batchInsert(rssSources: rssSources[]) {
    try {
      for (let index = 0; index < rssSources.length; index++) {
        const rssSource = rssSources[index];
        await this.insert(rssSource)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async insert(rssSource: rssSources) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      if (rssSource.id !== 0 && rssSource.id !== undefined) {
        predicates.equalTo('id', rssSource.id)
      } else {
        predicates.equalTo('sourceUrl', rssSource.sourceUrl)
      }
      const count = await DbUtil.queryForCount(predicates, column)
      if (count !== 0) {
        this.update(rssSource)
        return true
      }
      const rssSourceDb = ToRssSourcesDb(rssSource)
      rssSourceDb.lastUpdateTime = Date.now()
      await DbUtil.insert(this.TABLE_NAME, rssSourceDb, column)
      console.log('TagInfo', '创建成功')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async update(rssSource: rssSources) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      if (rssSource.id !== 0 && rssSource.id !== undefined) {
        predicates.equalTo('id', rssSource.id)
      } else {
        predicates.equalTo('sourceUrl', rssSource.sourceUrl)
      }
      const count = await DbUtil.queryForCount(predicates, column)
      if (count === 0 && rssSource instanceof rssSources) {
        this.insert(rssSource)
        return true
      }
      const rssSourceDb = ToRssSourcesDb(rssSource)
      rssSourceDb.lastUpdateTime = Date.now()
      rssSourceDb.showRecentIcon = true
      await DbUtil.update(predicates, rssSourceDb, column)
      rssSourcesHistoryDao.search(rssSource.sourceUrl).then(async (value) => {
        if (value.length > 0) {
          await rssSourcesUtils.pushRssSourcesHistory(rssSource)
        }
      })
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }

  }

  async updateRecentIcon(rssSource: rssSources) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      if (rssSource.id !== 0 && rssSource.id !== undefined) {
        predicates.equalTo('id', rssSource.id)
      } else {
        predicates.equalTo('sourceUrl', rssSource.sourceUrl)
      }
      const rssSourceDb = ToRssSourcesDb(rssSource)
      rssSourceDb.showRecentIcon = false
      await DbUtil.update(predicates, rssSourceDb, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }

  }

  //批量删除订阅源
  async deleteRssSourcesList(rssSources: rssSources[]) {
    try {
      for (let index = 0; index < rssSources.length; index++) {
        await this.deleteRssSources(rssSources[index])
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  //删除书源
  async deleteRssSources(rssSource: rssSources) {
    try {
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      if (rssSource.id !== 0 && rssSource.id !== undefined) {
        predicates.equalTo('id', rssSource.id)
      } else {
        predicates.equalTo('sourceUrl', rssSource.sourceUrl)
      }
      rssSourcesHistoryDao.deleteRssSourcesHistory(rssSource.sourceUrl)
      await DbUtil.delete(predicates)
      return true
    }  catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  //置顶
  async isTopRssSources(rssSources: rssSources){
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      if (rssSources.id !== 0 && rssSources.id !== undefined) {
        predicates.equalTo('id', rssSources.id)
      } else {
        predicates.equalTo('sourceUrl', rssSources.sourceUrl)
      }
      const rssSourceDb = ToRssSourcesDb(rssSources)
      rssSourceDb.lastUpdateTime = Date.now()
      rssSourceDb.customOrder = 0
      await DbUtil.update(predicates, rssSourceDb, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async getRssSources(key: string): Promise<rssSources | null> {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('sourceUrl', key)
      const rssDbList = await DbUtil.queryForList<rssSourceDb>(predicates, column);
      const rss = rssDbList.map((item): rssSources => ToRssSources(item));
      if (rss.length > 0) {
        return rss[0]
      }
      return null
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return null
    }
  }

  //校验是否存在收藏
  async queryByUrl(url: string) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.like('sourceUrl', url)
      const rssDbList = await DbUtil.queryForList<rssSourceDb>(predicates, column);
      const rss = rssDbList.map((item): rssSources => ToRssSources(item));
      if (rss.length > 0) {
        return true
      } else {
        return false
      }
    } catch (e){
      console.log("TagInfo", JSON.stringify(e))
      return false
    }
  }

  //订阅源id删除或者sourceUrl进行删除
  async deleteRssSourcesById(param?:delParams) {
    let id = param?.id
    let sourceUrl = param?.url
    try {
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      if (id !== 0) {
        predicates.equalTo('id', id)
      } else {
        predicates.equalTo('sourceUrl', sourceUrl)
      }
      await DbUtil.delete(predicates)
    } catch (e) {
      console.log("TagInfo", JSON.stringify(e))
    }
  }

  getFlowColumn() {
    const column: ColumnInfo[] = AppDatabaseUtil.getAssignColumn(this.TABLE_NAME,
      ['sourceName', 'sourceUrl', 'sourceGroup', 'sourceGroup', 'enabled', 'variableComment',
        'sortUrl', 'singleUrl', 'lastUpdateTime','customOrder','variable','sourceType','showRecentIcon',]);
    return column;
  }
}






const subscriptionDao = new SubscriptionDao()
export default subscriptionDao as SubscriptionDao