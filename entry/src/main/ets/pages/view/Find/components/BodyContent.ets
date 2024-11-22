/**
 * @author 2008
 * @datetime 2024/7/14 19:57
 * @className: BodyContent
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import { ThemeStorageKey } from '../../../../common/constants/Theme'
import { ThemeItem } from '../../../../common/model/Theme'
import sourceType from '../../../../componets/common/sourceType'
import SourceCommon from '../../../../componets/source/SourceCommon'
import BookSourceDao from '../../../../database/dao/BookSourceDao'
import { BookSource } from '../../../../database/entities/BookSource'
import ContentRefresh from './ContentRefresh'

@Component
export default struct BodyContent {
  titleArray: string[] = ['小说', '漫画', '有声书']
  @State loading: boolean = true
  @State sourceList: BookSource[] = []
  @State currentSourceIndex: number = 0
  @State isShowDialog: boolean = false
  @Prop @Watch('getList')currentIndex: number
  @StorageLink(CommonConstants.HAS_EXPLORE_URL) @Watch('getList') hasExploreUrl?: boolean = undefined
  tabsBodyController: TabsController = new TabsController();
  @StorageLink('refreshCount') @Watch('getList') refreshCount: number = 0
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  aboutToAppear() {
    this.getList()
  }

  onPageShow() {
    this.getList()
  }

  getList() {
    this.loading = true
    BookSourceDao.search({
      type: [0, 2, 1][this.currentIndex],
      enabled: true,
      hasExploreUrl: this.hasExploreUrl,
      showExplore: true
    }).then(bookSources => {
      console.info('TagInfo', JSON.stringify(bookSources.slice(0, 3)))
      this.sourceList = bookSources
      this.loading = false
    }).catch(() => {
      this.loading = false
    })
  }

  build() {
    Column() {
      Flex(
        {
          alignContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        if (this.loading) {
          Row() {
            LoadingProgress()
              .color(this.theme.mainColor)
              .width(30)
            Text('加载中...')
          }
        } else if (this.sourceList.length) {
          Scroll() {
            Row({ space: 20 }) {
              ForEach(this.sourceList, (item: BookSource, index: number) => {
                sourceType({
                  title: item.bookSourceName,
                  active: this.currentSourceIndex === index,
                })
                  .onClick(() => {
                    this.tabsBodyController.changeIndex(index)
                    this.currentSourceIndex = index
                  })
              })
            }
            .padding({ right: 12 })
            .margin({ top: 5, bottom: 5 })
          }
          .scrollBar(BarState.Off)
          .scrollable(ScrollDirection.Horizontal)
        } else {
          Text(`暂无${this.titleArray[this.currentIndex]}源`)
            .fontSize(18)
            .fontWeight(700)
        }

        Row() {
          Image($r('app.media.more_search')).width(24).height(24)
        }
        .width(34)
        .onClick(() => {
          if (this.sourceList.length) {
            this.isShowDialog = true
          }
        })
        .bindSheet(this.isShowDialog, this.sourceCommon(), {
          detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE, 200],
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isShowDialog = false
          }
        })
      }
      .margin({ left: 20, right: 10 })


      if (this.loading) {
        Column() {
          LoadingProgress()
            .color(this.theme.mainColor)
            .width('50%')
          Text('加载中...')
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else if (!this.sourceList.length) {
        Column() {
          Image($r('app.media.find_empty'))
            .width(124)
            .height(120)

          Text(`暂无${this.titleArray[this.currentIndex]}源，点击右上角加号添加吧~`)
            .fontSize(14)
            .fontColor('#73000000')
            .margin({ top: 32 })
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else {
        Tabs({
          controller: this.tabsBodyController
        }) {
          ForEach(this.sourceList, (item: BookSource, index: number) => {
            TabContent() {
              ContentRefresh({
                currentIndex: this.currentIndex,
                bookSource: item,
                hasExploreUrl: this.hasExploreUrl,
                refreshCount: this.refreshCount
              })
            }
            .height('100%')
            .align(Alignment.Top)
          })
        }
        .scrollable(false)
        .barWidth(0)
        .barHeight(0)
        .layoutWeight(1)
        .onChange((index) => {
          this.tabsBodyController.changeIndex(index)
          this.currentSourceIndex = index
        })
      }
    }
    .layoutWeight(1)
  }

  @Builder
  sourceCommon() {
    Column() {
      SourceCommon({
        showDialog: this.isShowDialog,
        currentIndex: this.currentIndex,
        refreshCount: this.refreshCount
      })
    }.height('100%')
  }
}