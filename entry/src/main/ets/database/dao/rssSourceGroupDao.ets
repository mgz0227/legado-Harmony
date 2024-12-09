import { ColumnInfo } from '../types/ColumnInfo';
import AppDatabaseUtil from '../AppDatabaseUtil'
import { JSON } from '@kit.ArkTS';
import DbUtil from '../../common/utils/DbUtil';
import { RssSourceGroup } from '../entities/RssSourceGroup';

class RssSourceGroupDao {
  TABLE_NAME: string = 'rss_source_group'

  // rss_source_group
  async initBookSourceGroupTable() {
    try {
      const createSql = AppDatabaseUtil.getCreateSql(this.TABLE_NAME);
      if (!createSql) {
        return
      }
      await DbUtil.createTable(createSql);
      await AppDatabaseUtil.existsTable(this.TABLE_NAME)
      this.initGroupData()
      return
    } catch (err) {
      console.info('TagInfo', JSON.stringify(err))
    }
  }


  async search(){
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      let sql = `SELECT * FROM ${this.TABLE_NAME}`;
      // sql += `ORDER BY isTop DESC, groupSort ASC`;
      const groupDbList = await DbUtil.querySqlForList<RssSourceGroup>(sql, column);
      console.log("TagInfo", '书籍：' + groupDbList.length)
      return groupDbList
    } catch (err) {
      console.log("TagInfo", JSON.stringify(err))
      return []
    }
  }


  //系统初始订阅源分组数据
  async initGroupData() {
    let initGroup = ['小说','漫画','影视','资讯','收藏夹']
    try {
      const groupList = await this.search()
      if (groupList.length > 0) {
        return
      }
      for (let index = 0; index < initGroup.length; index++) {
        let group = new RssSourceGroup()
        // group.rssGroupId = index
        group.rssGroupName = initGroup[index]
        group.groupSort = index
        group.isTop = false
        group.isDelete = false
        await this.insert(group)
      }
    }catch (e){
      console.log('TagInfo, Error, ', JSON.stringify(e))
    }
  }

  async insert(rssGroup: RssSourceGroup) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      if (rssGroup.rssGroupId) {
        const predicates = DbUtil.getPredicates(this.TABLE_NAME);
        predicates.equalTo('rssGroupId', rssGroup.rssGroupId)
        const count = await DbUtil.queryForCount(predicates, column)
        if (count > 0) {
          this.update(rssGroup)
          return true
        }
      }
      await DbUtil.insert(this.TABLE_NAME, rssGroup, column)
      console.log('TagInfo', '创建成功')
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }

  async update(rssGroup: RssSourceGroup) {
    try {
      const column: ColumnInfo[] = AppDatabaseUtil.getColumn(this.TABLE_NAME);
      const predicates = DbUtil.getPredicates(this.TABLE_NAME);
      predicates.equalTo('rssGroupId', rssGroup.rssGroupId)
      const count = await DbUtil.queryForCount(predicates, column)
      if (count === 0 && rssGroup instanceof RssSourceGroup) {
        this.insert(rssGroup)
        return true
      }

      await DbUtil.update(predicates, rssGroup, column)
      return true
    } catch (err) {
      console.log('TagInfo, Error, ', JSON.stringify(err))
      return false
    }
  }




}

const rssSourceGroupDao = new RssSourceGroupDao()

export default rssSourceGroupDao as RssSourceGroupDao