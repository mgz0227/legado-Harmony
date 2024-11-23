import Header from '../../../../componets/common/Header';
import { showMessage } from '../../../../componets/common/promptShow';
import { dataItem } from '../../../../componets/dataList/dataItem';
import Help from '../../../../componets/dialog/help';
import { sourceTabs } from '../../../../componets/source/sourceTabs';
import { router } from '@kit.ArkUI';
import FormItem from '../../../../componets/Form/FormItem';
import SourceDebug from './components/SourceDebug';
import { JSON } from '@kit.ArkTS';
import BookSourceDao from '../../../../database/dao/BookSourceDao';
import { BookSource, BOOK_SOURCE_TYPE, GRADE_TYPE, SOURCE_GROUP_MAP,
  SOURCE_SCORE_ARR } from '../../../../database/entities/BookSource';
import { ThemeItem } from '../../../../common/model/Theme';
import { ThemeStorageKey } from '../../../../common/constants/Theme';

interface RouteParams {
  id: string,
  type?: number
}

@Entry
@Component
@Preview
struct AddSourcePage {
  titleArray: string[] = ['小说', '漫画', '有声书']
  dialogRightData: string[] = ['搜索源码', '书籍源码', '目录源码', '正文源码', '帮助']
  @StorageProp('pathBookSource') pathBookSource: string = ''
  @State isShowHelp: boolean = false
  @State sourceList: dataItem[] = [
    new dataItem("编辑", 1),
    new dataItem("调试", 2)
  ]
  @State @Watch('onReadChange') readIndex: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State currentIndex: number = 0
  @State isDebug: boolean = false
  private scroller: Scroller = new Scroller()
  private controller: TabsController = new TabsController()
  private headController: TabsController = new TabsController()
  @State formModel: BookSource = {
    bookSourceName: '',
    bookSourceUrl: '',
    bookSourceType: 0,
    bookSourceGroup: '男频',
    bookSourceGrade: 2,
    bookSourceScore: '5.0分',
    enabled: true,
    enabledExplore: true,
    lastUpdateTime: 0,
    respondTime: 180000,
    customOrder: 0,
    weight: 0,
    isTop: false,
    showRecentIcon: false,
    showExplore: true
  }
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  async aboutToAppear() {
    const params = router.getParams() as RouteParams;
    console.log('TagInfo', JSON.stringify(params))
    const localItem = await BookSourceDao.getBookSource(params.id)
    console.info('TagInfo :', JSON.stringify(localItem))
    if (localItem) {
      this.formModel = localItem
    }
    this.isDebug = params.type === 1
    if (params.type === 1) {
      this.readIndex = 1
      this.headController.changeIndex(1)
    }
  }

  onReadChange() {
    console.log(this.readIndex + '')
    this.headController.changeIndex(this.readIndex)
  }

