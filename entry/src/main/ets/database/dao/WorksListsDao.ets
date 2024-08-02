import DbUtil from '../../common/utils/DbUtil';
import AppDatabaseUtil from '../AppDatabaseUtil';
import { ToWorksLists, ToWorksListsDb, WorksLists, worksListsDb } from '../entities/WorksLists';
import { ColumnInfo } from '../types/ColumnInfo';
import { WorksListsTypeSearchParams } from '../types/WorksListsType';

/**
 * 书单db操作
 */
class WorksListsDao {
  TABLE_NAME: string = 'works_lists'

  // 创建works_lists数据表
  async initWorksListsTable() {
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

  async search(param?:WorksListsTypeSearchParams) {
    let searchKey = param?.searchKey ?? '';
    let type = param?.type;
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      let sql = `SELECT * FROM ${this.TABLE_NAME}`;
      // 动态添加 WHERE 子句
      let whereClause: string[] = [];
      if (type !== undefined) {
        whereClause.push(`worksType = ${type}`);
      }
      if (searchKey) {
        whereClause.push(`(
        worksName LIKE '%${searchKey}%'
        worksDescribe LIKE '%${searchKey}%'
      )`);
      }
      // 如果有 where 子句，添加 WHERE 关键字
      if (whereClause.length > 0) {
        sql += ` WHERE ${whereClause.join(' AND ')}`;
      }
      sql += `
  ORDER BY
     isTop DESC, createTime DESC
`;
      const workDbList = await DbUtil.querySqlForList<worksListsDb>(sql, column);
      const worksList = workDbList.map((item): WorksLists => ToWorksLists(item));
      console.log("TagInfo", '书单：' + worksList.length)
      return worksList
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }

  async batchInsert(works: WorksLists[]) {
    try {
      for (let index = 0; index < works.length; index++) {
        const work = works[index];
        await this.insert(work)
      }
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async insert(works: WorksLists) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      if (works.worksId) {
        const predicates = DbUtil.getPredicates(this.TABLE_NAME);
        predicates.equalTo('worksId', works.worksId)
        const count = await DbUtil.queryForCount(predicates, column)
        if (count > 0) {
          this.update(works)
          return true
        }
      }
      const worksListsDb = ToWorksListsDb(works)
      worksListsDb.worksBookNum = works.worksBookList?.length ?? 0
      worksListsDb.createTime = Date.now()
      await DbUtil.insert(this.TABLE_NAME, worksListsDb, column)
      console.log('TagInfo', '创建成功')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async update(works: WorksLists) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('worksId', works.worksId)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count === 0 && works instanceof WorksLists) {
        this.insert(works)
        return true
      }
      const worksListsDb = ToWorksListsDb(works)
      worksListsDb.createTime = Date.now()
      worksListsDb.worksBookNum = works.worksBookList?.length ?? 0
      await DbUtil.update(predicates, worksListsDb, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  //置顶
  async isUpdateWorksTop(worksId: number, isTop: boolean) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('worksId', worksId)
      const count = await DbUtil.queryForList<WorksLists>(predicates, column)
      if (column.length > 0) {
        count.forEach((item) => {
          item.isTop = isTop
          item.updateTime = Date.now()
          this.update(item)
        })
        return true
      }
      return false
    } catch (err) {
      console.log('isUpdateWorksTop, Error, ', JSON.stringify(err))
      return false
    }
  }

  //删除书单记录
  async deleteWorks(worksId: number[]) {
    try {
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.in('worksId', worksId)
      await DbUtil.delete(predicates)
      return true
    }  catch (err) {
      console.log('deleteBook, Error, ', JSON.stringify(err))
      return false
    }
  }
}


const worksListsDao = new WorksListsDao()
export default worksListsDao as WorksListsDao