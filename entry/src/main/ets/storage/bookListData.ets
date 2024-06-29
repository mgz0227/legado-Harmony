import CommonConstants from '../common/constants/CommonConstants'
import { showMessage } from '../componets/common/promptShow'
import { BookList } from '../componets/dataList/bookList'
import bookDataPreferences from '../preferences/bookDataPreferences'

/**
 * 初始化存放书本内容
 */
let KEY = ''

export const novelListData:BookList[] = [
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'测试作者','玄幻')
  ,new BookList('2','仙人消失之后','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list'),'测试作者','玄幻')
]

const soundListData:BookList[] = [
  new BookList('1','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('2','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('3','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('4','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('5','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('6','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('7','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('8','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('9','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻'),
  new BookList('10','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'测试作者','玄幻')]

const cartoonListData:BookList[] = [
  new BookList('1','极主夫道','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('2','极主夫道','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('3','极主夫道','会说话的肘子·未读过3','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('4','极主夫道','会说话的肘子·未读过4','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('5','极主夫道','会说话的肘子·未读过5','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('6','极主夫道','会说话的肘子·未读过6','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('7','极主夫道','会说话的肘子·未读过7','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('8','极主夫道','会说话的肘子·未读过8','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('9','极主夫道','会说话的肘子·未读过9','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
  ,new BookList('10','极主夫道','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list1'),'测试作者','玄幻')
]

const novelGroupListData:string[] = []
const soundGroupListData:string[] = []
const cartoonGroupListData:string[] = []

export const initBookListData = ()=>{
  bookDataPreferences.shared.set(CommonConstants.PREFERENCES_BOOK_INIT_KEY,true)
  bookDataPreferences.shared.set(CommonConstants.KEY_NOVEL_BOOK_DATA,novelListData)
  bookDataPreferences.shared.set(CommonConstants.KEY_SOUND_BOOK_DATA,soundListData)
  bookDataPreferences.shared.set(CommonConstants.KEY_CARTOON_BOOK_DATA,cartoonListData)
}

export const getBookData = (shelfTye:number)=>{
  shelfBookType(shelfTye)
  return bookDataPreferences.shared.get(KEY) as BookList[];
}

export const addShelfBook = (shelfTye:number, bookData:BookList)=>{
  let bookList = getBookData(shelfTye)
  //根据bookList bookId是string类型排序然后获取最大的一个id然后自增
  bookData.bookId = getBookIdAutoIncrement(bookList)
  showMessage(bookData.bookId)
  bookList.push(bookData)
  console.log(`${KEY} ---------------`)
  console.log(JSON.stringify(bookList))
  bookDataPreferences.shared.set(KEY,bookList)
  console.log(`最终结果 ---------------`)
  console.log(JSON.stringify(bookDataPreferences.shared.get(KEY) as BookList[]))
}

export const delBookListByBookId = (shelfTye:number,bookId:string)=>{

    let bookListData = getBookData(shelfTye)

    bookListData = bookListData.filter(book => book.bookId !== bookId);

    console.log('b',JSON.stringify(bookListData))
    //重新存放
    bookDataPreferences.shared.set(KEY,shortDateList(bookListData))
}

export const delBookListAll = (shelfTye:number)=>{

  let bookListData = getBookData(shelfTye)

  bookListData = [];
  //重新存放
  bookDataPreferences.shared.set(KEY,shortDateList(bookListData))
}


//根据调用方法传过来的BookList数组更新AppStorage中的数据
export const updateBookListData = (shelfTye:number,list:BookList[])=>{
  let bookListData =  getBookData(shelfTye)
  for (let index = 0; index < list.length; index++) {
    for (let j = 0; j < bookListData.length; j++) {
      if (bookListData[j].bookId === list[index].bookId) {
        //如果bookListData[j]的里面的内容都全等于list[index]不做操作
        if (JSON.stringify(bookListData[j]) === JSON.stringify(list[index])) {
          break
        }
        bookListData[j] = list[index]
        break
      }
    }
  }
  bookDataPreferences.shared.set(KEY,shortDateList(bookListData))
}

export const updateDateListById = (index:number, isJoin:boolean, bookId:string)=>{
  let bookListData =  getBookData(index)
  //如何bookId存在，则更新字段isJoin
  for (let i = 0; i < bookListData.length; i++) {
    if (bookListData[i].bookId === bookId) {
      bookListData[i].isJoin = isJoin
      break
    }
  }
  bookDataPreferences.shared.set(KEY,shortDateList(bookListData))
}

export function shortDateList(showBookList:BookList[]) {
  //防止topUpdateTime出现string类型
  showBookList.forEach(book => {
    if (typeof book.topUpdateTime === 'string') {
      book.topUpdateTime = new Date(book.topUpdateTime);
    }
  });
  let aTime = 0, bTime = 0;
  showBookList.sort((a:BookList, b:BookList) => {
    if (a.isTop && !b.isTop) {
      return -1;
    } else if (!a.isTop && b.isTop) {
      return 1;
    } else {
      aTime = a.topUpdateTime instanceof Date ? a.topUpdateTime.getTime() : 0;
      bTime = b.topUpdateTime instanceof Date ? b.topUpdateTime.getTime() : 0;
      return bTime - aTime;
    }
  });

  return showBookList;
}

// function getBookListData(shelfTye:number){
//   shelfBookType(shelfTye)
//   let bookList = AppStorage.get<BookList>(KEY) || []
//   let bookListData = bookList as BookList[]
//   return bookListData
// }

function shelfBookType(shelfTye:number){
  if (shelfTye === 0) {
    KEY = CommonConstants.KEY_NOVEL_BOOK_DATA
  } else if (shelfTye === 1) {
    KEY = CommonConstants.KEY_CARTOON_BOOK_DATA
  } else if (shelfTye === 2) {
    KEY = CommonConstants.KEY_SOUND_BOOK_DATA
  }
}
//id自增
const getBookIdAutoIncrement = (bookList:BookList[])=>{
  let maxId = 0
  bookList.forEach(book => {
    if (parseInt(book.bookId) > maxId) {
      maxId = parseInt(book.bookId)
    }
  })
  return JSON.stringify( maxId + 1)
}

