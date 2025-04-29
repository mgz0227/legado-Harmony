import { router } from '@kit.ArkUI';
import sourceView from './sourceView';
import DownloadSettingDialog from '../../../componets/Reader/DownloadSettingDialog';
import LayoutMoreDialog from '../../../componets/Reader/LayoutMoreDialog';
import { MusicPlayer } from 'ets/componets/Reader/MusicPlayer';
import purificationView from './purificationView';
import { bookParser, readerCore, ReadPageComponent } from '@kit.ReaderKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { NetworkInput } from '../../../componets/Reader/NetworkInput';
import { ClickUtil, PreferencesUtil } from '@pura/harmony-utils';
import { Books } from '../../../database/entities/Books';

interface ParamsObj {
  bookData: Books,
  clickBookCatalogId: number,
}

//2025.4.19 改用官方API16的 ReaderKit
@Entry
@Component
struct ReaderPage3 {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State ReaderPadding: number = 24 // 边距
  @State isShowSetting: boolean = false
  @State isShowDownload: boolean = false
  @State isShowListen: boolean = false
  @State isShowContentSetting: boolean = false
  @State isShowMoreLayout: boolean = false
  @State CurrentLuminance: number = 0 // 亮度
  @State CurrentFontSize: number = 20 // 字号
  @State LineHeight: number = 1.8
  @State ParagraphSpacing: number = -2
  @State isShowSource: boolean = false
  @State isShowPurification: boolean = false
  //书籍解析用数据
  @State bookData: Books = new Books(); //书籍书籍
  @State CatalogList: bookParser.CatalogItem[] = []; //章节数据
  @State @Watch('spineIndexChange') CatalogIndex: number = 0 //当前章节索引
  readerComponentController: readerCore.ReaderComponentController = new readerCore.ReaderComponentController();

  spineIndexChange() {
    this.readerComponentController.startPlay(this.CatalogIndex, '');
  }

  async aboutToAppear() {
    let temp = router.getParams() as ParamsObj
    this.bookData = temp.bookData
    this.init(temp.clickBookCatalogId)
  }

  async init(clickBookCatalogId: number) {

    try { // 当前应用下资源的沙箱路径地址
      let path: string = this.bookData?.bookUrl ?? ''
      let bookParserHandler: bookParser.BookParserHandler = await bookParser.getDefaultHandler(path);
      this.CatalogList = bookParserHandler.getCatalogList();
      if (clickBookCatalogId) { //从上级页面选定的章节定位到对应章节
        this.CatalogList.forEach((item, index) => {
          if (item.catalogId == clickBookCatalogId) {
            this.CatalogIndex = index
          }
        })
      } else { //上级页面没选定，从上次阅读到的章节定位
        // console.log('this.bookData.bookName:' + this.bookData.bookName)
        let lastCatalogIndex = PreferencesUtil.getSync(`BookIndex_${this.bookData.bookName}`, 0)
        if (lastCatalogIndex) {
          this.CatalogIndex = lastCatalogIndex as number ?? 0
        }
      }
      let domPos: string = '';

      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      this.readerComponentController = new readerCore.ReaderComponentController();
      await this.readerComponentController.init(context);

      this.readerComponentController.on('pageShow',
        (data: readerCore.PageDataInfo): void => { // 开发者可在此保存内容分布排版数据，利用data.resourceIndex及data.startDomPos数据调用startPlay接口继续阅读
          hilog.info(0x0000, 'testTag', 'pageshow: data is: ' + JSON.stringify(data));
        })

      this.readerComponentController.registerBookParser(bookParserHandler);

      //开始解析渲染
      this.readerComponentController.startPlay(this.CatalogIndex || 0, domPos);
    } catch (err) {
      hilog.error(0x0000, 'testTag', `failed to startPlay, Code is ${err.code}, message is ${err.message}`);
    }
  }

  aboutToDisappear(): void {
    if (this.bookData) {
      //保存当前章节索引和其它数据
      PreferencesUtil.putSync(`BookIndex_${this.bookData.bookName}`, this.CatalogIndex)
    }
    this.readerComponentController.releaseBook();
  }

