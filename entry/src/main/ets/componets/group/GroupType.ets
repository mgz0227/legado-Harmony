import BookGroupsDao from '../../database/dao/BookGroupsDao'
import { BookGroups } from '../../database/entities/BookGroups'
import BookType from '../head/BookType'
import groupTypePanel from './groupTypePanel'

@Component
export default struct groupTypeComponent {
  @State globalPositionY: Length = 0
  @Link @Watch('changeRefresh')currentIndex: number
  @Link groupCoverShow:boolean
  @Link GROUP:string
  @State groupList:BookGroups[] = []
  @Link bookTypeNumber:number
  // initGroup:string[] = ['分组','全部','未分组','本地','书单']

  aboutToAppear(): void {
    this.getGroupList()
  }
  changeRefresh(){
    this.getGroupList()
  }
  getGroupList(){
    BookGroupsDao.search({
      type:this.currentIndex
    }).then((val)=>{
      this.groupList = val
    })
  }

  build() {
    if (this.groupCoverShow){
      Stack(){
        groupTypePanel({
          groupCoverShow:this.groupCoverShow,
          showGroupList:this.groupList,
          currentIndex:this.currentIndex
        })
          .zIndex(9999)
        Rect()
          .height('100%')
          .width('100%')
          .fill('rgba(0, 0, 0, 0.45)')
          .offset({y:20})

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
              if (item.show) {
                BookType({ title: item.groupName,
                  index:item.groupId,
                  bookTypeNumber:this.bookTypeNumber
                }).onClick(() => {
                  this.bookTypeNumber = item?.groupId||0
                  if (item.groupName === '分组') {
                    this.GROUP = '文件夹'
                  } else {
                    this.GROUP = '标签'
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
      }.margin({ left: 15,bottom:10})
    }

  }
}