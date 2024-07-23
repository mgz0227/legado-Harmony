/**
 * @author 2008
 * @datetime 2024/7/23 10:58
 * @className: booksUtils
 */
import BooksDao from '../../database/dao/BooksDao'
import { Books } from '../../database/entities/Books'

class booksUtils{
  addBooks(books: Books){
    BooksDao.insert(books)
  }
}
let booksUtil = new booksUtils();
export default booksUtil as booksUtils;