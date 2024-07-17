
export class BookList {

  bookId:string
  /**
   * 标题
   */
  title:string

  /**
   * 描述
   */
  describe:string

  /**
   * 是否加入书架
   */
  isJoin:boolean

  /**
   * 章节
   */
  chapter:string

  /**
   * 图片
   */
  bookImage:Resource

  bookType:string

  /**
   * 是否置顶
   */
  isTop:boolean

  topUpdateTime:Date

  author:string

  fileLink:string

  constructor(bookId:string = '', title:string,describe:string , chapter:string,  bookImage:Resource,author:string = '卖报小郎君',bookType:string ='玄幻',fileLink:string = '', topUpdateTime:Date = new Date(),isJoin:boolean = false,isTop:boolean = false) {
    this.bookId = bookId
    this.title = title
    this.isJoin = isJoin
    this.describe = describe
    this.chapter = chapter
    this.bookImage = bookImage
    this.bookType = bookType
    this.isTop = isTop
    this.topUpdateTime = topUpdateTime
    this.author = author
    this.fileLink = fileLink
  }
}
