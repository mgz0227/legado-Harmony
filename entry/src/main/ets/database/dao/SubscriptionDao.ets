/**
 * @author 2008
 * @datetime 2024/7/15 1:34
 * @className: SubscriptionDao
 * 订阅源
 */
import DbUtil from '../../common/utils/DbUtil';
import AppDatabaseUtil from '../AppDatabaseUtil';

class SubscriptionDao {
  TABLE_NAME: string = 'book_subscription'

  // 创建book_subscription数据表
  async initSubscriptionTable() {
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
}

const subscriptionDao = new SubscriptionDao()
export default subscriptionDao as SubscriptionDao