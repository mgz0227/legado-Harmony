/**
 * 书籍详情页规则
 */
export class BookInfoRule {
    init?: string
    name?: string
    author?: string
    intro?: string
    kind?: string
    lastChapter?: string
    updateTime?: string
    coverUrl?: string
    tocUrl?: string
    wordCount?: string
    canReName?: string
    downloadUrls?: string

    constructor(bookInfo?: BookInfoRule) {
        if (!bookInfo) return;
        this.init = bookInfo.init;
        this.name = bookInfo.name;
        this.author = bookInfo.author;
        this.intro = bookInfo.intro;
        this.kind = bookInfo.kind;
        this.lastChapter = bookInfo.lastChapter;
        this.updateTime = bookInfo.updateTime;
        this.coverUrl = bookInfo.coverUrl;
        this.tocUrl = bookInfo.tocUrl;
        this.wordCount = bookInfo.wordCount;
        this.canReName = bookInfo.canReName;
        this.downloadUrls = bookInfo.downloadUrls;
    }
}