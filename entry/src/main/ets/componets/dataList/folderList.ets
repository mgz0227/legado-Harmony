/**
 * 文件夹
 */
export class folderList {
  /**
   * 标题
   */
  title:string

  /**
   * 描述
   */
  describe:string

  /**
   * 类型
   */
  bookType:string

  /**
   * 章节
   */
  countNumber:number

  /**
   * 图片
   */
  bookImage:Resource

  /**
   * 是否置顶
   */
  isTop:boolean



  constructor(title:string,countNumber:number,bookImage:Resource,bookType:string,isTop:boolean = false,describe:string = '') {
    this.title = title
    this.bookType = bookType
    this.isTop = isTop
    this.describe = describe
    this.countNumber = countNumber
    this.bookImage = bookImage
  }
}
