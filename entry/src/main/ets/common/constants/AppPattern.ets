/**
 * @author 2008
 * @datetime 2024/8/15 13:36
 * @className: AppPattern
 */
export default class AppPattern {
  static readonly paramPattern: RegExp = /(?<!\{\{)[ ,]\s*(?=\{)/g;
  static readonly pattern: RegExp = /\s*,\s*(?=\{)/g;
  static readonly pagePattern:RegExp = /<(.*)>/;
  static readonly jsPattern: RegExp = /<js>(.*?)<\/js>|@js:(.*)/i;
  static readonly EXP_PATTERN: RegExp = /\{\{([^\}]*?)\}\}/g;
  static readonly imgPattern: RegExp = /<img[^>]*src="([^"]*(?:"[^>]+\\})?)"[^>]*>/g;
}