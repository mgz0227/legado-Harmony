import { showMessage } from '../../componets/common/promptShow';
import bookSourceDao from '../../database/dao/BookSourceDao';
import { BookSource } from '../../database/entities/BookSource';
import { SearchBook } from '../../database/entities/SearchBook';
import { XmlAnalysis, XmlAnalysisData } from '../model/XmlAnalysis';
import networkUtil from './NetworkUtils';
import { IParseURL, ParseURL, ParseURLUtils } from './ParseURLUtils';
import requestUtil from './requestUtils';


class searchUtils{
  searchBooks: SearchBook[] = []
  private bookSourceParts:BookSource[] = []
  private searchKey: string = ''
  private searchPage:number = 1
  private mSearchId:number = 0

  async search(searchKey: string) {
    if (!searchKey) {
      return;
    }
    this.searchKey = searchKey;
    this.bookSourceParts = await bookSourceDao.getEnabledPartByGroup();
    if (!this.bookSourceParts || this.bookSourceParts.length === 0) {
      showMessage('启用书源为空');
      return;
    }
    this.searchBooks = [];
    for (const bookSource of this.bookSourceParts) {
      this.searchData(this.searchKey,Date.now(), bookSource);
    }
  }

  async searchData(searchKey: string,searchId:number, bookSource:BookSource) {
    this.searchKey = searchKey;
    if (searchId != this.mSearchId) {
      this.mSearchId = searchId
      this.searchPage = 1
    } else {
      this.searchPage++
    }
    try {
      let book = await this.searchBook(bookSource)
      return book
    } catch (e) {
      console.log(e.message)
      return []
    }
  }

  async searchBook(bookSource:BookSource): Promise<SearchBook[]>{
    if (!bookSource.searchUrl || bookSource.searchUrl === undefined) {
      throw new Error('搜索url为空');
    }
    let books:SearchBook[] = []
    let urls = ''
    let body = ''

    // 解析搜索url
    const parseURLUtil = new ParseURLUtils();
    let xmlAnalysis = new XmlAnalysis();
    const parseURLData: IParseURL = {
      page: this.searchPage,
      keyword: this.searchKey,
      baseUrl: bookSource.bookSourceUrl,
      searchUrl: bookSource.searchUrl,
      bookSource:bookSource
    };
    parseURLUtil.setParseURL(new ParseURL(parseURLData));
    let parse = parseURLUtil.processRuleUrl();
    if (typeof parse !== 'string') {
      urls = parse.url
      // body = await requestUtil.requestHtml(parse)
    } else {
      urls = parse
      // let res = await requestUtil.requestUrlHtml(parse)
      // if (res === undefined) return []
      // if (networkUtil.checkContentType(res)) {
      //   console.log('Json数据')
      // }
      // body = res
    }
    if (bookSource.ruleSearch) {
      xmlAnalysis.init(new XmlAnalysisData({
        baseUrl: parseURLData.baseUrl,
        body: body,
        bookSource:bookSource,
        searchUrl: urls
      }))
      let searchBooks = await xmlAnalysis.analysisXml()
      books.push(...searchBooks)
    }
    return books
  }
}

const searchUtil = new searchUtils();
export default searchUtil as searchUtils;