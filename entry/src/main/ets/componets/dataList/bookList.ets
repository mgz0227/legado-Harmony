export class BookList {
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



  constructor( title:string,describe:string , chapter:string,  bookImage:Resource,isJoin:boolean = false) {
    this.title = title
    this.isJoin = isJoin
    this.describe = describe
    this.chapter = chapter
    this.bookImage = bookImage
  }
}
