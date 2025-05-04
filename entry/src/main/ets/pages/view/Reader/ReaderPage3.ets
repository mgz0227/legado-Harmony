import { display, router } from '@kit.ArkUI';
import sourceView from './sourceView';
import DownloadSettingDialog from '../../../componets/Reader/DownloadSettingDialog';
import LayoutMoreDialog from '../../../componets/Reader/LayoutMoreDialog';
import { MusicPlayer } from 'ets/componets/Reader/MusicPlayer';
import purificationView from './purificationView';
import { bookParser, readerCore, ReadPageComponent } from '@kit.ReaderKit';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { NetworkInput } from '../../../componets/Reader/NetworkInput';
import { ClickUtil, PreferencesUtil } from '@pura/harmony-utils';
import { Books } from '../../../database/entities/Books';
import { WindowAbility } from '../../../entryability/WindowAbility';

interface ParamsObj {
  bookData: Books,
  clickBookCatalogId: number,
}

//2025.4.19 改用官方API16的 ReaderKit
@Entry
@Component
struct ReaderPage3 {
  @StorageLink('windowWidth') windowWidth: number = 0;
  @StorageLink('windowHeight') windowHeight: number = 0;
  @StorageLink('colorMode') @Watch('colorModeChange') colorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State ReaderPadding: number = 24 // 边距
  @State isShowSetting: boolean = false
  @State isShowDownload: boolean = false
  @State isShowListen: boolean = false
  @State isShowContentSetting: boolean = false
  @State isShowMoreLayout: boolean = false
  @State CurrentLuminance: number = 0 // 亮度
  @State ParagraphSpacing: number = -2
  @State isShowSource: boolean = false
  @State isShowPurification: boolean = false
  //书籍解析用数据
  @State bookData: Books = new Books(); //书籍数据
  @State CatalogList: bookParser.CatalogItem[] = []; //章节数据
  @State CatalogIndex: number = 0 //当前章节索引
  readerComponentController: readerCore.ReaderComponentController = new readerCore.ReaderComponentController();
  //阅读器设置
  @State isShowCatalogDialog: boolean = false // 目录弹窗
  private readerSetting: readerCore.ReaderSetting = {
    fontName: '系统字体',
    fontPath: '',
    fontSize: 18,
    fontColor: '#000000',
    fontWeight: 400,
    lineHeight: 1.9,
    nightMode: false,
    themeColor: 'rgba(248, 249, 250, 1)',
    themeBgImg: '',
    flipMode: '0',
    scaledDensity: display.getDefaultDisplaySync().scaledDensity > 0 ?
    display.getDefaultDisplaySync().scaledDensity :
      1,
    viewPortWidth: this.windowWidth,
    viewPortHeight: this.windowHeight
  };
  private screenDensityCallBack: Callback<number> | null = null;
  private defaultHandler: bookParser.BookParserHandler | null = null;
  private currentData: readerCore.PageDataInfo | null = null;
  private scrollerForList: ListScroller = new ListScroller();

  spineIndexChange() {
    this.readerComponentController.startPlay(this.CatalogIndex, '');
  }

  async aboutToAppear() {
    this.registerScreenDensityChange();
    this.registerListener();
    //  进入阅读页面后隐藏系统状态栏
    WindowAbility.getInstance().toggleWindowSystemBar([], this.getUIContext().getHostContext());
    //修改为设置的主题
    if (this.colorMode === 0) {
      this.readerSetting.nightMode = true;
      this.readerSetting.fontColor = '#ffffff';
      this.readerSetting.themeColor = '#202224';
    } else {
      this.readerSetting.nightMode = false;
      this.readerSetting.fontColor = '#000000';
      this.readerSetting.themeColor = '#FFFFFF';
    }
    let temp = router.getParams() as ParamsObj
    this.bookData = temp.bookData
    this.currentData =PreferencesUtil.getSync(`BookCurrentData_${this.bookData.bookName}`, this.currentData)?
      PreferencesUtil.getSync(`BookCurrentData_${this.bookData.bookName}`, this.currentData) as readerCore.PageDataInfo:null
    this.CatalogIndex = this.currentData?.resourceIndex ?? 0
    this.startPlay(this.bookData?.bookUrl ?? '', this.currentData?.resourceIndex ?? 0,
      this.currentData?.startDomPos ?? '');
  }

