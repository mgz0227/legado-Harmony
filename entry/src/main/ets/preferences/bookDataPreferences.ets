import CommonConstants from '../common/constants/CommonConstants'
import { BookList } from '../componets/dataList/bookList'
import bookDataPreferences from '../common/utils/DataPreferencesUtils'

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



export const initBookPreferences = ()=>{
  //内容数据持久化
  bookDataPreferences.shared.set(CommonConstants.PREFERENCES_BOOK_INIT_KEY,true)
  bookDataPreferences.shared.set(CommonConstants.KEY_NOVEL_BOOK_DATA,novelListData)
  bookDataPreferences.shared.set(CommonConstants.KEY_SOUND_BOOK_DATA,soundListData)
  bookDataPreferences.shared.set(CommonConstants.KEY_CARTOON_BOOK_DATA,cartoonListData)
}
/**
 * 统一更新持久化
 * bookDate 书籍更新内容
 * bookType 书籍类型Key
 */
export const updateShelfBookData = (bookDate:BookList[], bookType:number) =>{
  shelfBookType(bookType)
  bookDataPreferences.shared.set(KEY,bookDate)
}

//获取书架持久化数据
export const getBookData = (shelfTye:number)=>{
  shelfBookType(shelfTye)
  return bookDataPreferences.shared.get(KEY) as BookList[];
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
