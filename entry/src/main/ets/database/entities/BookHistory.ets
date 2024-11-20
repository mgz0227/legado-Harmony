/**
 * @author 2008
 * @datetime 2024/8/5 21:15
 * @className: BookHistory
 * 书籍浏览历史
 */
@Observed
export class BookHistory {
  id?:number
  // 书籍名称
  bookName:string = ''
  // 作者名称
  author: string = ''
  //阅读地址
  bookUrl:string = ''
  //封面地址
  coverUrl:string = ''
  //最近一次阅读书籍的时间(打开正文的时间)
  durChapterTime:number = 0
  //最近一次阅读章节的序号
  durChapterIndex:number = 0
  //最近一次阅读章节的标题
  durChapterTitle:string = ''
  //最近一次阅读章节进度
  durChapterContent:string = ''
  //排序
  sort:number = 0
  //小说0/漫画1/有声2
  bookType?:number
  //源书籍ID
  originBookId?:number
  //创建时间
  createTime?:number = 0
  //更新时间
  updateTime?:number = 0

  constructor(bookHistory?:BookHistory) {
    if (bookHistory) {
      this.id = bookHistory.id
      this.bookName = bookHistory.bookName
      this.author = bookHistory.author
      this.durChapterTime = bookHistory.durChapterTime
      this.durChapterIndex = bookHistory.durChapterIndex
      this.durChapterTitle = bookHistory.durChapterTitle
      this.durChapterContent = bookHistory.durChapterContent
      this.sort = bookHistory.sort
      this.bookType = bookHistory.bookType
    }
  }
}