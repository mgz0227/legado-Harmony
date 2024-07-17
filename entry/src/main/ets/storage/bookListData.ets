import CommonConstants from '../common/constants/CommonConstants'
import { BookList } from '../componets/dataList/bookList'
import bookDataPreferences from '../common/utils/DataPreferencesUtils'
import { getBookData } from '../preferences/bookDataPreferences'

/**
 * 初始化存放书本内容
 */
let KEY = ''

export const initBookListData = ()=>{
  // AppStorage.setOrCreate(CommonConstants.PREFERENCES_BOOK_TYPE_NUMBER,0)
  AppStorage.setOrCreate(CommonConstants.KEY_NOVEL_BOOK_DATA,getBookData(0))
  AppStorage.setOrCreate(CommonConstants.KEY_SOUND_BOOK_DATA,getBookData(1))
  AppStorage.setOrCreate(CommonConstants.KEY_CARTOON_BOOK_DATA,getBookData(2))
}

export const addShelfBook = (shelfTye:number, bookData:BookList)=>{
  let bookList = getBookData(shelfTye)
  //根据bookList bookId是string类型排序然后获取最大的一个id然后自增
  bookData.bookId = getBookIdAutoIncrement(bookList)

  bookList.push(bookData)

  shortUpdateDateList(bookList,shelfTye)
}

export const delBookListByBookId = (shelfTye:number,bookId:string)=>{

    let bookListData = getBookData(shelfTye)

    bookListData = bookListData.filter(book => book.bookId !== bookId);

    //重新存放
  shortUpdateDateList(bookListData,shelfTye)
}

export const delBookListAll = (shelfTye:number)=>{

  let bookListData = getBookData(shelfTye)

  bookListData = [];
  //重新存放
  shortUpdateDateList(bookListData,shelfTye)
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
  shortUpdateDateList(bookListData,shelfTye)
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
  shortUpdateDateList(bookListData,index)
}

export const shortUpdateDateList = (showBookList:BookList[],KeyNumber:number)=> {
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
  shelfBookType(KeyNumber)
  AppStorage.set(KEY,showBookList)
  bookDataPreferences.shared.set(KEY,showBookList);
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


export const shortDateList = (showBookList:BookList[])=> {
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

  return showBookList
}

function shelfBookType(shelfTye:number){
  if (shelfTye === 0) {
    KEY = CommonConstants.KEY_NOVEL_BOOK_DATA
  } else if (shelfTye === 1) {
    KEY = CommonConstants.KEY_CARTOON_BOOK_DATA
  } else if (shelfTye === 2) {
    KEY = CommonConstants.KEY_SOUND_BOOK_DATA
  }
}
