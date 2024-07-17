/**
 * @author 2008
 * @datetime 2024/7/15 1:34
 * @className: SubscriptionDao
 * 订阅源
 */
import DbUtil from '../../common/utils/DbUtil';
import { showMessage } from '../../componets/common/promptShow';
import AppDatabaseUtil from '../AppDatabaseUtil';
import { rssSourceDb, rssSources, ToRssSources, ToRssSourcesDb } from '../entities/rssSources';
import { rssSourcesPart } from '../entities/rssSourcesPart';
import { ColumnInfo, ColumnType } from '../types/ColumnInfo';
import { rssSourcesTypeParams } from '../types/rssSourcesType';

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
      predicates.equalTo('sourceUrl', rssSource.sourceUrl)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count !== 0) {
        this.update(rssSource)
        return true
      }
      const bookSourceDb = ToRssSourcesDb(rssSource)
      bookSourceDb.lastUpdateTime = Date.now()
      await DbUtil.insert(this.TABLE_NAME, bookSourceDb, column)
      console.log('TagInfo', '创建成功')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async update(rssSource: rssSources | rssSourcesPart) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('sourceUrl', rssSource.sourceUrl)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count === 0 && rssSource instanceof rssSources) {
        this.insert(rssSource)
        return true
      }
      if (rssSource instanceof rssSources) {
        const rssSourceDb = ToRssSourcesDb(rssSource)
        rssSourceDb.lastUpdateTime = Date.now()
        await DbUtil.update(predicates, rssSourceDb, column)
        return true
      }
      rssSource.lastUpdateTime = Date.now()
      const columnPart: ColumnInfo[] = this.getFlowColumn().slice(0, -2)
      await DbUtil.update(predicates, rssSource, columnPart)
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

  getFlowColumn() {
    const column: ColumnInfo[] = AppDatabaseUtil.getAssignColumn(this.TABLE_NAME,
      ['sourceName', 'sourceUrl', 'sourceGroup', 'sourceGroup', 'enabled', 'variableComment',
        'sortUrl', 'singleUrl', 'lastUpdateTime','customOrder','variable','sourceType']);
    return column;
  }
}






const subscriptionDao = new SubscriptionDao()
export default subscriptionDao as SubscriptionDao