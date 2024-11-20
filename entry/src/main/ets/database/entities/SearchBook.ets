/**
 * @author 2008
 * @datetime 2024/8/14 20:56
 * @className: SearchBook
 */
import { BookSource } from './BookSource'

@Observed
export class SearchBook {
  bookUrl: string = ""
  /** 书源 */
  origin: string = ""
  originName: string = ""
  /** BookType */
  type: string = ""
  name: string = ""
  author: string = ""
  kind?:string
  coverUrl?: string
  intro?: string
  wordCount?:string
  latestChapterTitle:string = ""
  /** 目录页Url (toc=table of Contents) */
  tocUrl?:string = ""
  time:number = Date.now()
  variable?:string
  originOrder?:number = 0
  chapterWordCountText?:string
  chapterWordCount?: number = -1
  respondTime?: number = -1
  //数量
  belongCount:number = 1
  source?:BookSource
  sourceList:BookSource[] = []
  bookType:number = 0
}