/**
 * @author 2008
 * @datetime 2024/7/23 12:01
 * @className: BookBodyContent
 */
import groupTypeComponent from '../../../../componets/group/GroupType'
import IndexSearchType from '../../../../componets/head/IndexSearchType'
import { router } from '@kit.ArkUI'
import confirmDialogExample from '../../../../componets/common/confirmDialog'
import BookContentRefresh from './BookContentRefresh'
import bookHistoryUtils from '../../../../common/utils/BookHistoryUtils'
import { showMessage } from '../../../../componets/common/promptShow'

@Component
export default struct BookBodyContent {
  @Prop index:number
  @Prop currentIndex: number = 0
  @State EXHIBIT_NAMES: string[] = ['列表', '宫格']
  @State GROUP_NAMES: string[] = ['标签', '文件夹']
  @Link EXHIBIT: string
  @Link GROUP: string
  @State searchValue: string = '最近阅读'
  @Link bookTypeNumber:number
  @State title: string = '最近阅读'
  @State groupCoverShow: boolean = false
  @State bookBodyIndex: number = 0
  tabsBookBodyController: TabsController = new TabsController();
  @StorageLink('BOOK_IS_BOOK_HISTORY_REFRESHING') isBookHistoryRefreshing: number = 0
  build() {
    Column() {
      Flex(
        {
          alignContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Scroll() {
          Flex({
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.SpaceBetween
          }) {
            Row({ space: 15 }) {
              IndexSearchType({ title: this.title, searchValue: this.searchValue })
              IndexSearchType({ title: '浏览历史', searchValue: this.searchValue })
                .onClick(() => {
                  this.GROUP = '标签'
                  this.searchValue = '浏览历史'
                })
              if (this.searchValue !== '浏览历史') {
                this.GroupBuilder()
                this.ExhibitBuilder()
                Text('管理')
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/view/bookShelf/Manage/BookManagePage',
                      params: {
                        currentIndex: this.currentIndex,
                        EXHIBIT: this.EXHIBIT,
                        bookTypeNumber: this.bookTypeNumber
                      }
                    })
                  })
                  .fontColor('rgba(0,0,0,0.5)')
                  .fontSize(15)
                  .fontWeight(400)
              }
            }
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)

        if (this.searchValue === '浏览历史') {
          Row() {
            Text('清空')
              .onClick(() => {
                if (this.IndexShelf != null) {
                  this.IndexShelf.open()
                }
              })
          }
        }
      }
      .padding(15)

      Stack() {
        if (this.searchValue !== '浏览历史') {
          groupTypeComponent({
            bookTypeNumber:this.bookTypeNumber,
            currentIndex: this.currentIndex,
            groupCoverShow: this.groupCoverShow,
            GROUP: this.GROUP
          }).zIndex(999)
        }
        Tabs({
          controller:this.tabsBookBodyController,
          index: this.bookBodyIndex
        }){
          TabContent(){
            BookContentRefresh({
              EXHIBIT: this.EXHIBIT,
              GROUP: this.GROUP,
              searchValue: this.searchValue,
              currentIndex: this.currentIndex,
              bookTypeNumber:this.bookTypeNumber
            })
          }
          .align(Alignment.Top)
        }
        .scrollable(false)
        .barWidth(0)
        .barHeight(0)
        .onChange((index) => {
          this.tabsBookBodyController.changeIndex(index)
          this.bookBodyIndex = index
        })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)
    }
  }
  @State delCache: boolean = false
  IndexShelf: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: () => {
        this.onAccept()
      },
      title: '清空',
      delCache: this.delCache
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    // offset: { dx: 0, dy: '-40%' },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25
  })

  onAccept() {
    bookHistoryUtils.deleteAllBookHistory()
    setTimeout(() => {
      this.isBookHistoryRefreshing++
      showMessage('清空成功!')
    },200)
  }


  @Builder
  GroupBuilder() {
    Row({ space: 10 }) {
      ForEach(this.GROUP_NAMES, (item: string) => {
        if (item !== this.GROUP) {
          IndexSearchType({ title: item, searchValue: this.searchValue })
            .onClick(() => {
              this.GROUP = item
            })
          Divider()
            .vertical(true)
            .height(15)
            .color('#989797')
            .opacity(0.5)
            .strokeWidth(1)
        }
      })
    }
  }
  @Builder
  ExhibitBuilder() {
    Row({ space: 10 }) {
      ForEach(this.EXHIBIT_NAMES, (item: string) => {
        if (item !== this.EXHIBIT) {
          IndexSearchType({ title: item, searchValue: this.searchValue })
            .onClick(() => {
              this.EXHIBIT = item
            })
          Divider()
            .vertical(true)
            .height(15)
            .color('#989797')
            .opacity(0.5)
            .strokeWidth(1)
        }
      })
    }
  }
}