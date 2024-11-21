/**
 * @author 2008
 * @datetime 2024/8/15 13:15
 * @className: NetworkUtils
 */
import { url } from '@kit.ArkTS';
class NetworkUtils {

  getAbsoluteURL(baseUrl: string, searchUrl: string): string {
    try {
      const absoluteUrl = url.URL.parseURL(searchUrl, baseUrl);
      return absoluteUrl.href;
    } catch (error) {
      console.error('Failed to resolve absolute URL:', error);
      return searchUrl;
    }
  }

  async getBaseUrl(url: string): Promise<string | null> {
    if (!url) return null
    if(url.startsWith('http://') || url.startsWith('https://')){
      let index = url.indexOf("/", 9)
      if (index === -1) {
        return url
      } else {
        return url.substring(0, index)
      }
    }
    return null
  }

  checkContentType(data:string){
    try {
      // 尝试将数据解析为 JSON
      if (typeof data === 'object') {
        return true;
      }
      JSON.parse(data);
      return true;
    } catch (e) {
      // 如果解析失败，检查是否存在 HTML 标签
      if (/<\/?[^>]+(>|$)/.test(data)) {
        return false;
      } else {
        // 如果既不是有效的 JSON 也不是 HTML，则返回未知类型
        return null;
      }
    }
  }

  //判断类型是string还是ArrayBuffer
  isString(data:string|ArrayBuffer):boolean{
    return typeof data === 'string'
  }

  cleanUrl(url:string){
    return url.replace(/^\s+|\s+$/g, '').replace(/[\r\n]+/g, '');
  }


}
const networkUtil = new NetworkUtils();
export default networkUtil as NetworkUtils;