import { ColumnInfo } from '../types/ColumnInfo';
import { BookSource, toBookSource, toBookSourceDb, BookSourceDb } from '../entities/BookSource';
import AppDatabaseUtil from '../AppDatabaseUtil'
import { JSON } from '@kit.ArkTS';
import DbUtil from '../../common/utils/DbUtil';

class BookSourceDao {
  TABLE_NAME: string = 'book_sources'

  // 创建book_source数据表
  async initBookSourceTable() {
    try {
      const createSql = AppDatabaseUtil.getCreateSql(this.TABLE_NAME);
      if (!createSql) {
        return
      }
      return await DbUtil.createTable(createSql)
    } catch (err) {
      console.info('TagInfo', JSON.stringify(err))
    }
  }

  async search(searchKey: string = '') {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates
        .contains('bookSourceName', searchKey)
        .or()
        .contains('bookSourceGroup', searchKey)
        .or()
        .contains('bookSourceUrl', searchKey)
        .or()
        .contains('bookSourceComment', searchKey)
        .orderByAsc('customOrder')
      const bookSourceDbList = await DbUtil.queryForList<BookSourceDb>(predicates, column);
      const bookSourceList = bookSourceDbList.map((item): BookSource => toBookSource(item));
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
      const bookSourceList = bookSourceDbList.map((item): BookSource => toBookSource(item));
      if (bookSourceList.length > 0) {
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
      const bookSourceDb = toBookSourceDb(bookSource)
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
      const bookSourceDb = toBookSourceDb(bookSource)
      await DbUtil.update(predicates, bookSourceDb, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async batchUpdate(bookSources: BookSource[]) {
    try {
      for (let index = 0; index < bookSources.length; index++) {
        const bookSource = bookSources[index];
        await this.update(bookSource)
      }
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