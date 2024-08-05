/**
 * @author 2008
 * @datetime 2024/8/2 0:48
 * @className: worksListsUtils
 * 书单工具类
 */
import worksListsDao from '../../database/dao/WorksListsDao'
import { WorksBookList } from '../../database/entities/WorksBookList'
import { WorksLists } from '../../database/entities/WorksLists'
import ToolsUtils from './ToolsUtils'

export class WorksListsUtils{
  async addWorksLists(worksLists:WorksLists){
     worksListsDao.insert(worksLists)
   }

  async updateWorksLists(worksLists:WorksLists){
    worksListsDao.update(worksLists)
  }

  async delWorksByIds(id:number|number[]){
    let ids = ToolsUtils.numberArrays(id)
    if(ids.length === 0) return
    worksListsDao.deleteWorks(ids)
  }
  //获取书单中的bookId
  getBookIds(worksBookList: WorksBookList[]): number[] {
    const bookIds = worksBookList
      .filter(item => item !== undefined)  // 过滤掉 undefined 的 item
      .map(item => item.bookId)
      .filter(bookId => bookId !== undefined);

    // 如果 bookIds 长度为 0，直接返回空数组
    if (bookIds.length === 0) {
      return [];
    }

    return bookIds.toString().split(',').map(Number);
  }
}
const worksListsUtils = new WorksListsUtils()
export default worksListsUtils