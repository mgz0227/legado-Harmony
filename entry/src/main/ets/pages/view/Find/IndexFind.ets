import BookMark from '../../../componets/head/BookMark';
import { router } from '@kit.ArkUI';
import dialogTitleFuction from '../../../componets/common/dialogTitleFuction';
import { IconTitleVo } from '../../../componetsmodel/IconTitleVo';
import ImportCommon from '../../../componets/import/ImportCommon';
import { FileHandler } from '../../../common/utils/FileHandler';
import axios, { AxiosResponse } from '@ohos/axios';
import { common } from '@kit.AbilityKit';
import Help from '../../../componets/dialog/help';
import { getPasteDataSync, isNetworkUrl, sleep } from '../../../common/utils/utils';
import { showMessage } from '../../../componets/common/promptShow';
import FindContent from './components/FindContent';
import { BookSource } from '../../../database/entities/BookSource';
import { ThemeItem } from '../../../common/model/Theme';
import { ThemeStorageKey } from '../../../common/constants/Theme';

/**
 * @author 2008
 * @datetime 2024/6/26 23:55
 * @className: RefreshComponent
 * 发现入口
 */
@Component
@Entry
@Preview
export default struct IndexFind {
  private scrollController: Scroller = new Scroller();
  titleArray: Array<string> = ['小说', '漫画', '有声书']
  @State currentIndex: number = 0
  tabsController: TabsController = new TabsController();
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = false
  @State groupCoverShow: boolean = false
  @State bookType: string = '全部'
  @State GROUP: string = '标签'
  @State isShowFuction: boolean = false
  @State isShowHelp: boolean = false
  @State isShowImport: boolean = false
  @State sourceList: BookSource[] = []
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  build() {
    Column() {
      Flex({
        justifyContent: FlexAlign.SpaceBetween
      }) {
        Row() {
          List({ scroller: this.scrollController }) {
            ListItem() {
              BookMark({ title: '小说', index: 0, currentIndex: this.currentIndex }).onClick(() => {
                this.currentIndex = 0
                this.tabsController.changeIndex(0)
                console.log(this.currentIndex + '')
              })
            }

            ListItem() {
              BookMark({ title: '漫画', index: 1, currentIndex: this.currentIndex }).onClick(() => {
                this.currentIndex = 1
                this.tabsController.changeIndex(1)
                console.log(this.currentIndex + '')
              })
            }

            ListItem() {
              BookMark({ title: '有声书', index: 2, currentIndex: this.currentIndex }).onClick(() => {
                this.currentIndex = 2
                this.tabsController.changeIndex(2)
                console.log(this.currentIndex + '')
              })
            }
          }
          .height(40)
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)
        }

        Image($r('app.media.addSubscription')).width(24)
          .bindMenu(this.isShowFuction, this.dialogRightFuction()
            , {
              onDisappear: () => {
                this.isShowFuction = false
              }
            })
          .onClick(() => {
            this.isShowFuction = true
          })
      }
      .padding({ top: this.topRectHeight === 0 ? 30 : this.topRectHeight, left: 20, right: 20 })

      Tabs({
        barPosition: BarPosition.Start,
        controller: this.tabsController
      }) {
        ForEach(this.titleArray, (item: string) => {
          TabContent() {
            FindContent({
              currentIndex: this.currentIndex
            })
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
      .scrollable(this.APP_INDEX_SCROLLABLE)

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
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [[this.theme.mainColor, 0], [this.theme.secondColor, 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
  }

  //'粘贴导入', '本地导入', '书源管理', '导入帮助'
  FIND_Dialog_Right_Fuction: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_rule_paste'), '粘贴导入'),
    new IconTitleVo($r('app.media.icon_rule_export'), '本地导入'),
    new IconTitleVo($r('app.media.icon_find_shelf'), '书源管理'),
    new IconTitleVo($r('app.media.icon_rule_help'), '导入帮助')
  ]

  @Builder
  dialogRightFuction() {
    Column() {
      ForEach(this.FIND_Dialog_Right_Fuction, (item: IconTitleVo, index) => {
        dialogTitleFuction({
          title: item.title,
          icon: item.icon,
          isBorder: this.FIND_Dialog_Right_Fuction.length !== index + 1
        })
          .onClick(() => {
            this.findBindMenuFunction(index)
          })
      })
    }
  }

  async pasteAnalyze() {
    try {
      let url = getPasteDataSync()
      if (!url) {
        showMessage('未获取到粘贴信息')
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
        .get(url ?? 'https://node.wisdoms.xin/static/file/20240704/sy.json');
      this.sourceList = res.data;
      this.isShowImport = true;
    } catch (err) {
      console.error('错误 ' + err);
    }
  }

  findBindMenuFunction(index: number) {
    switch (index) {
      case 0:
        this.pasteAnalyze();
        break;
      case 1:
        let context = getContext(this) as common.Context;
        FileHandler.pickerFile(context).then((res: BookSource[]) => {
          this.sourceList = res;
          this.isShowImport = true
        })
        break;
      case 2:
        router.pushUrl({
          url: 'pages/view/Find/BookSource/Index'
        })
        break;
      case 3:
        this.isShowHelp = true;
        break;
    }
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
      ImportCommon({ sourceList: this.sourceList, show: this.isShowImport })
    }
  }
}