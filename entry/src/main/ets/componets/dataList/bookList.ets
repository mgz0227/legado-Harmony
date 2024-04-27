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
   * 章节
   */
  chapter:string

  /**
   * 图片
   */
  bookImage:Resource




  constructor( title:string,describe:string , chapter:string,  bookImage:Resource) {
    this.title = title
    this.describe = describe
    this.chapter = chapter
    this.bookImage = bookImage
  }
}
