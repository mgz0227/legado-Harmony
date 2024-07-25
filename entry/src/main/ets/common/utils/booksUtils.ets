/**
 * @author 2008
 * @datetime 2024/7/23 10:58
 * @className: booksUtils
 */
import BooksDao from '../../database/dao/BooksDao'
import { Books } from '../../database/entities/Books'

class booksUtils{
  async isTopBook(id: number, isTop?: boolean): Promise<boolean> {
    return BooksDao.isUpdateBookTop(id, isTop)
  }
  async addBooks(books: Books){
    BooksDao.insert(books)
  }

  async updateBooks(id:number|number[], group:number){
    //循环更新
    let booId:number[] = []
    if (typeof id === 'number'){
      booId.push(id)
    } else {
      booId = id
    }
    booId.forEach((item:number)=>{
      BooksDao.updateBookGroup(item,group)
    })
  }

  async delBooksById(id:number){
    BooksDao.deleteBook(id)
  }
}
let booksUtil = new booksUtils();
export default booksUtil as booksUtils;