/**
 * @author 2008
 * @datetime 2024/7/24 21:16
 * @className: BookGroupsDao
 */
import DbUtil from '../../common/utils/DbUtil';
import AppDatabaseUtil from '../AppDatabaseUtil';
import { BookGroups } from '../entities/BookGroups';
import { BookGroupTypeParams } from '../types/BookGroupType';
import { ColumnInfo } from '../types/ColumnInfo';

class BookGroupsDao{
  TABLE_NAME: string = 'book_groups'

  // 创建books数据表
  async initGroupTable() {
    try {
      const createSql = AppDatabaseUtil.getCreateSql(this.TABLE_NAME);
      if (!createSql) {
        return
      }
      await DbUtil.createTable(createSql)
      AppDatabaseUtil.existsTable(this.TABLE_NAME)
      this.initGroupData()
      return
    } catch (err) {
      console.info('TagInfo', JSON.stringify(err))
    }

  }

  async search(params?:BookGroupTypeParams) {
    const type = params?.type
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      let sql = `SELECT * FROM ${this.TABLE_NAME}`;
      // 动态添加 WHERE 子句
      let whereClause: string[] = [];

      if (type !== undefined){
        whereClause.push(`groupType = ${type} OR groupType = 123`);
      }
      // 如果有 where 子句，添加 WHERE 关键字
      if (whereClause.length > 0) {
        sql += ` WHERE ${whereClause.join(' AND ')}`;
      }

      sql += `
  ORDER BY
    sort ASC
`;
      const groupDbList = await DbUtil.querySqlForList<BookGroups>(sql, column);
      console.log("TagInfo", '书籍：' + groupDbList.length)
      return groupDbList
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }

  async searchHide(params?:BookGroupTypeParams) {
    const type = params?.type
    const show = params?.show
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      let sql = `SELECT * FROM ${this.TABLE_NAME}`;
      // 动态添加 WHERE 子句
      let whereClause: string[] = [];

      if (type !== undefined){
        whereClause.push(`groupType = ${type}`);
      }
      if (show !== undefined){
        whereClause.push(`show = ${show}`);
      }
      // 如果有 where 子句，添加 WHERE 关键字
      if (whereClause.length > 0) {
        sql += ` WHERE ${whereClause.join(' AND ')}`;
      }

      sql += `
  ORDER BY
    sort ASC
`;
      const groupDbList = await DbUtil.querySqlForList<BookGroups>(sql, column);
      console.log("TagInfo", '书籍：' + groupDbList.length)
      return groupDbList
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }


  async batchInsert(group: BookGroups[]) {
    try {
      for (let index = 0; index < group.length; index++) {
        const data = group[index];
        await this.insert(data)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async insert(group: BookGroups) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      if (group.groupId) {
        const predicates = DbUtil.getPredicates(this.TABLE_NAME);
        predicates.equalTo('groupId', group.groupId)
        const count = await DbUtil.queryForCount(predicates, column)
        if (count > 0) {
          this.update(group)
          return true
        }
      }
      group.createTime = Date.now()
      await DbUtil.insert(this.TABLE_NAME, group, column)
      console.log('TagInfo', '创建成功')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async update(group: BookGroups) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('groupId', group.groupId)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count === 0 && group instanceof BookGroups) {
        this.insert(group)
        return true
      }
      await DbUtil.update(predicates, group, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }

  }

  //批量删除订阅源历史记录
  async deleteBookList(group: BookGroups[]) {
    try {
      for (let index = 0; index < group.length; index++) {
        await this.deleteBook(group[index]?.groupId||0)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  //删除订阅源历史记录
  async deleteBook(id: number) {
    try {
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('groupId', id)
      await DbUtil.delete(predicates)
      return true
    }  catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  //系统初始分组数据
  async initGroupData() {
    let initGroup = ['分组','全部','未分组','本地','书单']
    try {
      const groupList = await this.search()
      if (groupList.length > 0) {
        return
      }
      for (let index = 0; index < initGroup.length; index++) {
          let group = new BookGroups()
          group.groupName = initGroup[index]
          group.sort = 0
          group.show = true
          group.groupType = 123
          group.canDelete = false
          await bookGroupsDao.insert(group)
      }
    }catch (e){
      console.log('TagInfo, Error, ', JSON.stringify(e))
    }
  }
}

const bookGroupsDao = new BookGroupsDao()
export default bookGroupsDao as BookGroupsDao