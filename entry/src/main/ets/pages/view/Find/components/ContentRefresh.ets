import PaddingConstants from '../../../../common/constants/PaddingConstants'
import noSourceFind from '../../../../componets/common/noSourceFind'
import RefreshComponent from '../../../../componets/common/RefreshComponent'
import { BookSource } from '../../../../database/entities/BookSource'
import BookFindContent from './BookFindContent'
import { JSON } from '@kit.ArkTS'
import { ExploreItem } from '../../../../database/types/BookSourceType'
import AllCategory, { GroupExploreList } from './AllCategory'

@Component
export default struct ContentRefresh {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Link @Watch('onRefresh')refreshCount: number
  currentIndex: number = 0
  @Prop bookSource: BookSource = {
    bookSourceUrl: '',
    bookSourceName: '',
    bookSourceType: 0,
    customOrder: 0,
    enabled: false,
    enabledExplore: false,
    lastUpdateTime: 0,
    respondTime: 0,
    weight: 0,
    isTop: false,
    showRecentIcon: false,
    showExplore: true
  }
  @State isRefreshing: boolean = false
  @State RefreshingTitle: string = '松开刷新'
  @State counter: number = 0
  @Link hasExploreUrl: boolean
  @State pageSize: number = 4
  @State pageNum: number = 1
  @State groupExploreList: GroupExploreList[] = []
  @State exploreList: ExploreItem[] = []
  @State showExploreList: ExploreItem[] = []
  @State showSheet: boolean = false

  aboutToAppear() {
    this.getList()
  }

  onRefresh() {
    setTimeout(this.getList, 500)
  }

  getList () {
    try {
      console.info('TagInfo: 书源地址：', this.bookSource.bookSourceUrl)
      console.info('TagInfo: 发现地址：', JSON.stringify(JSON.parse(this.bookSource.exploreUrl ?? '[]')))
      const exploreList = JSON.parse(this.bookSource.exploreUrl ?? '[]') as ExploreItem[]
      this.exploreList = exploreList
      this.pageNum = 1
      this.getShowExploreList()
      this.getGroupExploreList()
    } catch (err) {
      console.info('TagInfo', JSON.stringify(err))
    }
  }

  getGroupExploreList() {
    const groupMap: Record<string, GroupExploreList> = {};
    let currentTitle = ''
    this.exploreList.forEach((item: ExploreItem) => {
      if (!item.title.trim()) {
        return
      }
      if (item.style?.layout_flexBasisPercent === 1 || !currentTitle) {
        let keyTitle = item.title
        if (item.style?.layout_flexBasisPercent !== 1) {
          keyTitle = 'null'
        }
        groupMap[keyTitle] = {
          title: keyTitle,
          url: keyTitle === 'null' ? '' : item.url,
          columnsTemplate: '1fr',
          list: []
        };
        currentTitle = keyTitle
      }

      let columnsTemplate = '1fr'
      const flexBasis = item.style?.layout_flexBasisPercent ?? 0
      if (flexBasis > 0.33 && flexBasis <= 0.5) {
        columnsTemplate += ' 1fr'
      } else if (flexBasis >= 0.25 && flexBasis <= 0.33) {
        columnsTemplate += ' 1fr 1fr'
      } else if (flexBasis < 0.25) {
        columnsTemplate += ' 1fr 1fr 1fr'
      }
      if (groupMap[currentTitle].columnsTemplate !== columnsTemplate) {
        groupMap[currentTitle].columnsTemplate = columnsTemplate
      }
      groupMap[currentTitle].list.push(item);
    })
    this.groupExploreList = Object.values(groupMap);
    console.info('TagInfo:', JSON.stringify(this.groupExploreList))
  }

  getShowExploreList() {
    this.showExploreList = this.exploreList.filter(item =>!!item.url).slice(0, this.pageNum * this.pageSize)
  }

  build() {
    if (!this.bookSource.exploreUrl) {
      noSourceFind({
        setOnclick: () => {
          this.hasExploreUrl = true
        }
      })
        .margin({
          top: PaddingConstants.PADDING_20
        })
    } else {
      Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
        Scroll() {
          Column() {
            ForEach(this.showExploreList, (item: ExploreItem) => {
              BookFindContent({
                currentIndex: this.currentIndex,
                exploreItem: item,
                bookSource: this.bookSource,
                counter: this.counter,
                handleClick: () => {
                  this.showSheet = true
                }
              })
            })
          }
          .padding({ left: 16, right: 16 })
        }
        .padding({ bottom: 16 })
        .scrollBar(BarState.Off)
        .onReachEnd(() => {
          this.pageNum += 1
          this.getShowExploreList()
        })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        if (refreshStatus === 1 || refreshStatus === 2) {
          this.RefreshingTitle = '松开刷新'
        } else {
          this.RefreshingTitle = '刷新中...'
        }
      })
      .height('100%')
      .onRefreshing(() => {
        setTimeout(() => {
          this.pageNum = 1
          this.getShowExploreList()
          this.counter++
          this.isRefreshing = false
        }, 1000)
      })
      .bindSheet(this.showSheet, this.bottomSheet(), {
        detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE, 200],
        dragBar: true,
        showClose: false,
        onDisappear: () => {
          this.showSheet = false
        }
      })
    }
  }

  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }

  @Builder
  bottomSheet() {
    Column() {
      AllCategory({
        showSheet: this.showSheet,
        bookSource: this.bookSource,
        list: this.groupExploreList
      })
    }
  }
}