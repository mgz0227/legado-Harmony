import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import ImageConstants from '../../../../common/constants/ImageConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import TextConstants from '../../../../common/constants/TextConstants'
import { ThemeStorageKey } from '../../../../common/constants/Theme'
import { ThemeItem } from '../../../../common/model/Theme'
import { isNetworkUrl } from '../../../../common/utils/utils'
import buttonCommon from '../../../../componets/common/buttonCommon'
import dialogTitleFuction from '../../../../componets/common/dialogTitleFuction'
import { showMessage } from '../../../../componets/common/promptShow'
import Help from '../../../../componets/dialog/help'
import FormItem from '../../../../componets/Form/FormItem'
import rssSourceGroupDao from '../../../../database/dao/rssSourceGroupDao'
import SubscriptionDao from '../../../../database/dao/SubscriptionDao'
import { rssSources, SUBSCRIPTION_GROUP_TYPE } from '../../../../database/entities/rssSources'
import { rssListRule } from '../../../../database/entities/rule/rssListRule'
import { rssWebViewRule } from '../../../../database/entities/rule/rssWebViewRule'
import programDataPreferences from '../../../../preferences/programDataPreferences'
import SourceDebug from '../../Find/BookSource/components/SourceDebug'
import PreviewEffectImage from '../components/PreviewEffectImage'
import RssSourceCheckImage from '../components/RssSourceCheckImage'
import rssSourcesHelp from '../components/rssSourcesHelp'

@Component
export default struct newSources{
  @State isShowHelp: boolean = false
  @State isShowMenu: boolean = false
  hideNewSources:Function = ()=>{}
  @State currentIndex: number = 0
  @Prop isEdit:boolean = false
  private controller: TabsController = new TabsController()
  private headController: TabsController = new TabsController()
  @State readIndex: number = 0


