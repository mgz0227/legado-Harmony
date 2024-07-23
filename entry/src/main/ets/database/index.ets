import BooksDao from './dao/BooksDao'
import BookSourceDao from './dao/BookSourceDao'
import rssSourcesHistoryDao from './dao/RssSourcesHistoryDao'
import SubscriptionDao from './dao/SubscriptionDao'

class DataBase {
  async initAllTable() {
    await BookSourceDao.initBookSourceTable()
    await rssSourcesHistoryDao.initRssSourcesHistoryTable()
    await SubscriptionDao.initSubscriptionTable()
    await BooksDao.initBooksTable()
  }
}

const dataBase = new DataBase()

export default dataBase as DataBase