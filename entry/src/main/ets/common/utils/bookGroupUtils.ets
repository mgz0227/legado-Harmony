/**
 * @author 2008
 * @datetime 2024/7/26 10:58
 * @className: booksUtils
 */
import BookGroupsDao from '../../database/dao/BookGroupsDao'
import BooksDao from '../../database/dao/BooksDao'
import { BookGroups } from '../../database/entities/BookGroups'

class bookGroupUtils{
  //置顶分组
  async isTopGroup(id: number, isTop?: boolean): Promise<boolean> {
    return BookGroupsDao.isUpdateGroupTop(id, isTop)
  }
  //添加分组
  async addGroup(books: BookGroups){
    BookGroupsDao.insert(books)
  }
  //删除分组
  async delGroupById(id:number){
    //删除分组
    BookGroupsDao.deleteBook(id)
    //同时更新书籍分组为未分组
    BooksDao.queryBookByGroup(id, 3)
  }
  //管理页面批量移动分组
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
  //批量更新分组是否显示
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

  //更新分组的bookIds
  async updateAddBookIds(newGroupId:number,bookId:number,data?:Record<number, number[]>){
    if(newGroupId && bookId){
      BookGroupsDao.updateAddBookIds(newGroupId, bookId)
    }
  }

  //移除分组下的bookId
  async updateMoveBookIdsByGroupId(oldGroupId:number,bookId:number,data?:Record<number, number[]>){
    if (oldGroupId && bookId) {
      BookGroupsDao.updateMoveBookIdsByGroupId(oldGroupId, bookId)
    }
  }
}
let bookGroupUtil = new bookGroupUtils();
export default bookGroupUtil as bookGroupUtils;