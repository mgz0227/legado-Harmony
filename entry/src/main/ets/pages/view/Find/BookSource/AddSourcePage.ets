import Header from '../../../../componets/common/Header';
import { showMessage } from '../../../../componets/common/promptShow';
import { dataItem } from '../../../../componets/dataList/dataItem';
import Help from '../../../../componets/dialog/help';
import { sourceTabs } from '../../../../componets/source/sourceTabs';
import { router } from '@kit.ArkUI';
import { BookSource, BOOK_SOURCE_TYPE, GRADE_TYPE } from '../../../../componets/dataList/BookSource';
import FormItem from '../../../../componets/Form/FormItem';
import { FileHandler } from '../../../../common/utils/FileHandler';
import SourceDebug from './components/SourceDebug';

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
  @State @Watch('onReadChange')readIndex: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State currentIndex: number = 0
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
    weight: 0
  }

  onReadChange() {
    console.log(this.readIndex+'')
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
          .fontColor(0xff6600)
          .backgroundColor('rgba(255, 102, 0, 0.12)')
          .layoutWeight(1)
          .onClick(() => {
            router.back()
          })
          .opacity(1)

        Button('确认')
          .height(40)
          .fontColor(Color.White)
          .backgroundColor(0xff6600)
          .layoutWeight(1)
          .onClick(async  () => {
            if (!this.formModel.bookSourceName || !this.formModel.bookSourceUrl) {
              this.readIndex = 0
              this.currentIndex = 0
              this.controller.changeIndex(0)
              this.scroller.scrollEdge(Edge.Top)
              showMessage('红星标记的内容不能为空')
            }
            const data = await FileHandler.readJsonFile<BookSource[]>(this.pathBookSource) ?? [];
            data.push(this.formModel as BookSource)
            FileHandler.writeJsonFile(this.pathBookSource, JSON.stringify(data))
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
        .selectedColor(0xff6600)
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
              .value(BOOK_SOURCE_TYPE[this.formModel.bookSourceType || 0])
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceType !== undefined ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
                this.formModel.bookSourceType = index
              })
              .backgroundColor('#f5f5f5')
              .layoutWeight(1)
            Row().width(16)
            Select([
              { value: '男频' },
              { value: '女频' },
              { value: '综合' },
              { value: '出版' },
              { value: '下载' },
              { value: '正版' },
              { value: '轻文' },
              { value: '网络' },
              { value: '其他' }
            ])
              .value(this.formModel.bookSourceGroup ?? '男频')
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
              .value(GRADE_TYPE[this.formModel.bookSourceGrade ?? 0])
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceGrade !== undefined ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
                this.formModel.bookSourceGrade = index
              })
              .backgroundColor('#f5f5f5')
              .layoutWeight(1)
            Row().width(16)
            Select([
              { value: '5.0分' },
              { value: '4.0分' },
              { value: '3.0分' },
              { value: '2.0分' },
              { value: '1.0分' },
            ])
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
          value: this.formModel.searchRule?.checkKeyWord,
          label: '校验关键词',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.checkKeyWord = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.bookList,
          label: '书籍列表规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.bookList = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.author,
          label: '作者规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.author = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.kind,
          label: '分类规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.kind = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.wordCount,
          label: '字数规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.wordCount = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.lastChapter,
          label: '最新章节规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.lastChapter = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.intro,
          label: '简介规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.intro = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.coverUrl,
          label: '封面规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.coverUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.searchRule?.bookUrl,
          label: '详情页URL规则',
          onChange: (value: string) => {
            if (this.formModel.searchRule) {
              this.formModel.searchRule.bookUrl = value
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
          value: this.formModel.exploreRule?.bookList,
          label: '书籍列表规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.bookList = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.author,
          label: '作者规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.author = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.kind,
          label: '分类规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.kind = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.wordCount,
          label: '字数规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.wordCount = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.lastChapter,
          label: '最新章节规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.lastChapter = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.intro,
          label: '简介规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.intro = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.coverUrl,
          label: '封面规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.coverUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.exploreRule?.bookUrl,
          label: '详情页URL规则',
          onChange: (value: string) => {
            if (this.formModel.exploreRule) {
              this.formModel.exploreRule.bookUrl = value
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
          value: this.formModel.bookInfoRule?.init,
          label: '预处理规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.init = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.name,
          label: '书名规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.name = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.author,
          label: '作者规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.author = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.kind,
          label: '分类规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.kind = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.wordCount,
          label: '字数规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.wordCount = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.lastChapter,
          label: '最新章节规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.lastChapter = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.intro,
          label: '简介规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.intro = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.coverUrl,
          label: '封面规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.coverUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.tocUrl,
          label: '目录规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.tocUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.canReName,
          label: '允许修改书名作者',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.canReName = value
            }
          }
        });
        FormItem({
          value: this.formModel.bookInfoRule?.downloadUrls,
          label: '下载URL规则',
          onChange: (value: string) => {
            if (this.formModel.bookInfoRule) {
              this.formModel.bookInfoRule.downloadUrls = value
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
          value: this.formModel.tocRule?.preUpdateJs,
          label: '更新之前JS',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.preUpdateJs = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.chapterList,
          label: '目录列表规则',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.chapterList = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.chapterName,
          label: '章节名称规则',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.chapterName = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.chapterUrl,
          label: '章节URL规则',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.chapterUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.formatJs,
          label: '格式化规则',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.formatJs = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.isVolume,
          label: 'Volume 标识',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.isVolume = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.updateTime,
          label: '更新时间',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.updateTime = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.isVip,
          label: 'VIP 标识',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.isVip = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.isPay,
          label: '购买标识',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.isPay = value
            }
          }
        });
        FormItem({
          value: this.formModel.tocRule?.nextTocUrl,
          label: '目录下一页规则',
          onChange: (value: string) => {
            if (this.formModel.tocRule) {
              this.formModel.tocRule.nextTocUrl = value
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
          value: this.formModel.contentRule?.content,
          label: '正文规则',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.content = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.title,
          label: '章节名称规则',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.title = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.nextContentUrl,
          label: '正文下一页URL规则',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.nextContentUrl = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.webJs,
          label: 'WebView JS',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.webJs = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.sourceRegex,
          label: '资源正则',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.sourceRegex = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.replaceRegex,
          label: '替换规则',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.replaceRegex = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.imageStyle,
          label: '图片样式',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.imageStyle = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.imageDecode,
          label: '图片解密',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.imageDecode = value
            }
          }
        });
        FormItem({
          value: this.formModel.contentRule?.payAction,
          label: '购买操作',
          onChange: (value: string) => {
            if (this.formModel.contentRule) {
              this.formModel.contentRule.payAction = value
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
        .backgroundImage(this.currentIndex === index ? $r('app.media.underline') : '')
        .backgroundImageSize(this.currentIndex === index ? { width: '100%', height: 15 } : {})
        .backgroundImagePosition({ y: 16 })
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