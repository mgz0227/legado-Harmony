import { router } from '@kit.ArkUI';
import taskSearchBooks from '../../common/model/taskSearchBook';
import { SearchBook } from '../../database/entities/SearchBook';
import { showMessage } from '../common/promptShow';


@Component
export struct SearchHead{
  @Consume SearchValue: string
  @Consume SearchStatus: number
  @Consume('searchBookList') books:SearchBook[]
  @State lastSearch:string = ''
  @Consume('isSearch') isSearch:boolean
  // @State bookIndex:number = 0
  build() {
    Flex({
      alignItems:ItemAlign.End,
      justifyContent:FlexAlign.SpaceBetween
    }){
      Row({ space: 15 }) {
        Image($r('app.media.return_left'))
          .width(25)
          .height(25)
          .onClick(()=>{
            router.back()
            if (this.isSearch) {
              taskSearchBooks.cancelAllTasks()
            }
          })
        Search({ value: this.SearchValue, placeholder: '搜索书名或作者', icon: "/common/images/search.svg" })
          .width("70%")
          .height(40)
          .onChange(this.onChange)
          .onSubmit(this.onSubmit);
        Text(this.isSearch?"取消":"搜索").width("10%").height(40).fontWeight(600)
          .onClick(()=>{
            if (this.isSearch) {
              taskSearchBooks.cancelAllTasks()
              console.log(`取消搜索${this.books.length}`)
              this.isSearch = false
            } else {
              this.onSubmit(this.SearchValue)
            }
          })
      }.margin({left:5}).width("100%")
    }
    .borderRadius({ bottomRight:5 ,bottomLeft:5})
    .backgroundImage($r('app.media.backgroundimage'))
    .backgroundImageSize({width:'100%'})
    .height('11%')
  }

  onChange=(value: string)=> {
    this.lastSearch = this.SearchValue
    this.SearchValue=value;
  }
  onSubmit= async (value: string)=>{
    this.SearchValue=value;
    if (!this.SearchValue) {
      showMessage('搜索内容不能为空')
      return
    }
    if (this.books.length === 0 || this.SearchValue !== this.lastSearch) {
      this.SearchStatus = 1
    }
    this.isSearch = true
    this.books = []
    taskSearchBooks.search(this.SearchValue, (newUrls: SearchBook[]) => {
      this.setBookList(newUrls)
    },()=>{
      this.SearchStatus = 2
      this.isSearch = false
    })
  }

  setBookList(books: SearchBook[]) {
    if (books.length === 0) return
    books.forEach((book: SearchBook) => {
      let found = false;
      if(!book.name) return
      for (let item of this.books) {
        if (item.name === book.name && item.author === book.author) {
          item.belongCount++;
          //源来的books的source源 id和 books的source源 id相同不添加
          if (item.source?.bookSourceUrl !== book.source?.bookSourceUrl && book.source) {
            // 确保 sourceList 已经存在并且是一个数组
            if (!item.sourceList) {
              item.sourceList = [];
            }
            item.sourceList.push(book.source)
          }
          found = true;
          break;
        }
      }


      if (!found) {
        book.belongCount = 1
        this.books.push(book);
      }
    });
    this.sortBooksBySearchValue()
  }

  sortBooksBySearchValue() {
    this.books.sort((a: SearchBook, b: SearchBook) => {
      const aName = a.name || '';
      const bName = b.name || '';
      const searchValue = this.SearchValue || '';

      const aNameSimilarity = this.getSimilarity(aName.toLowerCase(), searchValue.toLowerCase());
      const bNameSimilarity = this.getSimilarity(bName.toLowerCase(), searchValue.toLowerCase());

      if (aNameSimilarity !== bNameSimilarity) {
        return bNameSimilarity - aNameSimilarity;
      }

      return b.belongCount - a.belongCount;
    });
  }

  getSimilarity(str1: string, str2: string){
    const lengthDifference = Math.abs(str1.length - str2.length);
    const commonLength = Math.min(str1.length, str2.length);
    let similarity = 0;

    for (let i = 0; i < commonLength; i++) {
      if (str1[i] === str2[i]) {
        similarity++;
      }
    }

    return similarity - lengthDifference;
  }


  countMatchingChars(last:string, current:string){
    // 创建一个对象来存储字符串 a 中的字符及其出现次数
    const charsInA: Record<string, number> = {};
    // 填充对象
    for (const char of last) {
      charsInA[char] = (charsInA[char] || 0) + 1;
    }
    // 初始化计数器
    let count = 0;
    // 遍历字符串 b 中的每个字符
    for (const char of current) {
      // 如果字符存在于 a 中，则计数器加一
      if (charsInA[char]) {
        count++;
      }
    }
    return count;
  }
  aboutToAppear(): void {
    console.log(this.SearchStatus.toString());
  }
}