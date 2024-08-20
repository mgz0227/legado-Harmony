/**
 * @author 2008
 * @datetime 2024/8/15 0:06
 * @className: SearchConfig
 */
export class SearchConfig {
  path: string;
  method: string;
  body: string;
  charset: string;
  url: string;
  webView:boolean;

  constructor(path: string, method: string, body: string, charset: string, url: string, webView:boolean) {
    this.path = path;
    this.method = method.toUpperCase(); // 确保方法为大写
    this.body = body;
    this.charset = charset??'UTF-8';
    this.url = url;
    this.webView = webView
  }

  // 替换 body 中的关键字
  setKeyword(keyword: string): void {
    this.body = this.body.replace('{{key}}', encodeURIComponent(keyword));
  }
}

interface SearchConfigData {
  method: string;
  body?: string;
  charset?: string;
  url: string;
  webView?:boolean;
}

export function parseSearchString(searchString: string): SearchConfig {
  // 拆分字符串，获取路径与配置
  const splitIndex = searchString.indexOf(',');
  const path = searchString.substring(0, splitIndex).trim();
  const configString = searchString.substring(splitIndex + 1).trim();

  // 对 JSON 配置进行清理和格式化
  const cleanConfigString = configString
    .replace(/(\w+)\s*:/g, '"$1":')  // 给键加上引号
    .replace(/'/g, '"');             // 将单引号替换为双引号

  // 解析 JSON 配置
  const config: SearchConfigData = JSON.parse(cleanConfigString);

  return new SearchConfig(
    path,
    config.method??'GET',
    config.body??'',
    config.charset??'UTF-8',
    config.url??'',
    config.webView??false
  );
}
