class RuleBookInfo {
  init: string;
  constructor(init: string) {
    this.init = init;
  }
}

class RuleContent {
  content: string;
  constructor(content: string) {
    this.content = content;
  }
}

class RuleExplore {
  bookList: string;
  constructor(bookList: string) {
    this.bookList = bookList;
  }
}

export interface GroupList {
  title: string
  list: BookSource[]
}

class RuleSearch {
  author: string;
  bookList: string;
  bookUrl: string;
  coverUrl: string;
  intro: string;
  kind: string;
  lastChapter: string;
  name: string;
  wordCount: string;

  constructor(
    author: string,
    bookList: string,
    bookUrl: string,
    coverUrl: string,
    intro: string,
    kind: string,
    lastChapter: string,
    name: string,
    wordCount: string
  ) {
    this.author = author;
    this.bookList = bookList;
    this.bookUrl = bookUrl;
    this.coverUrl = coverUrl;
    this.intro = intro;
    this.kind = kind;
    this.lastChapter = lastChapter;
    this.name = name;
    this.wordCount = wordCount;
  }
}

class RuleToc {
  chapterList: string;
  chapterName: string;
  chapterUrl: string;
  isVip: string;
  updateTime: string;

  constructor(
    chapterList: string,
    chapterName: string,
    chapterUrl: string,
    isVip: string,
    updateTime: string
  ) {
    this.chapterList = chapterList;
    this.chapterName = chapterName;
    this.chapterUrl = chapterUrl;
    this.isVip = isVip;
    this.updateTime = updateTime;
  }
}

export class BookSource {
  bookSourceComment: string;
  bookSourceGroup: string;
  bookSourceName: string;
  bookSourceType: number;
  bookSourceUrl: string;
  bookUrlPattern: string;
  customOrder: number;
  enabled: boolean;
  enabledCookieJar: boolean;
  enabledExplore: boolean;
  exploreUrl: string;
  lastUpdateTime: number;
  loginUrl: string;
  respondTime: number;
  ruleBookInfo: RuleBookInfo;
  ruleContent: RuleContent;
  ruleExplore: RuleExplore;
  ruleSearch: RuleSearch;
  ruleToc: RuleToc;
  searchUrl: string;
  weight: number;

  constructor(
    bookSourceComment: string,
    bookSourceGroup: string,
    bookSourceName: string,
    bookSourceType: number,
    bookSourceUrl: string,
    bookUrlPattern: string,
    customOrder: number,
    enabled: boolean,
    enabledCookieJar: boolean,
    enabledExplore: boolean,
    exploreUrl: string,
    lastUpdateTime: number,
    loginUrl: string,
    respondTime: number,
    ruleBookInfo: RuleBookInfo,
    ruleContent: RuleContent,
    ruleExplore: RuleExplore,
    ruleSearch: RuleSearch,
    ruleToc: RuleToc,
    searchUrl: string,
    weight: number
  ) {
    this.bookSourceComment = bookSourceComment;
    this.bookSourceGroup = bookSourceGroup;
    this.bookSourceName = bookSourceName;
    this.bookSourceType = bookSourceType;
    this.bookSourceUrl = bookSourceUrl;
    this.bookUrlPattern = bookUrlPattern;
    this.customOrder = customOrder;
    this.enabled = enabled;
    this.enabledCookieJar = enabledCookieJar;
    this.enabledExplore = enabledExplore;
    this.exploreUrl = exploreUrl;
    this.lastUpdateTime = lastUpdateTime;
    this.loginUrl = loginUrl;
    this.respondTime = respondTime;
    this.ruleBookInfo = ruleBookInfo;
    this.ruleContent = ruleContent;
    this.ruleExplore = ruleExplore;
    this.ruleSearch = ruleSearch;
    this.ruleToc = ruleToc;
    this.searchUrl = searchUrl;
    this.weight = weight;
  }
}