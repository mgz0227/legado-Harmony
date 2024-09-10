/**
 * @author 2008
 * @datetime 2024/8/25 0:11
 * @className: BookChapter
 */
export class BookChapter {
  url:string = '' // 章节地址
  title:string = '' // 章节标题
  isVolume:boolean = false // 是否是卷名
  baseUrl:string = '' // 用来拼接相对url
  bookUrl:string = '' // 书籍地址
  index:number = 0 // 章节序号
  isVip:boolean = false // 是否VIP
  isPay:boolean = false // 是否已购买
  resourceUrl?:string // 音频真实URL
  tag?:string // 更新时间或其他章节附加信息
  start:number = 0  // 章节起始位置
  end:number = 0 // 章节终止位置
  startFragmentId:string = '' //EPUB书籍当前章节的fragmentId
  endFragmentId:string = '' //EPUB书籍下一章节的fragmentId
  variable:string = ''  //变量
}