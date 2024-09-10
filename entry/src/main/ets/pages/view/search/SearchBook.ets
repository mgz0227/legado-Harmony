
import { SearchHead } from '../../../componets/search/SearchHead'
import { SearchHistory } from '../../../componets/search/SearchHistory'
import { SearchDetails } from '../../../componets/search/SearchDetails'
import { SearchRefresh } from '../../../componets/search/SearchRefresh'
import taskSearchBooks from '../../../common/model/taskSearchBook'
import { router } from '@kit.ArkUI'

interface routeParams {
  searchValue: string,

}
@Entry
@Component
struct SearchBook {
  @Provide SearchValue: string =""
  @Provide  SearchStatus: number=0;
  @Provide('searchBookList') books:SearchBook[] = []
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Provide('isSearch') isSearch:boolean = false
  aboutToAppear(): void {
    let search = router.getParams() as routeParams
    if (search) {
      this.SearchValue = search.searchValue??''
    }
  }
  onBackPress(): boolean | void {
    if (this.isSearch) {
      taskSearchBooks.cancelAllTasks()
    }
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
