export interface RuleBookInfo {
  init: string;
}

export interface RuleContent {
  content: string;
}

export interface RuleExplore {
  bookList: string;
}

export interface GroupList {
  title: string
  list: BookSource[]
}

export interface RuleSearch {
  author: string;
  bookList: string;
  bookUrl: string;
  coverUrl: string;
  intro: string;
  kind: string;
  lastChapter: string;
  name: string;
  wordCount: string;
}

export interface RuleToc {
  chapterList: string;
  chapterName: string;
  chapterUrl: string;
  isVip: string;
  updateTime: string;
}

export interface BookSource {
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
}