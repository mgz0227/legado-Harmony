import { ColumnInfo, ColumnType } from '../types/ColumnInfo';
import { BookSource, BookSourceDb, ToBookSource, ToBookSourceDb, ToBookSourcePart } from '../entities/BookSource';
import AppDatabaseUtil from '../AppDatabaseUtil'
import { JSON } from '@kit.ArkTS';
import DbUtil from '../../common/utils/DbUtil';
import { BookSourcePart } from '../entities/BookSourcePart';
import { BookSourceSearchParams } from '../types/BookSourceType';

class BookSourceDao {
  TABLE_NAME: string = 'book_sources'

  // 创建book_source数据表
  async initBookSourceTable() {
    try {
      const createSql = AppDatabaseUtil.getCreateSql(this.TABLE_NAME);
      if (!createSql) {
        return
      }
      await DbUtil.createTable(createSql);
      AppDatabaseUtil.existsTable(this.TABLE_NAME)
      return
    } catch (err) {
      console.info('TagInfo', JSON.stringify(err))
    }
  }

  getFlowColumn() {
    const column: ColumnInfo[] = AppDatabaseUtil.getAssignColumn(this.TABLE_NAME,
      ['bookSourceUrl', 'bookSourceName', 'bookSourceGroup', 'bookSourceGrade', 'bookSourceScore', 'customOrder',
        'enabled', 'enabledExplore', 'lastUpdateTime', 'respondTime', 'weight', 'isTop', 'showRecentIcon',
        'showExplore']);
    column.push(...[
      {
        name: 'hasLoginUrl',
        columnName: 'hasLoginUrl',
        type: ColumnType.BOOLEAN
      },
      {
        name: 'hasExploreUrl',
        columnName: 'hasExploreUrl',
        type: ColumnType.BOOLEAN
      }
    ] as ColumnInfo[])
    return column;
  }

  async flowAll(): Promise<BookSourcePart[]> {
    try {
      const sql = `select bookSourceUrl, bookSourceName, bookSourceGroup, bookSourceGrade, bookSourceScore, customOrder, enabled, enabledExplore,
      trim(loginUrl) <> '' hasLoginUrl, lastUpdateTime, respondTime, weight, trim(exploreUrl) <> '' hasExploreUrl, isTop, showRecentIcon, showExplore
      from book_sources order by customOrder asc`
      const column: ColumnInfo[] = this.getFlowColumn()
      return await DbUtil.querySqlForList<BookSourcePart>(sql, column)
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }

  async getEnabledPartByGroup() {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const sql = `SELECT * FROM book_sources WHERE enabled = 1 AND enabledExplore = 1 ORDER BY customOrder ASC`
      const bookSourceDbList = await DbUtil.querySqlForList<BookSourceDb>(sql, column);
      const bookSourceList = bookSourceDbList.map((item): BookSource => ToBookSource(item));
      return bookSourceList
    } catch (e){
      console.log("TagInfo", JSON.stringify(e))
      return []
    }
  }