  build() {
    Stack() {
      ReadPageComponent({
        controller: this.readerComponentController,
        readerCallback: (err: BusinessError, data: readerCore.ReaderComponentController) => {
          this.readerComponentController = data;
        }
      }).width('100%').height('100%')

      Column() {
        if (this.isShowSetting) { // 阅读器-上方弹框
          Column() {
            Row({ space: 8 }) {
              Image($r("app.media.ic_public_return_left")).width(24).onClick(() => {
                router.back()
              })
              Text(`${this.CatalogList[this.CatalogIndex]?.catalogName ?? ''}`.replace(new RegExp('\\s{1,}', 'g'), ' ')
                .replaceAll('=', '')).layoutWeight(1).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              Row({ space: 16 }) {
                Image($r("app.media.refresh")).width(24).onClick(() => {

                })
                Image($r("app.media.down")).width(24).onClick(() => {
                  this.isShowDownload = true
                }).bindSheet($$this.isShowDownload, this.DownloadDialog(), {
                  height: 500,
                  showClose: false,
                  dragBar: false,
                  blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
                  onDisappear: () => { // this.clickBookType = ''
                  }
                })
                Image($r("app.media.more")).width(24).onClick(() => {

                })
              }
            }.padding({
              top: 12,
              left: 20,
              right: 20,
              bottom: 12
            }).width("100%")

            Row() {
              NetworkInput()
            }.padding({
              top: 8,
              left: 20,
              right: 20,
              bottom: 12
            }).width("100%")

            Divider()
          }.backgroundColor("white").transition(TransitionEffect.move(TransitionEdge.TOP).animation({ duration: 500 }))

          Blank(1).onClick(() => {
            this.isShowSetting = false
          })

          // 阅读器-下方弹框
          Column({ space: 20 }) {
            Divider()

            if (!this.isShowContentSetting) {
              Row() {
                Button({ type: ButtonType.Normal }) {
                  Row({
                    space: 4
                  }) {
                    Image($r("app.media.change_source_icon")).width(16).height(16)
                    Text("换源").fontColor($r('app.string.color_black_65')).font({
                      size: 14, weight: 400
                    })
                  }
                }
                .borderRadius(8)
                .height(40)
                .width("45%")
                .backgroundColor("rgba(0, 0, 0, 0.06)")
                .bindSheet($$this.isShowSource, this.sourceView(), {
                  height: '95%',
                  showClose: false,
                  dragBar: false,
                  maskColor: 'rgba(0,0,0,0.6)',
                  onDisappear: () => {
                    console.log('隐藏')
                  }
                })
                .onClick(() => {
                  this.isShowSource = true
                })

                Button({ type: ButtonType.Normal }) {
                  Row({
                    space: 4
                  }) {
                    Image($r("app.media.purify_icon")).width(16).height(16)
                    Text("净化").fontColor($r('app.string.color_black_65')).font({
                      size: 14, weight: 400
                    })
                  }.bindSheet($$this.isShowPurification, this.purificationView(), {
                    height: '40%',
                    showClose: false,
                    dragBar: false,
                    maskColor: 'rgba(0,0,0,0.6)',
                    onDisappear: () => {
                      console.log('隐藏')
                    }
                  }).onClick(() => {
                    this.isShowPurification = true
                  })
                }.borderRadius(8).height(40).width("45%").backgroundColor("rgba(0, 0, 0, 0.06)")
              }.padding({
                top: 12, left: 24, right: 24
              }).justifyContent(FlexAlign.SpaceBetween).width("100%")

              Row({ space: 16 }) {
                Text("上一章").onClick(() => {
                  if (this.CatalogIndex > 0) {
                    this.CatalogIndex--
                  }
                })

                Slider({
                  value: this.CatalogIndex,
                  max: this.CatalogList.length - 1,
                  min: 0,
                  step: 1,
                  style: SliderStyle.InSet
                })
                  .selectedColor('rgba(0, 0, 0, 0.04)')
                  .blockSize({ width: 30, height: 30 })
                  .layoutWeight(1)
                  .onChange((value) => {
                    ClickUtil.debounce(() => {
                      //防抖
                      this.CatalogIndex = Math.floor(value)
                    }, 500)
                  })

                Text("下一章").onClick(() => {
                  if (this.CatalogIndex < this.CatalogList.length - 1) {
                    this.CatalogIndex++
                  }
                })
              }.padding({
                //todo:临时bottom距离
                left: 24, right: 24, bottom: '10%'
              }).width("100%")
            } else { // 下方-设置
              Column({ space: 24 }) {
                Row({ space: 16 }) {
                  Text('亮度')
                  Slider({
                    value: this.CurrentLuminance,
                    max: 100,
                    min: 0,
                    step: 1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.CurrentLuminance = value
                    })
                  Row() {
                    Text('跟随系统')
                  }
                }

                Row({ space: 16 }) {
                  Text('字号')
                  Slider({
                    value: this.CurrentFontSize,
                    max: 48,
                    min: 12,
                    step: 1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.CurrentFontSize = value
                    })
                  Row() {
                    Button('字体')
                  }
                }

                Row({ space: 16 }) {
                  Text('排版')
                  Button('紧凑').onClick(() => {
                    this.LineHeight = 1.6
                    this.ParagraphSpacing = -4
                  })
                  Button('适中').onClick(() => {
                    this.LineHeight = 1.8
                    this.ParagraphSpacing = -2
                  })
                  Button('宽松').onClick(() => {
                    this.LineHeight = 2
                    this.ParagraphSpacing = 0
                  })
                  Row() {
                    Button('更多').bindSheet($$this.isShowMoreLayout, this.LayoutMoreDialog(), {
                      height: 500,
                      showClose: false,
                      dragBar: false,
                      blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
                      onDisappear: () => { // this.clickBookType = ''
                      }
                    }).onClick(() => {
                      this.isShowMoreLayout = true
                    })
                  }
                }

                Row({ space: 16 }) {
                  Text('背景')
                  Blank(1)
                  Row() {
                    Button('更多')
                  }
                }

                Row({ space: 16 }) {
                  Button('自动阅读')
                  Button('仿真翻页')
                  Button('更多设置')
                }
              }.padding({
                left: 20, right: 20
              })
            }

            //todo:下方功能开发
            /* Grid() {
               GridItem() {
                 Column() {
                   Image($r("app.media.outlined")).width(24)
                   Text("目录")
                 }
               }

               //todo:听书功能开发
               GridItem() {
                 Column() {
                   Image($r("app.media.listen")).width(24)
                   Text("听书")
                 }
               }
               .bindContentCover($$this.isShowListen, this.BookListen(), {
                 modalTransition: ModalTransition.DEFAULT, backgroundColor: "rgba(51, 106, 128, 0.75)"
               }).onClick(() => {
                 this.isShowListen = true
               })

               GridItem() {
                 Column() {
                   Image($r("app.media.night_icon")).width(24)
                   Text("夜间")
                 }
               }

               GridItem() {
                 Column() {
                   Image($r(this.isShowContentSetting ? "app.media.my_center_set_icon_fill" :
                     "app.media.my_center_set_icon")).width(24)
                   Text("设置")
                 }.onClick(() => {
                   this.isShowContentSetting = !this.isShowContentSetting
                 })
               }
             }.padding({
               left: 24, right: 24
             }).columnsTemplate("1fr 1fr 1fr 1fr").width("100%").height(60)*/
          }
          .backgroundColor("white")
          .transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 500 }))
        }
      }.width("100%").height("100%").enabled(this.isShowSetting).padding({
        top: this.topRectHeight,
      })
    }.width('100%').height('100%').onClick(() => { // 支持在此实现点击拉起菜单栏功能
      this.isShowSetting = true
    })
  }

  @Builder
  sourceView() {
    Column() {
      Column() {
        Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
      }.padding({ top: 12 })

      sourceView()
    }
  }

  @Builder
  purificationView() {
    Column() {
      purificationView({
        isShowPurification: this.isShowPurification
      })
    }
  }

  @Builder
  DialogString() {
    Row() {
      Text("喜欢就加入书架吧").lineHeight(22).font({
        size: 14, weight: 400
      }).fontColor($r("app.string.color_black_45"))
    }.margin({
      top: 12, bottom: 16
    })
  }

  @Builder
  BookListen() {
    MusicPlayer({ WidthMinus: 118, isShowListen: this.isShowListen }).width("100%").height("100%")
  }

  @Builder
  DownloadDialog() {
    Column() {
      DownloadSettingDialog({
        isShowDownload: this.isShowDownload, isShowSetting: this.isShowSetting,
      })
    }
  }

  @Builder
  LayoutMoreDialog() {
    LayoutMoreDialog({ ReaderPadding: this.ReaderPadding }).height(500).width("100%")
  }
}
