/**
 * @author 2008
 * @datetime 2024/8/5 22:30
 * @className: BookHistoryUtils
 * 阅读历史记录
 */
import bookHistoryDao from '../../database/dao/BookHistoryDao';
import { BookHistory } from '../../database/entities/BookHistory';

export class BookHistoryUtils {
  async deleteBookHistory(id: number) {
   return await bookHistoryDao.deleteBookHistory(id)
  }
  async deleteAllBookHistory(){
   bookHistoryDao.deleteAllBookHistory()
  }
  async addBooks(books: BookHistory){
    bookHistoryDao.insert(books)
  }
}

const bookHistoryUtils = new BookHistoryUtils();
export default bookHistoryUtils as BookHistoryUtils;