

export class SearchBook {

  /**
   * 标题
   */
  title:string
  /**
   * 描述
   */
  describe:string
  /**
   * 图片
   */
  bookImage:ResourceStr
  /**
   * 作者
   */
  author:string
  /**
   *
   */
  label:String[]
  /**
   * 源数量
   */
  sourceNumber:number
  /**
   * 字数
   */
  wordCount:number
  /**
   * 状态 是否完本
   */
  status:boolean

  constructor( title:string,describe:string , bookImage:ResourceStr,author:string,label:String[],sourceNumber:number,wordCount:number,status:boolean) {
    this.title = title
    this.describe = describe
    this.bookImage = bookImage
    this.author = author
    this.label = label
    this.sourceNumber = sourceNumber
    this.wordCount = wordCount
    this.status = status
  }

}