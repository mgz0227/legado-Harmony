import { SearchRule } from '../../database/entities/rule';
import { SearchBook } from '../../database/entities/SearchBook';
import { BookSource } from '../../database/entities/BookSource';
import { ExploreQuery } from '../../database/types/BookSourceType';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
import { isNetworkUrl } from '../utils/utils';


export interface IXmlAnalysis {
  baseUrl: string  //搜索地址
  body:string  //请求内容
  bookSource:BookSource//书源
  variable?:string
  searchUrl:string
}
interface dataRule{
  body:string
  rule:SearchRule
  searchUrl:string
}
export class XmlAnalysisData {
  baseUrl: string = ''  //搜索地址
  body:string = ''//请求内容
  bookSource?:BookSource//书源
  variable?:string
  searchUrl:string = ''
  constructor(xmlDate?: IXmlAnalysis) {
    this.baseUrl = xmlDate?.baseUrl || ''
    this.body = xmlDate?.body || ''
    this.bookSource = xmlDate?.bookSource
    this.variable = xmlDate?.variable
    this.searchUrl = xmlDate?.searchUrl || ''
  }
}
export class XmlAnalysis {
  xmlDate:XmlAnalysisData = new XmlAnalysisData()
  url:string = ''
  source?:SearchRule
  searchUrl:string = ''
  init(xmlDate:XmlAnalysisData){
    this.xmlDate = xmlDate
    this.url = xmlDate.searchUrl
    this.source = this.xmlDate.bookSource?.ruleSearch
    this.searchUrl = this.xmlDate.searchUrl
  }

  async getBookList(): Promise<SearchBook[]>  {
    let bookList:SearchBook[] = []
    if (!this.source) return bookList
    const data: dataRule = {
      body: this.xmlDate.body,
      rule: this.source,
      searchUrl: this.searchUrl
    }
    let response: AxiosResponse<object> = await axios.post('http://legado.wisdoms.xin/analysisBook', data)
    if (response.data){
     bookList = (response.data as SearchBook[]).map(item => {
        item.bookType = this.xmlDate.bookSource?.bookSourceType ?? 0
        item.source = this.xmlDate.bookSource
        if (item.coverUrl && !isNetworkUrl(item.coverUrl)) {
          item.coverUrl = this.xmlDate.bookSource?.bookSourceUrl + item.coverUrl
        }
        return item
      })
    }

    if (bookList.length > 0){
      console.log('test')
    }
    return bookList
  }

  //解析xml
  async analysisXml(): Promise<SearchBook[]> {
    return await this.getBookList();
  }

}
// const xmlAnalysis = new XmlAnalysis();
// export default xmlAnalysis as XmlAnalysis;