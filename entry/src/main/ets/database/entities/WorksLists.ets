import { GSON } from '../../common/utils/utils';
import { WorksBookList } from './WorksBookList';
/**
 * @author 2008
 * @datetime 2024/8/1 13:10
 * @className: WorksLists
 * 书单
 */
@Observed
export class WorksLists {
  //书单Id
  worksId?:number;
  //书单名称
  worksName:string = "";
  //书单描述
  worksDescribe:string = "";
  //备注
  worksRemark:string = "";
  //封面
  worksCoverUrl:string = "";
  //创建时间
  createTime:number = 0;
  //更新时间
  updateTime:number = 0;
  //小说0/漫画1/有声2
  worksType:number = 0
  //书籍数量
  worksBookNum:number = 0;
  //置顶
  isTop:boolean = false;
  //书单书籍信息
  worksBookList?:WorksBookList[];
}

export interface worksListsDb extends Omit<WorksLists, 'worksBookList'> {
  //列表
  worksBookList?: string
}

export const ToWorksLists = (worksListsDb: worksListsDb) => {
  const worksBookList = GSON.toJson<WorksBookList[]>(worksListsDb.worksBookList);
  const worksLists: WorksLists = {
    worksId: worksListsDb.worksId,
    worksName: worksListsDb.worksName,
    worksDescribe: worksListsDb.worksDescribe,
    worksRemark: worksListsDb.worksRemark,
    worksCoverUrl: worksListsDb.worksCoverUrl,
    createTime: worksListsDb.createTime,
    updateTime: worksListsDb.updateTime,
    worksType: worksListsDb.worksType,
    worksBookNum: worksListsDb.worksBookNum,
    isTop: worksListsDb.isTop,
    worksBookList
  }
  return worksLists
}

export const ToWorksListsDb = (worksLists: WorksLists) => {
  const worksBookList = GSON.toString(worksLists.worksBookList);
  const worksListsDb: worksListsDb = {
    worksId: worksLists.worksId,
    worksName: worksLists.worksName,
    worksDescribe: worksLists.worksDescribe,
    worksRemark: worksLists.worksRemark,
    worksCoverUrl: worksLists.worksCoverUrl,
    createTime: worksLists.createTime,
    updateTime: worksLists.updateTime,
    worksType: worksLists.worksType,
    worksBookNum: worksLists.worksBookNum,
    isTop: worksLists.isTop,
    worksBookList
  }
  return worksListsDb
}

export const WORK_BOOK_LIST_STATUS: Record<number, string> ={
  0: '新建书单',
  1: '',
  2: '编辑书单'
}
