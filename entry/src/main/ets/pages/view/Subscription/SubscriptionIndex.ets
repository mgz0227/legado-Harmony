/**
 * @author 2008
 * @datetime 2024/7/11 21:33
 * @className: Subscription
 * 新版订阅页面
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import ImageConstants from '../../../common/constants/ImageConstants'
import PaddingConstants from '../../../common/constants/PaddingConstants'
import { IconTitleVo } from '../../../componetsmodel/IconTitleVo'
import { router } from '@kit.ArkUI'
import SubscriptionContent from './components/SubscriptionContent'
import { showMessage } from '../../../componets/common/promptShow'
import { getPasteDataSync, isNetworkUrl, sleep } from '../../../common/utils/utils'
import axios, { AxiosResponse } from '@ohos/axios'
import { rssGroupList, rssSources } from '../../../database/entities/rssSources'
import SubscriptionImport from '../../../componets/import/SubscriptionImport'
import subscriptionDao from '../../../database/dao/SubscriptionDao'
import dialogNewSources from './RssSources/dialogNewSources'
import RssSourcesHistory from './components/RssSourcesHistory'
import rssSourcesHistoryDao from '../../../database/dao/RssSourcesHistoryDao'
import { rssSourcesHistory } from '../../../database/entities/rssSourcesHistory'
import { FileHandler } from 'ets/common/utils/FileHandler'
import { ThemeItem } from '../../../common/model/Theme'
import { ThemeStorageKey } from '../../../common/constants/Theme'

@Component
export default struct SubscriptionIndex {
  @State isShowImport: boolean = false
  @State isShowNewSources: boolean = false
  @Prop @Watch('currentTabIndexChange') currentTabIndex: number
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink(CommonConstants.RSS_SOURCES_REFRESHING) @Watch('getList') refreshing: number = 0
  @State
  moreList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_rule_paste'), '粘贴导入'),
    new IconTitleVo($r('app.media.icon_rule_export'), '本地导入'),
    new IconTitleVo($r('app.media.icon_rule_add'), '新建订阅'),
    new IconTitleVo($r('app.media.icon_rule_batch'), '批量管理'),
  ]
  @State RecentlyUsed: rssSourcesHistory[] = []
  @State loading: boolean = false
  @State subscriptionList: rssSources[] = []
  @State rssSourcesList: rssSources[] = []
  @State groupList: rssGroupList[] = []
  @State batchEdit: boolean = false
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  //刷新
  refresh = () => {
    this.resetState()
    this.getList()
    setTimeout(() => {
      rssSourcesHistoryDao.search().then((rssSourcesHistoryList: rssSourcesHistory[]) => {
        this.RecentlyUsed = rssSourcesHistoryList
      })
    }, 100)
  }

  currentTabIndexChange() {
    this.refresh()
  }

  resetState() {
    this.subscriptionList = []
    this.groupList = []
  }

  getList() {
    subscriptionDao.search().then(data => {
      const rssSources = data ?? []
      console.info('TagInfo', JSON.stringify(rssSources.slice(0, 3)))
      this.rssSourcesList = rssSources
      this.getGroupList()
    }).catch(() => {

    })
  }

  getGroupList() {
    const groupMap: Record<string, rssGroupList> = {};
    this.rssSourcesList.forEach((item: rssSources) => {
      const title = item.sourceGroup;
      if (title) {
        // 如果groupMap中还没有这个group，则创建一个新的GroupList对象
        if (!groupMap[title]) {
          groupMap[title] = { title: title, list: [] };
        }
        // 向当前group的list中添加BookSource对象
        groupMap[title].list.push(item);
      }

    })
    this.groupList = Object.values(groupMap)
  }

  build() {
    Column() {
      Column() {
        //搜索Start
        Flex(
          {
            direction: FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.SpaceBetween
          }
        ) {
          Row({
            space: CommonConstants.SPACE_16
          }) {
            if (this.batchEdit === false) {
              Image($r('app.media.icon_subscription_index'))
                .width(CommonConstants.COMMON_WIDTH_45_36)
                .height(CommonConstants.COMMON_HEIGHT_21_6)
              Search({ placeholder: '搜索订阅', icon: "/common/images/search.svg" })
                .layoutWeight(1)
                .height(CommonConstants.COMMON_HEIGHT_40)
                .backgroundColor(Color.White)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/view/Subscription/components/SubscriptionSearch'
                  })
                })
                .focusOnTouch(false) //不可获取焦点

              Image($r('app.media.addSubscription'))
                .width(ImageConstants.IMG_WIDTH_24)
                .height(ImageConstants.IMG_HEIGHT_24)
                .bindMenu(this.MenuBuilder)
            } else {
              Text('全选')
              Blank(1)
              Text(`已选2项`)
              Blank(1)
              Text('完成').onClick(() => {
                this.batchEdit = false
                getContext(this).eventHub.emit('SubscriptionBatchEdit', true);
              })
            }
          }
          .width('100%')
        }
        .height('8%')

        //搜索End
        //最近使用Start
        if (this.batchEdit === false) {
          RssSourcesHistory({
            RecentlyUsed: this.RecentlyUsed
          })
        }

        if (this.loading) {
          Column() {
            LoadingProgress()
              .color(this.theme.mainColor)
              .width('50%')
            Text('加载中...')
          }
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
        } else if (!this.groupList.length) {
          SubscriptionContent({
            subscriptionTitle: '收藏',
            showAddDialog: () => {
              this.isShowNewSources = true
            }
          })
        } else {
          Scroll() {
            Column() {
              ForEach(this.groupList, (item: rssGroupList) => {
                SubscriptionContent({
                  subscriptionTitle: item.title,
                  contentList: item.list,
                  refresh: this.refresh
                })
              })
            }
          }
          .align(Alignment.Top)
          .padding({ bottom: 20 })
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .scrollable(ScrollDirection.Vertical)
        }
        Blank(1)
      }
      .padding({
        top: this.topRectHeight,
        left: PaddingConstants.PADDING_20,
        right: PaddingConstants.PADDING_20
      })
      .layoutWeight(1)

      if (this.batchEdit) {
        Grid() {
          GridItem() {
            Column({ space: 4 }) {
              Image($r('app.media.folder'))
                .height(24)
                .fillColor(Color.Black) // 黑色好像渲染不上去

              Text("移动至")
                .fontSize(10)
                .lineHeight(18)
                .fontColor('rgba(0, 0, 0, 0.88)')
            }
            .onClick(() => {
              showMessage('功能开发中,暂未开放')
            })
          }

          GridItem() {
            Column({ space: 4 }) {
              Image($r('app.media.edit_share'))
                .height(24)

              Text("分享")
                .fontSize(10)
                .lineHeight(18)
                .fontColor('rgba(0, 0, 0, 0.88)')
            }
            .onClick(() => {
              showMessage('功能开发中,暂未开放')
            })
          }

          GridItem() {
            Column({ space: 4 }) {
              Image($r('app.media.export_1'))
                .height(24)

              Text("导出")
                .fontSize(10)
                .lineHeight(18)
                .fontColor('rgba(0, 0, 0, 0.88)')
            }
            .onClick(() => {
              showMessage('功能开发中,暂未开放')
            })
          }

          GridItem() {
            Column({ space: 4 }) {
              Image($r('app.media.delete'))
                .height(24)

              Text("删除")
                .fontSize(10)
                .lineHeight(18)
                .fontColor('rgba(0, 0, 0, 0.88)')
            }
            .onClick(() => {
              showMessage('功能开发中,暂未开放')
            })
          }
        }
        .height(68)
        .width("100%")
        .columnsTemplate("1fr 1fr 1fr 1fr")
        .backgroundColor('white')
        .padding({
          top: 12,
          bottom: 10
        })
      }

      Flex()
        .bindSheet($$this.isShowImport, this.dialogImportFunction(), {
          detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE, 200],
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isShowImport = false
          }
        })

      Flex()
        .bindSheet($$this.isShowNewSources, this.dialogNewSourcesFunction(), {
          height: 200,
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isShowNewSources = false
          }
        })
    }
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [[this.theme.mainColor, 0], [this.theme.secondColor, 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .height('100%')
  }

  @Builder
  dialogImportFunction() {
    Flex() {
      SubscriptionImport({
        subscriptionList: this.subscriptionList
      , show: this.isShowImport
      }).onDisAppear(() => {
        this.refresh()
      })
    }
  }

  @Builder
  dialogNewSourcesFunction() {
    Column() {
      dialogNewSources({
        btnClick: () => {
          this.isShowNewSources = false
        }
      }).onDisAppear(() => {
        this.refresh()
      })

    }
  }

  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column }) {
      ForEach(this.moreList, (item: IconTitleVo, index) => {
        Column() {
          Row() {
            Image(item.icon)
              .width(24)
              .height(24)
              .margin({
                right: 5
              })
            Text(`${item.title}`).fontSize(14)
          }
          .height(40)
          .justifyContent(FlexAlign.Center)
          .align(Alignment.Center)
          .onClick(() => {
            this.MenuOnclick(index)
          })

          if (index !== 5) {
            Divider()
          }
        }
        .padding(5)
        .height(40)
        .margin({ bottom: 20 })
      })
    }
    .width(100)
  }

  async MenuOnclick(value: number | string) {
    switch (value) {
      case 0:
        // 粘贴导入
        this.pasteAnalyze();
        break;
      case 1:
        // 本地导入
        showMessage('请选择本地json文件导入')
        this.localImport()
        break
      case 2:
        this.isShowNewSources = true
        break;
      case 3:
        this.batchEdit = true
        getContext(this).eventHub.emit('SubscriptionBatchEdit', false);
        break
    }
  }

  async localImport() {
    let FileResult = await FileHandler.documentPickerFile(1, ['.json'])
    FileHandler.ReadJSONFile(FileResult[0]).then(result => {
      // console.log('result:' + result)
      this.subscriptionList = JSON.parse(result) as rssSources[]
      this.isShowImport = true;
    })
  }

  async pasteAnalyze() {
    try {
      let url = getPasteDataSync()
      if (!url) {
        showMessage('未获取到粘贴信息，请求默认数据')
        await sleep()
        // return
      }
      if (!isNetworkUrl(url ?? '')) {
        showMessage('复制的链接不正确')
        await sleep()
        url = undefined
        // return
      }
      const res: AxiosResponse = await axios
        .get(url ?? 'http://yuedu.miaogongzi.net/shuyuan/miaogongziDY.json');
      console.log('res', JSON.stringify(res))
      this.subscriptionList = res.data;
      this.isShowImport = true;
    } catch (err) {
      console.error('错误 ' + err);
    }
  }
}