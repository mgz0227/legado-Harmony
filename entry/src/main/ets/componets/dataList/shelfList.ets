/**
 * 书单
 */
import { BookList } from './bookList'

export class shelfList {

  id:number
  /**
   * 标题
   */
  title:string

  /**
   * 描述
   */
  describe:string

  /**
   * 推荐理由
   */
  recommendation:string

  /**
   * 是否置顶
   */
  isTop:boolean
  /**
   * 是否显示
   */
  isShow:boolean

  /**
   * 置顶跟新时间
   */
  topUpdateTime:Date

  /**
   * 书籍内容
   */
  bookList:BookList[]



  constructor(id:number,title:string,describe:string
    ,recommendation:string,bookList:BookList[],isTop:boolean = false,isShow:boolean = false
    ,topUpdateTime:Date = new Date()
   ) {
    this.id = id
    this.title = title
    this.isTop = isTop
    this.describe = describe
    this.topUpdateTime = topUpdateTime
    this.isShow = isShow
    this.bookList = bookList
    this.recommendation = recommendation
  }
}