  async flowSearch(searchParams?: BookSourceSearchParams): Promise<BookSourcePart[]> {
    const searchKey = searchParams?.searchKey ?? '';
    const type = searchParams?.type;
    const enabled = searchParams?.enabled;
    const bookSourceGrade = searchParams?.bookSourceGrade;
    const hasLoginUrl = searchParams?.hasLoginUrl;
    const showExplore = searchParams?.showExplore;
    const order = searchParams?.order;
    try {
      let sql = `
  SELECT
    bookSourceUrl,
    bookSourceName,
    bookSourceGroup,
    bookSourceGrade,
    bookSourceScore,
    customOrder,
    enabled,
    enabledExplore,
    trim(loginUrl) <> '' AS hasLoginUrl,
    lastUpdateTime,
    respondTime,
    weight,
    trim(exploreUrl) <> '' AS hasExploreUrl,
    isTop,
    showRecentIcon,
    showExplore
  FROM
    book_sources
`;

      // 动态添加 WHERE 子句
      let whereClause: string[] = [];
      if (type !== undefined) {
        whereClause.push(`bookSourceType = ${type}`);
      }
      if (enabled !== undefined) {
        whereClause.push(`enabled = ${enabled ? 1 : 0}`);
      }
      if (showExplore !== undefined) {
        whereClause.push(`showExplore = ${showExplore ? 1 : 0}`);
      }
      if (bookSourceGrade !== undefined) {
        whereClause.push(`bookSourceGrade = ${bookSourceGrade}`);
      }
      if (hasLoginUrl !== undefined) {
        whereClause.push(`COALESCE(loginUrl, '') ${hasLoginUrl ? '<>' : '='} ''`);
      }
      if (searchKey) { // 确保 searchKey 不为空或未定义
        whereClause.push(`(
    bookSourceName LIKE '%${searchKey}%'
    OR bookSourceGroup LIKE '%${searchKey}%'
    OR bookSourceUrl LIKE '%${searchKey}%'
    OR bookSourceComment LIKE '%${searchKey}%'
  )`);
      }

      // 如果有 where 子句，添加 WHERE 关键字
      if (whereClause.length > 0) {
        sql += ` WHERE ${whereClause.join(' AND ')}`;
      }

      sql += ` ORDER BY`;
      if (order !== undefined) {
        sql += ` ${order === 0 ? 'bookSourceGroup' : 'lastUpdateTime'} DESC`
      } else {
        sql += ` isTop DESC, customOrder ASC`;
      }
      const column: ColumnInfo[] = this.getFlowColumn()
      return await DbUtil.querySqlForList<BookSourcePart>(sql, column)
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }

  async search(searchParams?: BookSourceSearchParams) {
    const searchKey = searchParams?.searchKey ?? '';
    const type = searchParams?.type;
    const enabled = searchParams?.enabled;
    const hasExploreUrl = searchParams?.hasExploreUrl;
    const showExplore = searchParams?.showExplore;
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      let sql = `SELECT * FROM book_sources`;
      // 动态添加 WHERE 子句
      let whereClause: string[] = [];
      if (type !== undefined) {
        whereClause.push(`bookSourceType = ${type}`);
      }
      if (enabled !== undefined) {
        whereClause.push(`enabled = ${enabled ? 1 : 0}`);
      }
      if (hasExploreUrl !== undefined) {
        whereClause.push(`COALESCE(exploreUrl, '') ${hasExploreUrl ? '<>' : '='} ''`);
      }
      if (showExplore !== undefined) {
        whereClause.push(`showExplore = ${showExplore ? 1 : 0}`);
      }
      if (searchKey) { // 确保 searchKey 不为空或未定义
        whereClause.push(`(
    bookSourceName LIKE '%${searchKey}%'
    OR bookSourceGroup LIKE '%${searchKey}%'
    OR bookSourceUrl LIKE '%${searchKey}%'
    OR bookSourceComment LIKE '%${searchKey}%'
  )`);
      }

      // 如果有 where 子句，添加 WHERE 关键字
      if (whereClause.length > 0) {
        sql += ` WHERE ${whereClause.join(' AND ')}`;
      }

      sql += `
  ORDER BY
    isTop DESC, customOrder ASC
`;
      const bookSourceDbList = await DbUtil.querySqlForList<BookSourceDb>(sql, column);
      const bookSourceList = bookSourceDbList.map((item): BookSource => ToBookSource(item));
      console.log("TagInfo", '书源数量：' + bookSourceList.length)
      return bookSourceList
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }

  async getBookSource(key: string): Promise<BookSource | null> {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('bookSourceUrl', key)
      const bookSourceDbList = await DbUtil.queryForList<BookSourceDb>(predicates, column);
      const bookSourceList = bookSourceDbList.map((item): BookSource => ToBookSource(item));
      if (bookSourceList.length > 0) {
        if (bookSourceList[0].showRecentIcon) {
          this.updateRecentIcon(ToBookSourcePart(bookSourceList[0]))
        }
        return bookSourceList[0]
      }
      return null
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return null
    }
  }

  async insert(bookSource: BookSource) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('bookSourceUrl', bookSource.bookSourceUrl)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count !== 0) {
        this.update(bookSource)
        return true
      }
      const bookSourceDb = ToBookSourceDb(bookSource)
      bookSourceDb.lastUpdateTime = Date.now()
      await DbUtil.insert(this.TABLE_NAME, bookSourceDb, column)
      console.log('TagInfo', '创建成功')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async batchInsert(bookSources: BookSource[]) {
    try {
      for (let index = 0; index < bookSources.length; index++) {
        const bookSource = bookSources[index];
        await this.insert(bookSource)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async updateFlow(bookSource: BookSourcePart) {
    try {
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('bookSourceUrl', bookSource.bookSourceUrl)
      bookSource.lastUpdateTime = Date.now()
      const columnPart: ColumnInfo[] = this.getFlowColumn().slice(0, -2)
      await DbUtil.update(predicates, bookSource, columnPart)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async update(bookSource: BookSource) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('bookSourceUrl', bookSource.bookSourceUrl)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count === 0) {
        this.insert(bookSource)
        return true
      }
      const bookSourceDb = ToBookSourceDb(bookSource)
      bookSourceDb.lastUpdateTime = Date.now()
      await DbUtil.update(predicates, bookSourceDb, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async batchUpdateFlow(bookSources: BookSourcePart[]) {
    try {
      for (let index = 0; index < bookSources.length; index++) {
        const bookSource = bookSources[index];
        await this.updateFlow(bookSource)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async updateRecentIcon(bookSources: BookSourcePart) {
    try {
      bookSources.showRecentIcon = false
      this.updateFlow(bookSources)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async delete(key: string) {
    try {
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('bookSourceUrl', key)
      await DbUtil.delete(predicates);
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async batchDelete(keys: string[]) {
    try {
      for (let index = 0; index < keys.length; index++) {
        const key = keys[index];
        await this.delete(key)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }
}

const bookSourceDao = new BookSourceDao()

export default bookSourceDao as BookSourceDao