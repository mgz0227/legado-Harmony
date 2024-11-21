import { common } from '@kit.AbilityKit'
import axios, { AxiosResponse } from '@ohos/axios'
import Header from '../../../../componets/common/Header'
import Help from '../../../../componets/dialog/help'
import { IconTitleVo } from '../../../../componetsmodel/IconTitleVo'
import { FileHandler } from '../../../../common/utils/FileHandler'
import ImportCommon from '../../../../componets/import/ImportCommon'
import { showMessage } from '../../../../componets/common/promptShow';
import SourceView from './components/SourceView'
import BookMark from '../../../../componets/head/BookMark'
import { getPasteDataSync, isNetworkUrl, sleep } from '../../../../common/utils/utils'
import { router } from '@kit.ArkUI'
import { BookSource } from '../../../../database/entities/BookSource'

@Entry
@Component
@Preview
struct BookSourcePage {
  titleArray: Array<string> = ['小说', '漫画', '有声书']
  dialogRightData: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_rule_paste'), '粘贴导入'),
    new IconTitleVo($r('app.media.icon_rule_export'), '本地导入'),
    new IconTitleVo($r('app.media.icon_find_shelf'), '新建书源'),
    new IconTitleVo($r('app.media.icon_find_shelf'), '批量管理'),
    new IconTitleVo($r('app.media.icon_rule_help'), '导入帮助')
  ]
  @State currentIndex: number = 0
  tabsController: TabsController = new TabsController();
  @State isShowHelp: boolean = false
  @State @Watch('onChange')isShowImport: boolean = false
  @State sourceList: BookSource[] = []
  @State isBatch: boolean = false
  @State refresh: number = 0

  aboutToAppear() {
  }

  onPageShow() {
    this.refresh += 1
  }

  onChange() {
    if (!this.isShowImport) {
      console.log('TagInfo', 111)
      this.refresh += 1
    }
  }

  async pasteAnalyze() {
    try {
      const url = getPasteDataSync()
      if (!url) {
        showMessage('未获取到粘贴信息，请求默认数据')
        await sleep()
        // return
      }
      // if (!isNetworkUrl(url ?? '')) {
      //   showMessage('复制的链接不正确')
      //   return
      // }
      const res: AxiosResponse = await axios
        .get(url ?? 'https://node.wisdoms.xin/static/file/20240704/sy.json');
      this.sourceList = res.data;
      this.isShowImport = true;
    } catch (err) {
      console.error('错误 ' + err);
    }
  }

  build() {
    Column() {
      // 公共头部、搜索框
      Column() {
        if (!this.isBatch) {
          Header({
            customTitleBuilder: () => {
              this.titleBuilder(this.tabsController)
            },
            dialogRightData: this.dialogRightData,
            dialogRightChange: (index: number) => {
              switch (index) {
                case 0:
                  this.pasteAnalyze()
                  break;
                case 1:
                  let context = getContext(this) as common.Context;
                  FileHandler.pickerFile(context)
                    .then((res: BookSource[]) => {
                      this.sourceList = res;
                      this.isShowImport = true
                    })
                  break;
                case 2:
                  router.pushUrl({ url: 'pages/view/Find/BookSource/AddSourcePage' })
                  break;
                case 3:
                  this.isBatch = true
                  break;
                case 4:
                  this.isShowHelp = true;
                  break;
              }
            }
          })
        }
      }

      // 头部卡片下方视图
      Tabs({
        barPosition: BarPosition.Start,
        controller: this.tabsController
      }) {
        ForEach(this.titleArray, (item: string, index: number) => {
          TabContent() {
            SourceView({ index, isBatch: this.isBatch, refresh: this.refresh })
          }
          .align(Alignment.Top)
        })
      }
      .layoutWeight(1)
      .barWidth(0)
      .barHeight(0)
      .onChange((index) => {
        this.tabsController.changeIndex(index)
        this.currentIndex = index
      })
      .scrollable(this.isBatch ? false : true)

      Flex()
        .bindSheet(this.isShowHelp, this.dialogHelpFuction(), {
          height: '50%',
          showClose: false,
          dragBar: false,
          onDisappear: () => {
            this.isShowHelp = false
          }
        })
      Flex()
        .bindSheet(this.isShowImport, this.dialogImportFunction(), {
          detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE, 200],
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isShowImport = false
          }
        })
    }
    .backgroundColor('#f5f5f5')
  }

  @Builder
  titleBuilder(tabsController: TabsController) {
    List() {
      ListItem() {
        BookMark({
          title: '小说',
          index: 0,
          currentIndex: this.currentIndex,
          isBackground: false
        }).onClick(() => {
          this.currentIndex = 0
          tabsController.changeIndex(0)
          console.log(this.currentIndex + '')
        })
      }

      ListItem() {
        BookMark({
          title: '漫画',
          index: 1,
          currentIndex: this.currentIndex,
          isBackground: false
        }).onClick(() => {
          this.currentIndex = 1
          tabsController.changeIndex(1)
          console.log(this.currentIndex + '')
        })
      }

      ListItem() {
        BookMark({
          title: '有声书',
          index: 2,
          currentIndex: this.currentIndex,
          isBackground: false
        }).onClick(() => {
          this.currentIndex = 2
          tabsController.changeIndex(2)
          console.log(this.currentIndex + '')
        })
      }
    }
    .height(40)
    .scrollBar(BarState.Off)
    .listDirection(Axis.Horizontal)
  }

  @Builder
  dialogHelpFuction() {
    Flex() {
      Help({
        btnClick: () => {
          this.isShowHelp = false
        }
      })
    }
  }

  @Builder
  dialogImportFunction() {
    Flex() {
      ImportCommon({
        sourceList: this.sourceList,
        show: this.isShowImport
      })
    }
  }
}