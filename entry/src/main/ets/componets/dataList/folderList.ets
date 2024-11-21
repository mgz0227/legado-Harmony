/**
 * 文件夹
 */
export class folderList {

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

  isShow:boolean

  newUpdateBook:string

  topUpdateTime:Date

  isUpdateReminder:boolean



  constructor(id:number,title:string,countNumber:number,bookImage:Resource,bookType:string,newUpdateBook:string = '',isShow:boolean = false,isTop:boolean = false,describe:string = '', topUpdateTime:Date = new Date(),isUpdateReminder:boolean = false) {
    this.id = id
    this.title = title
    this.bookType = bookType
    this.isTop = isTop
    this.describe = describe
    this.countNumber = countNumber
    this.bookImage = bookImage
    this.newUpdateBook = newUpdateBook
    this.topUpdateTime = topUpdateTime
    this.isShow = isShow
    this.isUpdateReminder = isUpdateReminder
  }
}
