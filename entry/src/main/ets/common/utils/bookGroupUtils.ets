/**
 * @author 2008
 * @datetime 2024/7/26 10:58
 * @className: booksUtils
 */
import BookGroupsDao from '../../database/dao/BookGroupsDao'
import BooksDao from '../../database/dao/BooksDao'
import { BookGroups } from '../../database/entities/BookGroups'

class bookGroupUtils{

  async isTopGroup(id: number, isTop?: boolean): Promise<boolean> {
    return BookGroupsDao.isUpdateGroupTop(id, isTop)
  }

  async addGroup(books: BookGroups){
    BookGroupsDao.insert(books)
  }
  //
  // async updateBookGroup(id:number|number[], group:number){
  //   //循环更新
  //   let booId:number[] = []
  //   if (typeof id === 'number'){
  //     booId.push(id)
  //   } else {
  //     booId = id
  //   }
  //   booId.forEach((item:number)=>{
  //     BooksDao.updateBookGroup(item,group)
  //   })
  // }

  async delGroupById(id:number){
    //删除分组
    BookGroupsDao.deleteBook(id)
    //同时更新书籍分组为未分组
    BooksDao.queryBookByGroup(id, 3)
  }

  async moveBookByGroupId(oldGroup:number|number[], newGroup:number){
    //同时更新书籍分组为未分组
    let Ids:number[] = []
    if (typeof oldGroup === 'number'){
      Ids.push(oldGroup)
    } else {
      Ids = oldGroup
    }
    Ids.forEach((item:number)=>{
      BooksDao.queryBookByGroup(item, newGroup)
    })
  }

  async updateGroupShow(groupId:number|number[]){
    let Ids:number[] = []
    if (typeof groupId === 'number'){
      Ids.push(groupId)
    } else {
      Ids = groupId
    }
    Ids.forEach((item:number)=>{
      BookGroupsDao.updateGroupShow(item)
    })
  }
}
let bookGroupUtil = new bookGroupUtils();
export default bookGroupUtil as bookGroupUtils;