  build() {
    Column(){
      Column(){
        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems:ItemAlign.Center
        }){
          if (this.readIndex===1){
            Image($r('app.media.return_left'))
              .width(25)
              .height(25)
              .onClick(()=>{
                this.headController.changeIndex(0)
              })
          }
          Text(this.readIndex===0?`${this.isEdit?'编辑':'新建'}订阅源`:'调试源')
            .fontSize(FontConstants.FONT_SIZE_18)
            .fontWeight(FontConstants.FONT_WEIGHT_500)
            .lineHeight(26)
            .fontColor($r('app.string.color_black_88'))
            .textAlign(TextAlign.Center)

          Row({
            space:20
          }){
            Row({
              space: 4
            }){
              if (this.readIndex === 0){
                Image($r('app.media.icon_dubug'))
                  .fillColor($r('app.string.color_black_88'))
                  .width(ImageConstants.IMG_WIDTH_20)
                  .height(ImageConstants.IMG_HEIGHT_20)
                Text('调试')
                  .font({
                    size: FontConstants.FONT_SIZE_14,
                    weight: FontConstants.FONT_WEIGHT_400,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_88'))
                  .lineHeight(22)
              }
            }
            .onClick(()=>{
              this.headController.changeIndex(1)
            })
            Image(this.readIndex === 0?$r('app.media.more'):$r('app.media.more_translate'))
              .fillColor($r('app.string.color_black_88'))
              .width(ImageConstants.IMG_WIDTH_24)
              .height(ImageConstants.IMG_HEIGHT_24)
              .bindPopup(
                this.isShowMenu,{
                  builder: this.rightMoreDialogBuilder(),
                  placement: Placement.Bottom,
                  radius:10,
                  enableArrow: false,
                  popupColor:Color.Transparent,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.isShowMenu = false;
                    }
                  },
                transition:!this.isShowMenu?TransitionEffect.asymmetric(
                  TransitionEffect.OPACITY.animation({ duration: 1000, curve: Curve.Ease }).combine(
                    TransitionEffect.translate({ x: 0, y: 1 })), TransitionEffect.IDENTITY)
                  :TransitionEffect.scale({ x: 1, y: 0 }).animation({ duration: 500, curve: Curve.Ease })
              }
              )
              .onClick(() => {
                this.isShowMenu = !this.isShowMenu
              })
          }
        }
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
            SourceDebug() //todo 需要写一个订阅源页面
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
          if (this.formModel.sourceIconIsUrl){
            if (!isNetworkUrl(this.formModel.sourceIcon ?? '')) {
              showMessage('复制的链接不正确')
              return
            }
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

      Flex()
        .bindSheet(this.isShowPresetIcon,this.showPresetIcon(),{
          height: 400,
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowPresetIcon = false
          }
        })
      Flex()
        .bindSheet($$this.isShowHelp, this.dialogHelpFuction(), {
          height: '65%',
          showClose: false,
          dragBar: false,
          onDisappear: () => {
            this.isShowHelp = false
          }
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
    sourceGroup: SUBSCRIPTION_GROUP_TYPE[4],
    enabled: true,
    singleUrl: true,
    showRecentIcon: true,
    customizeTitle:'',
    rssListRule: new rssListRule(),
    rssWebViewRule: new rssWebViewRule(),
  }

  // @State sourceGroupList:SelectOption[] = []
  @State sourceGroupList:SelectOption[] = []

  async getRssSourceList() {
    let group = await rssSourceGroupDao.search();
    group.forEach(item=>{
      this.sourceGroupList.push({
        value: item.rssGroupName
      })
    })
    // let list = programDataPreferences.getRssSourcesListData()
    // //将list存放到sourceGroupList
    // list.forEach((item) => {
    //   this.sourceGroupList.push({
    //     value: item
    //   })
    // })
  }
  aboutToAppear(): void {
    this.getRssSourceList()
    if (!this.formModel.rssListRule) {
      this.formModel.rssListRule = new rssListRule()
    }
    if (!this.formModel.rssWebViewRule) {
      this.formModel.rssWebViewRule = new rssWebViewRule()
    }
    this.readIndex = 0
  }
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

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
              (val:boolean) => {
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
              .selected(this.sourceGroupList.findIndex((item) => {
                return item.value === this.formModel.sourceGroup
              }))
              .value(this.formModel.sourceGroup?this.formModel.sourceGroup:SUBSCRIPTION_GROUP_TYPE[4])
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
                (val:boolean) => {
                  this.formModel.sourceIconIsUrl = val
                })
            }
          }
          if (this.formModel.sourceIconIsUrl){
            FormItem({
              value: this.formModel.sourceIcon,
              label: '图标链接',
              showTitle:false,
              onChange: (value: string) => {
                this.formModel.sourceIcon = value
              }
            })
          } else {
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
              .onClick(() => {
                this.isShowPresetIcon = true
              })
            }
            .margin({ top: 12 })
          }
          if (!this.formModel.sourceIconIsUrl && this.formModel.customizeTitle){
            PreviewEffectImage({
              customizeTitle:this.formModel.customizeTitle,
              sourceIcon:this.formModel.sourceIcon
            })
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
            .selectedColor(this.theme.mainColor)
            .margin({ left: 8 })
            .onChange((val: boolean) => {
              if ( this.formModel.rssWebViewRule) {
                this.formModel.rssWebViewRule.enableJs = val
                showMessage(JSON.stringify(this.formModel.rssWebViewRule.enableJs ))
              }
            })
        }

        Flex({
          justifyContent:FlexAlign.SpaceBetween
        }){
          Text('加载 BaseUrl')
            .fontColor(16)
          Toggle({ type: ToggleType.Switch, isOn: this.formModel.rssWebViewRule?.loadWithBaseUrl })
            .selectedColor(this.theme.mainColor)
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
        // .backgroundImage(this.currentIndex === index ? $r('app.media.underline') : '')
        // .backgroundImageSize(this.currentIndex === index ? { width: '100%', height: 15 } : {})
        // .backgroundImagePosition({ y: 16 })
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
  sourceIconIsUrl(sourceIconIsUrl: boolean, onChange: (_val: boolean) => void) {
    Row() {
      Text('使用链接')

      Toggle({ type: ToggleType.Switch, isOn: sourceIconIsUrl })
        .selectedColor(this.theme.mainColor)
        .margin({ left: 8 })
        .onChange((val: boolean) => {
          onChange(val)
        })
    }
  }
  @State isShowPresetIcon:boolean = false
  @Builder
  showPresetIcon(){
    Grid(){
      GridItem(){
        RssSourceCheckImage({
          onCancel:()=>{
            this.isShowPresetIcon = false
          },
          onSubmit:(value:string, imageString:string)=>{
            this.formModel.customizeTitle = value
            this.formModel.sourceIcon = imageString
            this.isShowPresetIcon = false
          }
        })
      }
    }
  }

  Item_Right_MORE_Dialog_Data: string[] = ['清除Cookie','自动补全','拷贝源','粘贴源','设置原变量','字符串分享','帮助']
  Item_Right_Debug_MORE_Dialog_Data: string[] = ['列表源码','正文源码']

  dialogMoreRightChange(index: number) {
    if (this.readIndex === 0) {
      switch (index) {
        case 0:
          showMessage('清除Cookie')
          break
        case 2:
          showMessage('拷贝源')
          break
        case 3:
          showMessage('粘贴源')
          break
        case 4:
          showMessage('设置原变量')
          break
        case 5:
          showMessage('字符串分享')
          break
        case 6:
          this.isShowHelp = true
          showMessage('帮助')
          break
      }
    } else {
      switch (index) {
        case 0:
          showMessage('列表源码')
          break
        case 1:
          showMessage('正文源码')
          break
      }
    }
  }

  @Builder
  rightMoreDialogBuilder() {
    Column() {
      if (this.readIndex === 0) {
        // 订阅源
        ForEach(this.Item_Right_MORE_Dialog_Data, (item: string, index) => {
          if (index === 1) {
            this.toggleBuilder(item)
          } else {
            dialogTitleFuction({
              title: item,
              isBorder: this.Item_Right_MORE_Dialog_Data.length !== index + 1
            })
              .onClick(() => {
                this.dialogMoreRightChange(index)
              })
          }
        })
      } else {
        // 调试源
        ForEach(this.Item_Right_Debug_MORE_Dialog_Data, (item: string, index) => {
          dialogTitleFuction({
            title: item,
            isBorder: this.Item_Right_Debug_MORE_Dialog_Data.length !== index + 1
          })
            .onClick(() => {
              this.dialogMoreRightChange(index)
            })
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  toggleBuilder(title:string) {
    Column() {
      Row({
        space:5
      }){
        Text(title)
          .font({
            size:FontConstants.FONT_SIZE_14,
            weight:FontConstants.FONT_WEIGHT_400,
            family:CommonConstants.FAMILY_PingFANG
          })
          .fontColor($r('app.string.color_black_88'))
          .lineHeight(TextConstants.TEXT_LINE_HEIGHT_22)
        Toggle({ type: ToggleType.Switch, isOn: this.formModel.autoComplete})
          .selectedColor(this.theme.mainColor)
          .margin({ left: 8 })
          .onChange((val: boolean) => {
            this.formModel.autoComplete = val
          })
      }
      .border({
        style: BorderStyle.Solid,
        width: 1,
        color: '#f5f5f5'
      })
      .padding({
        top:PaddingConstants.PADDING_12,
        bottom:PaddingConstants.PADDING_12})
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .padding({
      left:PaddingConstants.PADDING_20,
      right:PaddingConstants.PADDING_20,})
  }


  @Builder
  dialogHelpFuction() {
    Column() {
      Help({
        title:'源规则帮助',
        btnClick:()=>{
          this.isShowHelp = false
        },
        contentBuilder:this.helpContent,
        isShowContent:false
      })
    }
  }
  @Builder
  helpContent(){
    Column(){
      rssSourcesHelp()
    }
  }
}
