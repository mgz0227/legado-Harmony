/**
 * @author 2008
 * @datetime 2024/7/23 11:02
 * @className: BooksType
 */
export interface BooksTypeSearchParams {
  // 搜索关键词书源名称/书籍名称/author
  searchKey?: string,
  // 源类型 0 小说；1 漫画；2 有声书；
  type?: number,
  //分组
  bookGroup?: number,
  //排序方式
  order?: string
}