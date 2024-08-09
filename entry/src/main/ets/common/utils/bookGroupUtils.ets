/**
 * @author 2008
 * @datetime 2024/7/26 10:58
 * @className: booksUtils
 */
import BookGroupsDao from '../../database/dao/BookGroupsDao'
import BooksDao from '../../database/dao/BooksDao'
import { BookGroups } from '../../database/entities/BookGroups'
import toolsUtils from './ToolsUtils'

class bookGroupUtils{
  //校验唯一性,同时进行更新
  async onlyGroupUpdateName(newName: string, id: number) {
    return await BookGroupsDao.onlyGroupUpdateName(id,newName)
  }
  //置顶分组
  async isTopGroup(id: number|number[], isTop: boolean) {
    let Ids:number[] = []
    if (typeof id === 'number'){
      Ids.push(id)
    } else {
      Ids = id
    }
    Ids.forEach((item:number)=>{
      BookGroupsDao.isUpdateGroupTop(item, isTop)
    })

  }
  //添加分组
  async addGroup(books: BookGroups){
    BookGroupsDao.insert(books)
  }
  //删除分组
  async delGroupById(id:number|number[]){
    let Ids = toolsUtils.numberArrays(id)
    if (Ids.length === 0) return
    //删除分组
    BookGroupsDao.deleteBook(Ids)
    //同时更新书籍分组为未分组
    BooksDao.queryBookByGroup(Ids, 3)
  }

  //管理页面批量移动分组
  /**
   * @author 2008
   * @param oldGroup
   * @param newGroup
   * 分组批量移动
   */
  async moveBookByGroupId(oldGroup: number | number[], newGroup: number) {
    try {
      let Ids: number[] = toolsUtils.numberArrays(oldGroup)
      //如果Ids里面有存在newGroup则把Ids移除
      if (Ids.includes(newGroup)) {
        Ids = Ids.filter(item => item !== newGroup);
      }
      // 根据旧的分组Id获取书籍Id
      const booksInGroup = await BooksDao.queryBooksByGroupId(Ids);

      // 更新书籍分组
      await BooksDao.updateBookGroup(booksInGroup, newGroup);

      //将旧分组书籍id移除
      BookGroupsDao.updateMoveGroupBookIds(Ids)

      //更新移动的分组下的bookId将GroupBookIds中的值添加到新的分组中
      BookGroupsDao.updateAddBookIds(newGroup, booksInGroup.map(val => val.toString()))

    } catch (e) {
      console.log('moveBookByGroupId, Error, ', JSON.stringify(e));
    }
  }

  //批量更新分组是否显示
  async updateGroupShow(groupId:number|number[], isShow?:boolean){
    let Ids:number[] = toolsUtils.numberArrays(groupId)
    Ids.forEach((item:number)=>{
      BookGroupsDao.updateGroupShow(item,isShow)
    })
  }

  //更新分组的bookIds
  async updateAddBookIds(newGroupId:number,bookId:number|number[]){
    //循环更新
    let book:number[] = toolsUtils.numberArrays(bookId)

    if(newGroupId && bookId){
      BookGroupsDao.updateAddBookIds(newGroupId, book.map(val => val.toString()))
    }
  }

  //移除分组下的bookId
  updateMoveBookIdsByGroupId(data:Record<number, number>){
    BookGroupsDao.updateMoveBookIdsByGroupId(data)
  }

  //分组批量移动书籍
  updateMoveGroupBookIds(data:Record<number, number>){
    BookGroupsDao.updateMoveBookIdsByGroupId(data)
  }
  //根据分组获取分组下的书籍Id
  async queryBookByGroupId(groupId:number|number[]){
    let Ids:number[] = toolsUtils.numberArrays(groupId)
    return await BookGroupsDao.queryBookByGroup(Ids)
  }

  //更新分组部分数据
  async updatePartialGroup(data:BookGroups){
    BookGroupsDao.updatePartialGroup(data)
  }
}
let bookGroupUtil = new bookGroupUtils();
export default bookGroupUtil as bookGroupUtils;