  private async startPlay(path: string, resourceIndex: number, domPos: string) {
    try {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let initPromise: Promise<void> = this.readerComponentController.init(context);
      let defaultHandler: Promise<bookParser.BookParserHandler> = bookParser.getDefaultHandler(path);
      let result: [bookParser.BookParserHandler, void] = await Promise.all([defaultHandler, initPromise]);
      this.defaultHandler = result[0];
      this.readerComponentController.registerBookParser(this.defaultHandler);
      this.readerComponentController.setPageConfig(this.readerSetting);
      this.readerComponentController.startPlay(resourceIndex || 0, domPos);
      this.CatalogList = this.defaultHandler?.getCatalogList() || []; //获取目录列表
      hilog.info(0x0000, 'testTag', 'catalog list length: ' + this.CatalogList.length);
    } catch (err) {
      hilog.error(0x0000, 'testTag', `failed to startPlay, Code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 系统的颜色模式更改后调整为对应的主题
   */
  colorModeChange() {
    if (this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.readerSetting.nightMode = true;
      this.readerSetting.fontColor = '#ffffff';
      this.readerSetting.themeColor = '#202224';
    } else {
      this.readerSetting.nightMode = false;
      this.readerSetting.fontColor = '#000000';
      this.readerSetting.themeColor = '#FFFFFF';
    }
    this.readerComponentController.setPageConfig(this.readerSetting);
  }

  /**
   * 注册屏幕密度变化回调。
   */
  registerScreenDensityChange() {
    this.screenDensityCallBack = (data: number) => {
      let displaySync = display.getDefaultDisplaySync();
      let scaledDensity = displaySync.scaledDensity;
      if (scaledDensity !== this.readerSetting.scaledDensity) {
        AppStorage.setOrCreate('isDensityChange', true);
        this.getUIContext().getRouter().back();
      }
    }
    display.on('change', this.screenDensityCallBack);
  }

  private registerListener(): void {
    this.readerComponentController.on('pageShow', (data: readerCore.PageDataInfo): void => {
      this.currentData = data;
      // 保存页面数据。
      PreferencesUtil.putSync(`BookCurrentData_${this.bookData.bookName}`, this.currentData)
    });
    WindowAbility.getInstance().onWindowSizeChange(() => {
      if (this.readerSetting.viewPortWidth != this.windowWidth ||
        this.readerSetting.viewPortHeight != this.windowHeight) {
        // 当窗口大小更改时，更新当前页面视区大小。
        this.readerSetting.viewPortWidth = this.windowWidth;
        this.readerSetting.viewPortHeight = this.windowHeight;
        try {
          this.readerComponentController.setPageConfig(this.readerSetting);
        } catch (e) {
          console.error('onWindowSizeChange, error ' + JSON.stringify(e));
        }
      }
    });
  }

  aboutToDisappear(): void {
    display.off('change', this.screenDensityCallBack);
    this.readerComponentController.off('pageShow');
    this.readerComponentController.off('resourceRequest');
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
              Image($r("app.media.ic_public_return_left"))
                .fillColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')
                .width(24)
                .onClick(() => {
                  router.back()
                })

              Text(`${this.CatalogList[this.CatalogIndex]?.catalogName ?? ''}`
                .replace(new RegExp('\\s{1,}', 'g'), ' ')
                .replaceAll('=', ''))
                .layoutWeight(1).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')

              /*Row({ space: 16 }) {
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
              }*/
            }.padding({
              top: 12,
              left: 20,
              right: 20,
              bottom: 12
            })
            .width("100%")

            /*            Row() {
                          NetworkInput()
                        }.padding({
                          top: 8,
                          left: 20,
                          right: 20,
                          bottom: 12
                        }).width("100%")*/

            Divider()
          }
          .padding({ top: this.topRectHeight == 0 ? 40 : 0 })
          .backgroundColor(this.colorMode == 0 ? '#1F1F1F' : 'rgba(250, 250, 250, 1)')
          .transition(TransitionEffect.move(TransitionEdge.TOP).animation({ duration: 500 }))

          Blank(1).onClick(() => {
            this.isShowSetting = false
          })

          // 阅读器-下方弹框
          Column({ space: 20 }) {
            Divider()

            if (!this.isShowContentSetting) {
              /*Row() {
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
              }).justifyContent(FlexAlign.SpaceBetween).width("100%")*/

              Row({ space: 16 }) {
                Text("上一章")
                  .fontColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')
                  .onClick(() => {
                    if (this.CatalogIndex > 0) {
                      this.CatalogIndex--
                      this.spineIndexChange()
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
                    ClickUtil.debounce(() => { //防抖
                      this.CatalogIndex = Math.floor(value)
                      this.spineIndexChange()
                    }, 500)
                  })

                Text("下一章")
                  .fontColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')
                  .onClick(() => {
                    if (this.CatalogIndex < this.CatalogList.length - 1) {
                      this.CatalogIndex++
                      this.spineIndexChange()
                    }
                  })
              }
              .padding({
                //todo:临时bottom距离
                left: 24, right: 24, bottom: '10%'
              })
              .width("100%")
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
                    value: this.readerSetting.fontSize,
                    max: 48,
                    min: 12,
                    step: 1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.readerSetting.fontSize = value
                      this.readerComponentController.setPageConfig(this.readerSetting);
                    })
                  Row() {
                    Button('字体')
                  }
                }

                Row({ space: 16 }) {
                  Text('行距')
                  Slider({
                    value: this.readerSetting.lineHeight,
                    max: 3,
                    min: 1,
                    step: 0.1,
                    style: SliderStyle.InSet
                  })
                    .selectedColor('rgba(0, 0, 0, 0.04)')
                    .blockSize({ width: 30, height: 30 })
                    .layoutWeight(1)
                    .onChange((value) => {
                      this.readerSetting.lineHeight = value
                      this.readerComponentController.setPageConfig(this.readerSetting);
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

            Grid() {
              GridItem() {
                Column() {
                  Image($r("app.media.catalogue")).width(24)
                  Text("目录")
                    .fontColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')
                }
                .onClick(() => {
                  this.isShowCatalogDialog = true
                })
                .bindSheet(this.isShowCatalogDialog, this.CatalogDialog(), {
                  detents: ['90%', 200],
                  dragBar: true,
                  showClose: false,
                  onDisappear: () => {
                    this.isShowCatalogDialog = false
                  },
                  backgroundColor: this.colorMode == 0 ? 'rgba(19, 19, 19, 1.00)' : 'rgba(248, 249, 250, 1)'
                })
              }

              //todo:听书功能开发
              /*              GridItem() {
                              Column() {
                                Image($r("app.media.listen")).width(24)
                                Text("听书")
                              }
                            }
                            .bindContentCover($$this.isShowListen, this.BookListen(), {
                              modalTransition: ModalTransition.DEFAULT, backgroundColor: "rgba(51, 106, 128, 0.75)"
                            }).onClick(() => {
                              this.isShowListen = true
                            })*/

              GridItem() {
                Column() {
                  Image($r("app.media.night_icon")).width(24)
                  Text("夜间")
                    .fontColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')
                }.onClick(() => {
                  this.colorMode = this.colorMode == 0 ? 1 : 0
                  if (this.colorMode == 0) {
                    this.readerSetting.nightMode = true;
                    this.readerSetting.fontColor = '#ffffff';
                    this.readerSetting.themeColor = '#202224';
                  } else {
                    this.readerSetting.nightMode = false;
                    this.readerSetting.fontColor = '#000000';
                    this.readerSetting.themeColor = '#FFFFFF';
                  }
                  this.readerComponentController.setPageConfig(this.readerSetting);
                })
              }

              GridItem() {
                Column() {
                  Image($r(this.isShowContentSetting ? "app.media.my_center_set_icon_fill" :
                    "app.media.my_center_set_icon")).width(24)
                  Text("设置")
                    .fontColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')
                }.onClick(() => {
                  this.isShowContentSetting = !this.isShowContentSetting
                })
              }
            }.columnsTemplate("1fr 1fr 1fr").width("100%").height(60)
          }
          .backgroundColor(this.colorMode == 0 ? '#1F1F1F' : 'rgba(248, 249, 250, 1)')
          .transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 500 }))
        }
      }.width("100%").height("100%").enabled(this.isShowSetting).padding({
        top: this.topRectHeight,
      })
    }.width('100%').height('100%').onClick(() => {
      this.readerComponentController.on('pageShow', (data: readerCore.PageDataInfo): void => {
        this.currentData = data;
        this.CatalogIndex = data.resourceIndex
      });
      // 点击拉起菜单栏功能
      this.isShowSetting = true
    })
  }

  @Builder
  CatalogDialog() {
    List({ space: 10, scroller: this.scrollerForList }) {
      ForEach(this.CatalogList, (item: bookParser.CatalogItem, index) => {
        ListItem() {
          Column() {
            Row() {
              Text(item.catalogName)
                .fontSize(14)
                .fontColor(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(19, 19, 19, 1.00)')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .padding({ top: 8, bottom: 8 })
                .layoutWeight(1)
            }
            .width('100%')

            Divider()
              .color(this.colorMode == 0 ? 'rgba(248, 249, 250, 1)' : 'rgba(136, 136, 136, 1.00)')
          }
          .padding({
            left: item.catalogLevel ? item.catalogLevel * 26 : 16,
            right: 16,
          })
        }
        .onClick(() => {
          this.CatalogIndex = index
          this.spineIndexChange()
          this.isShowCatalogDialog = false
        })
      })
    }
    .width('100%')
    .height('100%')
    .onAppear(() => {
      this.scrollerForList.scrollToIndex(this.CatalogIndex)
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

  /**
   * 去掉页面过渡动画，加快阅读器的页面访问速度
   */
  pageTransition() {
    PageTransitionEnter({ duration: 0, curve: Curve.Sharp });
    PageTransitionExit({ duration: 0, curve: Curve.Sharp });
  }
}