  build() {
    Column() {
      Header({
        customTitleBuilder: () => {
          this.titleBuilder()
        },
        rightIcon: $r('app.media.more_vertical'),
        dialogRightData: this.dialogRightData,
        dialogRightChange: (index: number) => {
          switch (index) {
            case 0:
            case 1:
            case 2:
            case 3:
              showMessage(this.dialogRightData[index]);
              break;
            case 4:
              this.isShowHelp = true;
              break;
          }
        }
      })

      Tabs({ barPosition: BarPosition.Start, index: this.readIndex, controller: this.headController }) {
        TabContent() {
          Column() {
            Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
              TabContent() {
                this.baseForm()
              }
              .tabBar(this.tabBuilder(0, '基本'))

              TabContent() {
                this.searchForm()
              }.tabBar(this.tabBuilder(1, '搜索'))

              TabContent() {
                this.exploreForm()
              }.tabBar(this.tabBuilder(2, '发现'))

              TabContent() {
                this.bookInfoForm()
              }.tabBar(this.tabBuilder(3, '详情'))

              TabContent() {
                this.tocForm()
              }.tabBar(this.tabBuilder(4, '目录'))

              TabContent() {
                this.contextForm()
              }.tabBar(this.tabBuilder(5, '正文'))
            }
            .vertical(false)
            .barMode(BarMode.Fixed)
            .barHeight(48)
            .animationDuration(400)
            .onChange((index: number) => {
              this.currentIndex = index
            })
          }
          .layoutWeight(1)
        }.layoutWeight(1)

        TabContent() {
          SourceDebug()
        }.layoutWeight(1)
      }
      .barWidth(0)
      .barHeight(0)
      .layoutWeight(1)
      .scrollable(false)
      .onChange((index: number) => {
        this.readIndex = index
      })

      Divider()
      Row({ space: 20 }) {
        Button('取消')
          .height(40)
          .fontColor(this.theme.mainColor)
          .backgroundColor(this.theme.secondColor)
          .layoutWeight(1)
          .onClick(() => {
            router.back()
          })
          .opacity(1)

        Button('确认')
          .height(40)
          .fontColor(Color.White)
          .backgroundColor(this.theme.mainColor)
          .layoutWeight(1)
          .onClick(async () => {
            if (!this.formModel.bookSourceName || !this.formModel.bookSourceUrl) {
              this.readIndex = 0
              this.currentIndex = 0
              this.controller.changeIndex(0)
              this.scroller.scrollEdge(Edge.Top)
              showMessage('红星标记的内容不能为空')
            }
            console.info('TagInfo 修改的数据：', JSON.stringify(this.formModel))
            await BookSourceDao.insert(this.formModel)
            showMessage('保存成功')
            setTimeout(() => {
              router.back()
            }, 1000)
          })
          .opacity(1)
      }
      .height(64 + this.bottomRectHeight)
      .padding({ left: 20, right: 20 })

      Flex()
        .bindSheet(this.isShowHelp, this.dialogHelpFuction(), {
          height: '50%',
          showClose: false,
          dragBar: false,
          onDisappear: () => {
            this.isShowHelp = false
          }
        })
    }
  }

  @Builder
  cookieJar(enabledCookieJar: boolean, onChange: (_val: boolean) => void) {
    Row() {
      Text('CookieJar')

      Toggle({ type: ToggleType.Switch, isOn: enabledCookieJar })
        .selectedColor(this.theme.mainColor)
        .margin({ left: 8 })
        .onChange((val: boolean) => {
          onChange(val)
        })
    }
  }

  @Builder
  baseForm() {
    Scroll(this.scroller) {
      Column() {
        FormItem({
          value: this.formModel.bookSourceName,
          label: '名称',
          isLength: true,
          maxLength: 5,
          required: true,
          onChange: (value: string) => {
            if (value?.length >= 6) {
              this.formModel.bookSourceName = value.slice(0, -1)
              return
            }
            this.formModel.bookSourceName = value
          }
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '源URL',
          required: true,
          onChange: (value: string) => {
            this.formModel.bookSourceUrl = value
          },
          customRightBuilder: () => {
            this.cookieJar(
              this.formModel.enabledCookieJar ?? false,
              (val) => {
                this.formModel.enabledCookieJar = val
              })
          }
        });

        Column() {
          Row() {
            Row() {
              Text('源类型及分组')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Select([
              { value: '小说' },
              { value: '漫画' },
              { value: '有声' }
            ])
              .selected([0, 2, 1][this.formModel.bookSourceType])
              .value(BOOK_SOURCE_TYPE[this.formModel.bookSourceType || 0])
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceType !== undefined ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
                this.formModel.bookSourceType = [0, 2, 1][index]
                this.formModel.bookSourceGroup = SOURCE_GROUP_MAP[this.formModel.bookSourceType ?? 0][0]
              })
              .backgroundColor('#f5f5f5')
              .layoutWeight(1)
            Row().width(16)
            Select(
              SOURCE_GROUP_MAP[this.formModel.bookSourceType ?? 0].map(item => ({ value: item } as SelectOption))
            )
              .selected(SOURCE_GROUP_MAP[this.formModel.bookSourceType ?? 0].findIndex(item => item === this.formModel.bookSourceGroup))
              .value(this.formModel.bookSourceGroup ?? SOURCE_GROUP_MAP[this.formModel.bookSourceType ?? 0][0])
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceGroup ? '#E0000000' : '#73000000')
              .onSelect((index: number, text: string) => {
                this.formModel.bookSourceGroup = text
              })
              .backgroundColor('#f5f5f5')
              .layoutWeight(1)
          }
          .margin({ top: 10, bottom: 10 })
        }
        .margin({ top: 12 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Row() {
            Row() {
              Text('满等级及评分')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Select([
              { value: '常规' },
              { value: '优质' },
              { value: '精品' }
            ])
              .selected(this.formModel.bookSourceGrade)
              .value(GRADE_TYPE[this.formModel.bookSourceGrade ?? 0])
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceGrade !== undefined ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
                this.formModel.bookSourceGrade = index
              })
              .backgroundColor('#f5f5f5')
              .layoutWeight(1)
            Row().width(16)
            Select(SOURCE_SCORE_ARR.map(item => ({ value: item } as SelectOption)))
              .selected(SOURCE_SCORE_ARR.findIndex(item => (item === this.formModel.bookSourceScore ?? '5.0分')))
              .value(this.formModel.bookSourceScore ?? '5.0分')
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceScore ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
                this.formModel.bookSourceScore = text
              })
              .backgroundColor('#f5f5f5')
              .layoutWeight(1)
          }
          .margin({ top: 10, bottom: 10 })
        }
        .margin({ top: 12 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        FormItem({
          value: this.formModel.bookSourceComment,
          label: '源注释',
          onChange: (value: string) => {
            this.formModel.bookSourceComment = value
          }
        });

        FormItem({
          value: this.formModel.loginUrl,
          label: '登录URL',
          onChange: (value: string) => {
            this.formModel.loginUrl = value
          }
        });

        FormItem({
          value: this.formModel.loginUi,
          label: '登录UI',
          onChange: (value: string) => {
            this.formModel.loginUi = value
          }
        });

        FormItem({
          value: this.formModel.loginCheckJs,
          label: '登录检测JS',
          onChange: (value: string) => {
            this.formModel.loginCheckJs = value
          }
        });

        FormItem({
          value: this.formModel.coverDecodeJs,
          label: '封面解密',
          onChange: (value: string) => {
            this.formModel.coverDecodeJs = value
          }
        });

        FormItem({
          value: this.formModel.bookUrlPattern,
          label: '书籍URL正则',
          onChange: (value: string) => {
            this.formModel.bookUrlPattern = value
          }
        });

        FormItem({
          value: this.formModel.header,
          label: '请求头',
          onChange: (value: string) => {
            this.formModel.header = value
          }
        });

        FormItem({
          value: this.formModel.variableComment,
          label: '变量说明',
          onChange: (value: string) => {
            this.formModel.variableComment = value
          }
        });

        FormItem({
          value: this.formModel.concurrentRate,
          label: '并发率',
          onChange: (value: string) => {
            this.formModel.concurrentRate = value
          }
        });

        FormItem({
          value: this.formModel.jsLib,
          label: 'jsLib',
          onChange: (value: string) => {
            this.formModel.jsLib = value
          }
        });
      }.width('100%')
    }.height('100%').scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  searchForm() {
    Scroll() {
      Column() {
        FormItem({
          value: this.formModel.searchUrl,
          label: '搜索地址',
          onChange: (value: string) => {
            this.formModel.searchUrl = value
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.checkKeyWord,
          label: '校验关键词',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.checkKeyWord = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.bookList,
          label: '书籍列表规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.bookList = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.author,
          label: '作者规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.author = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.kind,
          label: '分类规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.kind = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.wordCount,
          label: '字数规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.wordCount = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.lastChapter,
          label: '最新章节规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.lastChapter = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.intro,
          label: '简介规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.intro = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.coverUrl,
          label: '封面规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.coverUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleSearch?.bookUrl,
          label: '详情页URL规则',
          onChange: (value: string) => {
            if (this.formModel.ruleSearch) {
              this.formModel.ruleSearch.bookUrl = value
            }
          }
        });
      }.width('100%')
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  exploreForm() {
    Scroll() {
      Column() {
        FormItem({
          value: this.formModel.exploreUrl,
          label: '发现地址规则',
          onChange: (value: string) => {
            this.formModel.exploreUrl = value
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.bookList,
          label: '书籍列表规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.bookList = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.author,
          label: '作者规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.author = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.kind,
          label: '分类规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.kind = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.wordCount,
          label: '字数规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.wordCount = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.lastChapter,
          label: '最新章节规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.lastChapter = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.intro,
          label: '简介规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.intro = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.coverUrl,
          label: '封面规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.coverUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleExplore?.bookUrl,
          label: '详情页URL规则',
          onChange: (value: string) => {
            if (this.formModel.ruleExplore) {
              this.formModel.ruleExplore.bookUrl = value
            }
          }
        });
      }.width('100%')
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  bookInfoForm() {
    Scroll() {
      Column() {
        FormItem({
          value: this.formModel.ruleBookInfo?.init,
          label: '预处理规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.init = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.author,
          label: '作者规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.author = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.kind,
          label: '分类规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.kind = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.wordCount,
          label: '字数规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.wordCount = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.lastChapter,
          label: '最新章节规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.lastChapter = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.intro,
          label: '简介规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.intro = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.coverUrl,
          label: '封面规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.coverUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.tocUrl,
          label: '目录规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.tocUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.canReName,
          label: '允许修改书名作者',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.canReName = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleBookInfo?.downloadUrls,
          label: '下载URL规则',
          onChange: (value: string) => {
            if (this.formModel.ruleBookInfo) {
              this.formModel.ruleBookInfo.downloadUrls = value
            }
          }
        });
      }.width('100%')
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  tocForm() {
    Scroll() {
      Column() {
        FormItem({
          value: this.formModel.ruleToc?.preUpdateJs,
          label: '更新之前JS',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.preUpdateJs = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.chapterList,
          label: '目录列表规则',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.chapterList = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.chapterName,
          label: '章节名称规则',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.chapterName = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.chapterUrl,
          label: '章节URL规则',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.chapterUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.formatJs,
          label: '格式化规则',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.formatJs = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.isVolume,
          label: 'Volume 标识',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.isVolume = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.updateTime,
          label: '更新时间',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.updateTime = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.isVip,
          label: 'VIP 标识',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.isVip = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.isPay,
          label: '购买标识',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.isPay = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleToc?.nextTocUrl,
          label: '目录下一页规则',
          onChange: (value: string) => {
            if (this.formModel.ruleToc) {
              this.formModel.ruleToc.nextTocUrl = value
            }
          }
        });
      }.width('100%')
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  contextForm() {
    Scroll() {
      Column() {
        FormItem({
          value: this.formModel.ruleContent?.content,
          label: '正文规则',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.content = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.title,
          label: '章节名称规则',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.title = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.nextContentUrl,
          label: '正文下一页URL规则',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.nextContentUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.webJs,
          label: 'WebView JS',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.webJs = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.sourceRegex,
          label: '资源正则',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.sourceRegex = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.replaceRegex,
          label: '替换规则',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.replaceRegex = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.imageStyle,
          label: '图片样式',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.imageStyle = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.imageDecode,
          label: '图片解密',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.imageDecode = value
            }
          }
        });
        FormItem({
          value: this.formModel.ruleContent?.payAction,
          label: '购买操作',
          onChange: (value: string) => {
            if (this.formModel.ruleContent) {
              this.formModel.ruleContent.payAction = value
            }
          }
        });
      }.width('100%')
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 700 : 400)
        .lineHeight(24)
        // .backgroundImage(this.currentIndex === index ? $r('app.media.underline') : '')
        // .backgroundImageSize(this.currentIndex === index ? { width: '100%', height: 15 } : {})
        // .backgroundImagePosition({ y: 16 })
    }
  }

  @Builder
  titleBuilder() {
    sourceTabs({
      sourceList: this.sourceList,
      read_index: this.readIndex,
      marginY: 0
    })
      .width('50%')
  }

  @Builder
  dialogHelpFuction() {
    Flex() {
      Help({
        title: '新增帮助',
        btnClick: () => {
          this.isShowHelp = false
        }
      })
    }
  }
}