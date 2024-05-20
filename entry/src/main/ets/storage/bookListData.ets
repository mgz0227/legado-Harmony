import CommonConstants from '../common/constants/CommonConstants'
import { BookList } from '../componets/dataList/bookList'
/**
 * 初始化存放书本内容
 */
let KEY = ''

const novelListData:BookList[] = [
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('2','仙人消失之后','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('3','仙人消失之后','会说话的肘子·未读过3','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('4','仙人消失之后','会说话的肘子·未读过4','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('5','仙人消失之后','会说话的肘子·未读过5','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('6','仙人消失之后','会说话的肘子·未读过6','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('7','仙人消失之后','会说话的肘子·未读过7','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('8','仙人消失之后','会说话的肘子·未读过8','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('9','仙人消失之后','会说话的肘子·未读过9','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('10','仙人消失之后','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ,new BookList('11','仙人消失之后','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')

]

const soundListData:BookList[] = [
  new BookList('1','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('2','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('3','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('4','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('5','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('6','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('7','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('8','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('9','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻'),
  new BookList('10','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'),'玄幻')]

const cartoonListData:BookList[] = [
  new BookList('1','极主夫道','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('2','极主夫道','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('3','极主夫道','会说话的肘子·未读过3','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('4','极主夫道','会说话的肘子·未读过4','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('5','极主夫道','会说话的肘子·未读过5','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('6','极主夫道','会说话的肘子·未读过6','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('7','极主夫道','会说话的肘子·未读过7','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('8','极主夫道','会说话的肘子·未读过8','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('9','极主夫道','会说话的肘子·未读过9','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
  ,new BookList('10','极主夫道','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list1'),'玄幻')
]

const novelGroupListData:string[] = []
const soundGroupListData:string[] = []
const cartoonGroupListData:string[] = []

export const initBookListData = ()=>{
  AppStorage.setOrCreate(CommonConstants.KEY_NOVEL_BOOK_DATA,novelListData)
  AppStorage.setOrCreate(CommonConstants.KEY_SOUND_BOOK_DATA,soundListData)
  AppStorage.setOrCreate(CommonConstants.KEY_CARTOON_BOOK_DATA,cartoonListData)
}

export const delBookListByBookId = (shelfTye:number,bookId:string)=>{

    let bookListData = getBookListData(shelfTye)

    bookListData = bookListData.filter(book => book.bookId !== bookId);

    console.log('b',JSON.stringify(bookListData))
    //重新存放
    AppStorage.set(KEY,bookListData)
}

export const delBookListAll = (shelfTye:number)=>{

  let bookListData = getBookListData(shelfTye)

  bookListData = [];
  //重新存放
  AppStorage.set(KEY,bookListData)
}


//根据调用方法传过来的BookList数组更新AppStorage中的数据
export const updateBookListData = (shelfTye:number,list:BookList[])=>{
  let bookListData =  getBookListData(shelfTye)
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
  AppStorage.set(KEY,shortDateList(bookListData))
}

export const updateDateListById = (index:number, isJoin:boolean, bookId:string)=>{
  let bookListData =  getBookListData(index)
  //如何bookId存在，则更新字段isJoin
  for (let i = 0; i < bookListData.length; i++) {
    if (bookListData[i].bookId === bookId) {
      bookListData[i].isJoin = isJoin
      break
    }
  }
  AppStorage.set(KEY,shortDateList(bookListData))
}

function shortDateList(showBookList:BookList[]){
  showBookList.sort((a, b) => {
    if (a.isTop && !b.isTop) {
      return -1
    } else if (!a.isTop && b.isTop) {
      return 1
    } else {
      return b.topUpdateTime.getTime() - a.topUpdateTime.getTime()
    }
  })
  return showBookList
}

function getBookListData(shelfTye:number){
  shelfBookType(shelfTye)
  let bookList = AppStorage.get<BookList>(KEY) || []
  let bookListData = bookList as BookList[]
  return bookListData
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

