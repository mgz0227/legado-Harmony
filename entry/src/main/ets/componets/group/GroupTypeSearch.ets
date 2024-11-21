import BookGroupsDao from '../../database/dao/BookGroupsDao'
import { BookGroups } from '../../database/entities/BookGroups'
import BookType from '../head/BookType'
import groupTypeSearchPanel from './groupTypeSearchPanel'

@Component
export default struct groupTypeSearch {
  @Prop currentIndex: number
  @Link groupCoverShow:boolean
  @State groupList:BookGroups[] = []
  @Link bookTypeNumber:number
  @Link searchBookList:number[]
  @Prop isShowMore:boolean = false
  aboutToAppear(): void {
    this.getGroupList()
  }
  changeRefresh(){
    this.getGroupList()
  }
  getGroupList(){
    BookGroupsDao.search({
      type:this.currentIndex,
    }).then((val)=>{
      this.groupList = val
    })
  }

  build() {
    if (this.groupCoverShow){
      Stack(){
        groupTypeSearchPanel({
          groupCoverShow:this.groupCoverShow,
          showGroupList:this.groupList,
          currentIndex:this.currentIndex,
          searchBookList:this.searchBookList
        })
          .zIndex(9999)
        Rect()
          .height('100%')
          .width('100%')
          .fill('rgba(0, 0, 0, 0.45)')
          .offset({y:100})

      }.alignContent(Alignment.TopStart)
    } else {
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Scroll() {
          Row({ space: 10 }) {
            ForEach(this.groupList,(item:BookGroups)=>{
              if (item.show && item.groupId != 1 && item.groupId != 5) {
                BookType({ title: item.groupName,
                  index:item.groupId,
                  bookTypeNumber:this.bookTypeNumber
                }).onClick(() => {
                  if (item.groupId){
                    this.bookTypeNumber = item.groupId
                  }
                })
              }
            })
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
        Row(){
          Image($r('app.media.more_search')).width(25).height(25)
        }.width(
          '10%'
        ).onClick(()=>{
          this.groupCoverShow = true
        })
        .visibility(!this.isShowMore?Visibility.Visible:Visibility.Hidden)
      }.margin({ left: 15,bottom:10})
    }

  }
}