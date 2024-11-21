/**
 * @author 2008
 * @datetime 2024/8/5 22:30
 * @className: BookHistoryUtils
 * 阅读历史记录
 */
import bookHistoryDao from '../../database/dao/BookHistoryDao';
import { BookHistory } from '../../database/entities/BookHistory';
import { Books } from '../../database/entities/Books';
import booksUtils from './booksUtils';

export class BookHistoryUtils {
  async deleteBookHistory(id: number) {
   return await bookHistoryDao.deleteBookHistory(id)
  }
  async deleteAllBookHistory(){
   bookHistoryDao.deleteAllBookHistory()
  }
  async addBooks(books: BookHistory){
    bookHistoryDao.insert(books)
    let book = new Books()
    book.id = books.id
    book.durChapterTitle = books.durChapterTitle
    book.lastCheckTime = books.durChapterTime
    book.durChapterIndex = books.durChapterIndex
    book.durChapterTime = Date.now()
    booksUtils.partialUpdate(book)
  }
}

const bookHistoryUtils = new BookHistoryUtils();
export default bookHistoryUtils as BookHistoryUtils;