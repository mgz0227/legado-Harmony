/**
 * @author 2008
 * @datetime 2024/7/23 10:58
 * @className: booksUtils
 */
import BooksDao from '../../database/dao/BooksDao'
import { Books } from '../../database/entities/Books'

class booksUtils{
  async isTopBook(id: number): Promise<boolean> {
    return BooksDao.isUpdateBookTop(id)
  }
  async addBooks(books: Books){
    BooksDao.insert(books)
  }

  async delBooksById(id:number){
    BooksDao.deleteBook(id)
  }
}
let booksUtil = new booksUtils();
export default booksUtil as booksUtils;