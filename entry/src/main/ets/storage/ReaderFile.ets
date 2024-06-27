export class chaptersItem {
  number: number
  content: string
  chapterTitleNumber: string
  title: string

  constructor(number: number, title = '', chapterTitleNumber = '', content = '') {
    this.number = number
    this.content = content
    this.chapterTitleNumber = chapterTitleNumber
    this.title = title
  }
}