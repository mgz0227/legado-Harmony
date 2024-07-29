import BooksDao from '../../database/dao/BooksDao'
import { Books } from '../../database/entities/Books'
import bookGroupUtils from './bookGroupUtils'
import toolsUtils from './ToolsUtils'

class booksUtils{
  async isTopBook(id: number|number[], isTop: boolean): Promise<boolean>{
    let Ids:number[] = toolsUtils.numberArrays(id)
    try {
      Ids.forEach((item:number)=>{
        BooksDao.isUpdateBookTop(item, isTop)
      })
      return true
    } catch (e){
      return false
    }
  }
  async addBooks(books: Books){
    BooksDao.insert(books)
  }
  /**
   * @author 2008
   * @param id 需要移动的书籍Id
   * @param group 移动到的分组Id
   * updateBooks 书籍批量移动
   */
  async updateBooks(id:number|number[], group:number){
    let BookGroupId: Record<number, number> = {}
    //循环更新
    let bookId:number[] = toolsUtils.numberArrays(id)
    //根据书籍获取旧的分组Id
    BookGroupId = await BooksDao.getBookIdsByGroupId(bookId)

    if (Object.values(BookGroupId).map(o=>o).length === 0){
      await bookGroupUtils.updateAddBookIds(group, bookId)
    } else {
      bookGroupUtils.updateMoveBookIdsByGroupId(BookGroupId)
      //同时将新的书籍Id添加到分组中
      bookGroupUtils.updateAddBookIds(group, bookId)
    }
    //再去更新新的书籍的分组
    bookId.forEach((item:number)=>{
      BooksDao.updateBookGroup(item,group)
    })
  }

  async delBooksById(id:number|number[]){
    let BookGroupId: Record<number, number> = {}
    let bookId:number[] = toolsUtils.numberArrays(id)
    //根据书籍获取分组Id
    BookGroupId = await BooksDao.getBookIdsByGroupId(bookId)
    if (Object.values(BookGroupId).map(o=>o).length > 0) {
      bookGroupUtils.updateMoveBookIdsByGroupId(BookGroupId)
    }

    BooksDao.deleteBook(bookId)
  }
}
let booksUtil = new booksUtils();
export default booksUtil as booksUtils;