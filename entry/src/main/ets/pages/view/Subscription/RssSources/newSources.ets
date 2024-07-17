/**
 * @author 2008
 * @datetime 2024/7/16 18:13
 * @className: newSources
 * 新建/修改订阅源
 */
import FontConstants from '../../../../common/constants/FontConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import buttonCommon from '../../../../componets/common/buttonCommon'
import { showMessage } from '../../../../componets/common/promptShow'
import FormItem from '../../../../componets/Form/FormItem'
import SubscriptionDao from '../../../../database/dao/SubscriptionDao'
import { rssSources, SUBSCRIPTION_GROUP_TYPE } from '../../../../database/entities/rssSources'
import programDataPreferences from '../../../../preferences/programDataPreferences'

@Component
export default struct newSources{
  hideNewSources:Function = ()=>{}
  @State currentIndex: number = 0
  @Prop isEdit:boolean = false
  private controller: TabsController = new TabsController()
  private headController: TabsController = new TabsController()
  @State @Watch('onReadChange') readIndex: number = 0
  onReadChange() {
    console.log(this.readIndex + '')
    this.headController.changeIndex(this.readIndex)
  }


  build() {
    Column(){
      Column(){
        Text(`${this.isEdit?'编辑':'新建'}订阅源`)
          .fontSize(FontConstants.FONT_SIZE_16)
          .fontWeight(FontConstants.FONT_WEIGHT_500)
          .lineHeight(24)
          .fontColor($r('app.string.color_black_88'))
          .textAlign(TextAlign.Center)
        Tabs({ barPosition: BarPosition.Start, index: this.readIndex, controller: this.headController }) {
          TabContent() {
            Column() {
              Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
                TabContent() {
                  this.baseForm()
                }
                .tabBar(this.tabBuilder(0, '基本'))

                TabContent() {
                  this.rssListForm()
                }.tabBar(this.tabBuilder(1, '列表'))

                TabContent() {
                  this.rssWebViewForm()
                }.tabBar(this.tabBuilder(2, 'WEB VIEW'))

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
            // SourceDebug()
          }.layoutWeight(1)
        }
        .barWidth(0)
        .barHeight(0)
        .layoutWeight(1)
        .scrollable(false)
        .onChange((index: number) => {
          this.readIndex = index
        })
      }
      .layoutWeight(1)
      .padding(PaddingConstants.PADDING_20)
      Divider()
      buttonCommon({
        cancel: ()=>{
          this.hideNewSources()
        },
        confirm: async ()=>{
          if (!this.formModel.sourceName || !this.formModel.sourceUrl) {
            this.scroller.scrollEdge(Edge.Top)
            this.readIndex = 0
            this.currentIndex = 0
            this.controller.changeIndex(0)
            showMessage('红星标记的内容不能为空')
            return
          }
          if(this.formModel.sourceIcon === ''){
            this.formModel.sourceIcon = 'app.media.icon'
          }
          let isInsert = await SubscriptionDao.insert(this.formModel)
          if (isInsert) {
            showMessage('保存成功')
          } else {
            showMessage('保存失败')
          }
          setTimeout(() => {
            this.hideNewSources()
          },1000)
        },
      })
    }
  }
  private scroller: Scroller = new Scroller()
  @Prop formModel: rssSources = {
    sourceName: '',
    sourceUrl: '',
    sourceIcon: '',
    sourceType: 1,
    sourceIconIsUrl: false,
    enabledCookieJar: false,
    lastUpdateTime: new Date().getTime(),
    customOrder: 0,
    autoComplete: false,
    sourceGroup: SUBSCRIPTION_GROUP_TYPE[0],
    enabled: true,
    singleUrl: true
  }

  @State sourceGroupList:SelectOption[] = []
  getRssSourceList() {
    let list = programDataPreferences.getRssSourcesListData()
    //将list存放到sourceGroupList
    list.forEach((item) => {
      this.sourceGroupList.push({
        value: item
      })
    })
  }
  aboutToAppear(): void {
    this.getRssSourceList()
  }

  @Builder
  baseForm() {
    Scroll(this.scroller) {
      Column() {
        FormItem({
          value: this.formModel.sourceName,
          label: '名称',
          isLength: true,
          maxLength: 5,
          required: true,
          onChange: (value: string) => {
            if (value?.length >= 6) {
              this.formModel.sourceName = value.slice(0, -1)
              return
            }
            this.formModel.sourceName = value
          }
        });

        FormItem({
          value: this.formModel.sourceUrl,
          label: '源URL',
          required: true,
          onChange: (value: string) => {
            this.formModel.sourceUrl = value
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
              Text('分组')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Select(this.sourceGroupList)
              .value(this.formModel.sourceGroup.length === 0?SUBSCRIPTION_GROUP_TYPE[0]:this.formModel.sourceGroup)
              .borderRadius(4)
              .fontColor(this.formModel.sourceGroup !== undefined ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
                if (text) {
                  this.formModel.sourceGroup = text
                }
              })
              .backgroundColor($r('app.string.color_black_6'))
              .layoutWeight(1)
          }
          .margin({ top: 10, bottom: 10 })
        }
        .margin({ top: 12 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Flex({
            justifyContent:FlexAlign.SpaceBetween
          }) {
            Row() {
              Text('图标')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)

            Row(){
              this.sourceIconIsUrl(
                this.formModel.sourceIconIsUrl ?? false,
                (val) => {
                  this.formModel.sourceIconIsUrl = val
                })
            }
          }
          Flex({
            justifyContent:FlexAlign.SpaceBetween
          }) {
            Row() {
              Text('选择本地图片')
                .textAlign(TextAlign.Center)
                .fontSize(16)
                .padding({ top: 8,bottom:8,right:12,left:12 })
            }
            .justifyContent(FlexAlign.Center)
            .width('48%')
            .backgroundColor($r('app.string.color_black_6'))

            Row() {
              Text('预设图标')
                .textAlign(TextAlign.Center)
                .fontSize(16)
                .padding({ top: 8,bottom:8,right:12,left:12 })
            }
            .justifyContent(FlexAlign.Center)
            .width('48%')
            .backgroundColor($r('app.string.color_black_6'))
          }
        }
        .margin({ top: 12,left:20,right:20 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        FormItem({
          value: this.formModel.sourceComment,
          label: '源注释',
          onChange: (value: string) => {
            this.formModel.sourceComment = value
          }
        });

        FormItem({
          value: this.formModel.sortUrl,
          label: '分类URL',
          onChange: (value: string) => {
            this.formModel.sortUrl = value
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
          label: '登录检查JS',
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
      }
    }
    .align(Alignment.Top)
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  rssListForm() {
    Scroll() {
      Column() {
        FormItem({
          value: this.formModel.rssListRule?.ruleArticles,
          label: '列表规则',
          onChange: (value: string) => {
            if (this.formModel.rssListRule) {
              this.formModel.rssListRule.ruleArticles = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssListRule?.ruleNextPage,
          label: '列表下一页规则',
          onChange: (value: string) => {
            if (this.formModel.rssListRule) {
              this.formModel.rssListRule.ruleNextPage = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssListRule?.ruleTitle,
          label: '标题规则',
          onChange: (value: string) => {
            if (this.formModel.rssListRule) {
              this.formModel.rssListRule.ruleTitle = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssListRule?.rulePubDate,
          label: '时间规则',
          onChange: (value: string) => {
            if (this.formModel.rssListRule) {
              this.formModel.rssListRule.rulePubDate = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssListRule?.ruleDescription,
          label: '描述规则',
          onChange: (value: string) => {
            if (this.formModel.rssListRule) {
              this.formModel.rssListRule.ruleDescription = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssListRule?.ruleImage,
          label: '图片规则',
          onChange: (value: string) => {
            if (this.formModel.rssListRule) {
              this.formModel.rssListRule.ruleImage = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssListRule?.ruleLink,
          label: '链接规则',
          onChange: (value: string) => {
            if (this.formModel.rssListRule) {
              this.formModel.rssListRule.ruleLink = value
            }
          }
        });
      }
    }
    .align(Alignment.Top)
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  rssWebViewForm() {
    Scroll() {
      Column() {
        Flex({
          justifyContent:FlexAlign.SpaceBetween
        }){
          Text('启用JavaScript')
            .fontColor(16)
          Toggle({ type: ToggleType.Switch, isOn: this.formModel.rssWebViewRule?.enableJs })
            .selectedColor(0xff6600)
            .margin({ left: 8 })
            .onChange((val: boolean) => {
              if ( this.formModel.rssWebViewRule) {
                this.formModel.rssWebViewRule.enableJs = val
              }
            })
        }

        Flex({
          justifyContent:FlexAlign.SpaceBetween
        }){
          Text('加载 BaseUrl')
            .fontColor(16)
          Toggle({ type: ToggleType.Switch, isOn: this.formModel.rssWebViewRule?.loadWithBaseUrl })
            .selectedColor(0xff6600)
            .margin({ left: 8 })
            .onChange((val: boolean) => {
              if ( this.formModel.rssWebViewRule) {
                this.formModel.rssWebViewRule.loadWithBaseUrl = val
              }
            })
        }

        FormItem({
          value: this.formModel.rssWebViewRule?.ruleContent,
          label: '内容规则',
          onChange: (value: string) => {
            if (this.formModel.rssWebViewRule) {
              this.formModel.rssWebViewRule.ruleContent = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssWebViewRule?.style,
          label: '样式规则',
          onChange: (value: string) => {
            if (this.formModel.rssWebViewRule) {
              this.formModel.rssWebViewRule.style = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssWebViewRule?.injectJs,
          label: '注入规则',
          onChange: (value: string) => {
            if (this.formModel.rssWebViewRule) {
              this.formModel.rssWebViewRule.injectJs = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssWebViewRule?.contentWhitelist,
          label: '白名单',
          onChange: (value: string) => {
            if (this.formModel.rssWebViewRule) {
              this.formModel.rssWebViewRule.contentWhitelist = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssWebViewRule?.contentBlacklist,
          label: '黑名单',
          onChange: (value: string) => {
            if (this.formModel.rssWebViewRule) {
              this.formModel.rssWebViewRule.contentBlacklist = value
            }
          }
        });
        FormItem({
          value: this.formModel.rssWebViewRule?.shouldOverrideUrlLoading,
          label: '链接拦截',
          onChange: (value: string) => {
            if (this.formModel.rssWebViewRule) {
              this.formModel.rssWebViewRule.shouldOverrideUrlLoading = value
            }
          }
        });
      }
    }
    .align(Alignment.Top)
    .layoutWeight(1)
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
  sourceIconIsUrl(sourceIconIsUrl: boolean, onChange: (_val: boolean) => void) {
    Row() {
      Text('使用链接')

      Toggle({ type: ToggleType.Switch, isOn: sourceIconIsUrl })
        .selectedColor(0xff6600)
        .margin({ left: 8 })
        .onChange((val: boolean) => {
          onChange(val)
        })
    }
  }
}