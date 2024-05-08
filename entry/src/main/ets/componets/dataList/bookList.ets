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



  constructor(bookId:string, title:string,describe:string , chapter:string,  bookImage:Resource,isJoin:boolean = false) {
    this.bookId = bookId
    this.title = title
    this.isJoin = isJoin
    this.describe = describe
    this.chapter = chapter
    this.bookImage = bookImage
  }
}
