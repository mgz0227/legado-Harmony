import { BookSource } from '../../database/entities/BookSource';
import AppPattern from '../constants/AppPattern';
import { parseSearchString, SearchConfig } from '../model/SearchConfig';
import networkUtil from './NetworkUtils';

export interface IParseURL {
  baseUrl: string
  searchUrl: string
  page: number
  keyword: string
  removeCookie?: boolean
  bookSource:BookSource
  speakText?:string
  speakSpeed?:number
}

export class ParseURL {
  baseUrl: string = '';
  searchUrl: string = '';
  page: number = 1;
  keyword: string = '';
  removeCookie?: boolean = false;
  speakText?:string
  speakSpeed?:number
  bookSource?:BookSource;
  constructor(parseUrl?: IParseURL) {
    this.baseUrl = parseUrl?.baseUrl || '';
    this.searchUrl = parseUrl?.searchUrl || '';
    this.page = parseUrl?.page || 1;
    this.keyword = parseUrl?.keyword || '';
    this.removeCookie = parseUrl?.removeCookie;
    this.bookSource = parseUrl?.bookSource;
    this.speakText = parseUrl?.speakText
    this.speakSpeed = parseUrl?.speakSpeed
  }
}
export class ParseURLUtils {
  parseURL: ParseURL = new ParseURL();
  ruleUrl:string = ''
  url:string = ''
  private init(){
    let urlMatcher = this.parseURL.baseUrl.match(AppPattern.pattern)
    if (urlMatcher && urlMatcher.length > 0) {
      this.parseURL.baseUrl = this.parseURL.baseUrl.substring(0, urlMatcher.index);
    }
    this.ruleUrl = networkUtil.cleanUrl(this.parseURL.searchUrl);
    this.url =  networkUtil.cleanUrl(this.parseURL.baseUrl);
  }

  setParseURL(value: ParseURL) {
    this.parseURL = value;
  }

  extractAndReplace(ruleUrl: string): string {
    if (ruleUrl.startsWith("{{")) {
      const end = ruleUrl.indexOf("}}");
      if (end !== -1) {
        const result = ruleUrl.replace(/{{[^}]*}}/, '');
        return result ?? '';
      }
    }
    return ruleUrl;
  }

  replacePlaceholders(str: string, placeholder: string, replacement: string): string {
    const regex = new RegExp(placeholder, 'g');
    return str.replace(regex, replacement);
  }

  buildBaseUrl(baseUrl: string, path: string, body: string): string {
    const ensureNoLeadingSlash = (str: string) => str.replace(/^\/+/, '');
    const ensureNoTrailingSlash = (str: string) => str.replace(/\/+$/, '');

    if (path) {
      if (!path.startsWith('http://') && !path.startsWith('https://')) {
        path = ensureNoTrailingSlash(baseUrl) + '/' + ensureNoLeadingSlash(path);
      } else {
        path = ensureNoTrailingSlash(path);
      }
    } else {
      path = ensureNoTrailingSlash(baseUrl);
    }

    if (path && body) {
      if (!path.endsWith('/') && !body.startsWith('/')) {
        //需要校验path如果结尾是/就替换为? 如果没有/就添加?
        if (path.endsWith('/')) {
          path = path.slice(0, -1);
        }
        path += '?';
      } else if (path.endsWith('/') && body.startsWith('/')) {
        body = ensureNoLeadingSlash(body);
      }
    }
    return ensureNoTrailingSlash(path + body);
  }

  processRuleUrl(): SearchConfig|string {
    this.init()
    let baseUrl = ''
    let searchUrl = this.ruleUrl
    searchUrl = this.extractAndReplace(searchUrl)
    try {
      let parseSearch = parseSearchString(searchUrl)
      baseUrl = this.buildBaseUrl(this.url, parseSearch.path,parseSearch.body);
      baseUrl = this.replacePlaceholders(baseUrl, '{{key}}', decodeURIComponent(this.parseURL.keyword));
      baseUrl = this.replacePlaceholders(baseUrl, '{{page}}', this.parseURL.page.toString());
      baseUrl = networkUtil.getAbsoluteURL(this.url, baseUrl)
      parseSearch.url = baseUrl
      return parseSearch;
    } catch (e){
      baseUrl = this.buildBaseUrl(this.url, searchUrl, '')
      baseUrl = this.replacePlaceholders(baseUrl, '{{key}}', decodeURIComponent(this.parseURL.keyword));
      baseUrl = this.replacePlaceholders(baseUrl, '{{page}}', this.parseURL.page.toString());
      return baseUrl
    }
  }
}