export class ReaderChapterItem {
  number: number
  content: string
  chapterTitleNumber: string
  title: string
  paragraphList: string[]
  chapterPageList: ReaderChapterPageItem[]

  constructor(number: number, title = '', chapterTitleNumber = '', content = '', paragraphList = [],
    chapterPageList = []) {
    this.number = number
    this.content = content
    this.chapterTitleNumber = chapterTitleNumber
    this.title = title
    this.paragraphList = paragraphList
    this.chapterPageList = chapterPageList
  }
}

export class ReaderChapterPageItem {
  startIndex: number
  endIndex: number
  lineContentList: string[]

  constructor(startIndex: number, endIndex: number, lineList :string[]= []) {
    this.lineContentList = lineList
    this.startIndex = startIndex
    this.endIndex = endIndex
  }

  get content(): string {
    return this.lineContentList.join('');
  }
}