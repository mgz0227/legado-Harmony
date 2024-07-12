import BookSourceDao from './dao/BookSourceDao'

class DataBase {
  async initAllTable() {
    await BookSourceDao.initBookSourceTable()
  }
}

const dataBase = new DataBase()

export default dataBase as DataBase