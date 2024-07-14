import BookSourceDao from './dao/BookSourceDao'
import SubscriptionDao from './dao/SubscriptionDao'

class DataBase {
  async initAllTable() {
    await BookSourceDao.initBookSourceTable()
    await SubscriptionDao.initSubscriptionTable()
  }
}

const dataBase = new DataBase()

export default dataBase as DataBase