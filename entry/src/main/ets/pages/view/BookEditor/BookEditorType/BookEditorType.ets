export class BookEditorType {

  private BookName?:string;
  private BookAuthor?:string;
  private BookIcon?:Resource;
  private BookIconUrl?:string;
  private BookSynopsis?:string;
  private isSelect?:boolean;

  constructor(bookName?:string, bookAuthor?:string, bookIcon?:Resource, bookIconUrl?:string, bookSynopsis?:string, isSelect?:boolean) {
    this.BookName = bookName;
    this.BookAuthor = bookAuthor;
    this.BookIcon = bookIcon;
    this.BookIconUrl = bookIconUrl;
    this.BookSynopsis = bookSynopsis;
    this.isSelect = isSelect
  }


  setBookName(bookName:string):void {
    this.BookName = bookName;
  }

  setBookAuthor(bookAuthor:string):void {
    this.BookAuthor = bookAuthor;
  }

  setBookIcon(bookIcon:Resource):void {
    this.BookIcon = bookIcon;
  }

  setBookIconUrl(bookIconUrl:string):void {
    this.BookIconUrl = bookIconUrl;
  }

  setBookSynopsis(bookSynopsis:string):void {
    this.BookSynopsis = bookSynopsis;
  }

  setBookSelect(isSelect:boolean):void {
    this.isSelect = isSelect;
  }

  getBookName():string {
    if (this.BookName) {
      return this.BookName;
    }
    return 'undefined';
  }

  getBookAuthor():string {
    if (this.BookAuthor) {
      return this.BookAuthor;
    }
    return 'undefined';
  }

  getBookIcon():ResourceStr {
    if (this.BookIcon) {
      return this.BookIcon;
    }
    return 'undefined';
  }

  getBookIconUrl():string {
    if (this.BookIconUrl) {
      return this.BookIconUrl;
    }
    return 'undefined';
  }

  getBookSynopsis():string {
    if (this.BookSynopsis) {
      return this.BookSynopsis;
    }
    return 'undefined';
  }

  getBookSelect():boolean {
    if(this.isSelect) {
      return this.isSelect
    }
    return false
  }
}