import { BookSource } from "./BookSource";

@Observed
export class Books {
  //书籍ID
  id?:number;
  //书籍存储路径
  bookUrl?:string
  //目录页Url
  toUrl?:string
  // 书源URL
  origin?:string
  //书源名称 or 本地书籍文件名
  originName?:string
  // 书籍名称(书源获取) 或则自定义书籍名称
  bookName:string = ""
  // // 作者名称(书源获取)
  author: string = ""
  //分类信息(书源获取)
  cover?:string
  //分类信息
  customTag?:string
  //封面Url(书源获取)
  coverUrl?:string
  //自定义封面Url
  customCoverUrl?:string
  //简介内容(书源获取)
  intro?:string
  //简介内容(用户修改)
  customIntro?:string
  //自定义字符集名称(仅适用于本地书籍)
  charset?:string
  //在导入的情况下或则未分组默认为2 未分组
  bookGroup:number = 3;
  // 最新章节标题
  latestChapterTitle?:string
  // 最新章节标题更新时间
  latestChapterTime:number = 0;
  //最近一次更新书籍信息的时间
  lastCheckTime?:number
  //最近一次发现新章节的数量
  lastCheckCount?:number
  //书籍目录总数
  totalChapterNum:number = 0;
  //当前章节名称
  durChapterTitle?:string
  //当前章节索引
  durChapterIndex:number = 0
  //当前阅读的进度(首行字符的索引位置)
  durChapterPos:number = 0
  //最近一次阅读书籍的时间(打开正文的时间)
  durChapterTime:number = 0
  //字数
  wordCount?:string
  //刷新书架时更新书籍信息
  canUpdate:boolean = true
  //排序
  sort:number = 0
  //书源排序
  originOrder:number = 0
  //同步时间
  syncTime:number = 0
  //小说0/漫画1/有声2
  bookType:number = 0
  //是否置顶
  isTop:boolean = false
  //创建时间
  createTime?:number = 0
  //更新时间
  updateTime?:number = 0
  //是否加入书架
  isJoin:boolean = false
  //是否本地导入
  isLocalBook:boolean = false
  source?:BookSource
  sourceList?:BookSource[] = []
}
