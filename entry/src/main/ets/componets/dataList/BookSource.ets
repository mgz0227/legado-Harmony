export interface BookInfoRule {
  init?: string;
  name?: string;
  author?: string;
  intro?: string;
  kind?: string;
  lastChapter?: string;
  updateTime?: string;
  coverUrl?: string;
  tocUrl?: string;
  wordCount?: string;
  canReName?: string;
  downloadUrls?: string
}

export interface ContentRule {
  content?: string;
  title?: string; //有些网站只能在正文中获取标题
  nextContentUrl?: string;
  webJs?: string;
  sourceRegex?: string;
  replaceRegex?: string; //替换规则
  imageStyle?: string;   //默认大小居中,FULL最大宽度
  imageDecode?: string; //图片bytes二次解密js, 返回解密后的bytes
  payAction?: string;    //购买操作,js或者包含{{js}}的url
}

export interface ExploreRule {
  bookList?: string;
  name?: string;
  author?: string;
  intro?: string;
  kind?: string;
  lastChapter?: string;
  updateTime?: string;
  bookUrl?: string;
  coverUrl?: string;
  wordCount?: string
}

export interface SearchRule {
  checkKeyWord?: string;
  bookList?: string;
  name?: string;
  author?: string;
  kind?: string;
  wordCount?: string;
  lastChapter?: string;
  intro?: string;
  coverUrl?: string;
  bookUrl?: string;
}

export interface TocRule {
  preUpdateJs?: string;
  chapterList?: string;
  chapterName?: string;
  chapterUrl?: string;
  formatJs?: string;
  isVolume?: string;
  isVip?: string;
  isPay?: string;
  updateTime?: string;
  nextTocUrl?: string
}

export interface BookSource {
  bookSourceName: string;
  bookSourceUrl: string;
  bookSourceType: number;
  bookSourceGroup: string;
  grade: number,
  score: string,
  bookSourceComment: string;
  loginUrl: string;
  loginUi: string;
  loginCheckJs: string;
  bookUrlPattern: string;
  coverDecodeJs: string;
  header: string;
  variableComment: string;
  concurrentRate: string;
  jsLib: string;
  enabled: boolean;
  enabledCookieJar: boolean;
  enabledExplore: boolean;
  lastUpdateTime: number;
  respondTime: number;
  bookInfoRule?: BookInfoRule;
  contentRule?: ContentRule;
  exploreRule?: ExploreRule;
  searchRule?: SearchRule;
  tocRule?: TocRule;
  searchUrl: string;

  customOrder: number;
  exploreUrl: string;
  weight: number;
}

export interface GroupList {
  title: string
  list: BookSource[]
}

export const GRADE_TYPE: Record<number, string> = {
  0: '常规',
  1: '优质',
  2: '精品'
}

export const BOOK_SOURCE_TYPE: Record<number, string> = {
  0 : '小说',
  1 : '漫画',
  2 : '有声'
}