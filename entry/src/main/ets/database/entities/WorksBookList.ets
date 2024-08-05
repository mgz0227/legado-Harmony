/**
 * @author 2008
 * @datetime 2024/8/1 13:10
 * @className: markBookList
 * 书单书籍列信息
 */
@Observed
export class WorksBookList{
  //书单书籍Id
  bookId?:number;
  //推荐理由
  recommend?:string
  //书籍标签
  tag?:string

  constructor(book?:WorksBookList) {
    if (!book) return;
    this.bookId = book.bookId;
    this.recommend = book.recommend;
    this.tag = book.tag;
  }
}