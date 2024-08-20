
import { SearchHead } from '../../../componets/search/SearchHead'
import { SearchHistory } from '../../../componets/search/SearchHistory'
import { SearchDetails } from '../../../componets/search/SearchDetails'
import { SearchRefresh } from '../../../componets/search/SearchRefresh'
import taskSearchBooks from '../../../common/model/taskSearchBook'
import { showMessage } from '../../../componets/common/promptShow'

@Entry
@Component
struct SearchBook {
  @Provide SearchValue: string ="遮天"
  @Provide  SearchStatus: number=0;
  @Provide('searchBookList') books:SearchBook[] = []
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Provide('isSearch') isSearch:boolean = false

  onBackPress(): boolean | void {
    taskSearchBooks.cancelAllTasks()
    return false
  }
  build() {
    Column() {
      //顶部搜索框
      SearchHead();
      if(!this.isSearch && this.books.length <= 0){
        SearchHistory();
      }else if(this.isSearch && this.books.length <= 0){
        SearchRefresh()
      }else {
        SearchDetails({SearchValue:this.SearchValue}).layoutWeight(1)
      }
    }
    .layoutWeight(1)
    .padding({
      bottom:this.bottomRectHeight
    })
  }
}
