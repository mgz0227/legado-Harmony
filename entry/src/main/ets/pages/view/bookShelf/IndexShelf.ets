import cartoonPage from './cartoonPage'
import novelPage from './novelPage'
import BookMark from '../../../componets/head/BookMark'

import soundPage from './soundPage'
import IndexSearchType from '../../../componets/head/IndexSearchType'
import router from '@ohos.router'; // 引入路由管理器
import confirmDialogExample from '../../../componets/common/confirmDialog'
import Dialog from 'ets/componets/common/Dialog'
import BookFolder from './BookFolder'
import groupTypeComponent from '../../../componets/group/GroupType'
import ShelfBookList from './Shelf/ShelfBookList'

import picker from '@ohos.file.picker'
import { FileHandler } from 'ets/common/utils/FileHandler'
import RefreshComponent from '../../../componets/common/RefreshComponent'

@Component
export default struct IndexShelf {
  @State delCache: boolean = false
  IndexShelf: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: () => {
        this.onCancel()
      },
      confirm: () => {
        this.onAccept()
      },
      title: '清空',
      delCache: this.delCache
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    // offset: { dx: 0, dy: '-40%' },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25
  })
  @State currentIndex: number = 0
  THEME_NAMES: string[] = ['书籍导入', '下载管理', '导入书单', '批量管理']
  EXHIBIT_NAMES: string[] = ['列表', '宫格']
  GROUP_NAMES: string[] = ['标签', '文件夹']
  @State EXHIBIT: string = '列表'
  @State GROUP: string = '标签'
  @State searchValue: string = '最近阅读'
  @State bookType: string = '全部'
  @State title: string = '最近阅读'
  @State isClear: boolean = false
  @State isRefreshing: boolean = false
  @State counter: number = 0
  @State RefreshingTitle: string = '松开刷新'
  @State groupCoverShow: boolean = false
  @State isShowImport: boolean = false
  @State isShowCloudImport: boolean = false
  @State isShowImportBookList: boolean = false
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = false
  // 网址导入dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: Dialog({
      title: '网址导入',
      child: () => {
        this.DialogInput("请输入书籍目录或详情页", 10)
      }
    }),
    cornerRadius: 8,
    offset: { dx: 0, dy: 0 }
  })
  tabsController: TabsController = new TabsController();
  private scrollController: Scroller = new Scroller();

  onAccept() {
    console.info('确定')
    this.isClear = true
  }

  onCancel() {
    console.info('取消')
  }

  exitApp() {
    console.info('点外围取消')
  }

  @Builder
  DialogInput(placeholder: string, maxlength: number) {
    Row() {
      TextInput({ placeholder: placeholder })
        .maxLength(maxlength)
        .showCounter(true)
        .cancelButton({
          icon: {
            src: $r('app.media.close')
          }
        })
    }
    .margin({
      top: 16,
      bottom: 16
    })
  }

  build() {
    Column() {
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.End
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
          // .align(Alignment.TopStart)
          .height(40)
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)
        }

        Row() {
          Flex() {
          }
          .width(0)
          .height(0)
          .bindSheet($$this.isShowCloudImport, this.CloudImportDialog(), {
            // 网盘导入弹窗绑定元素
            height: 240,
            showClose: false,
            dragBar: false,
            backgroundColor: "white",
            blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
            onDisappear: () => {
              // this.clickBookType = ''
            }
          })

          Flex() {
          }
          .width(0)
          .height(0)
          .bindSheet($$this.isShowImportBookList, this.ImportBookListDialog(), {
            // 书单导入弹窗绑定元素
            height: 240,
            showClose: false,
            dragBar: false,
            backgroundColor: "white",
            blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
            onDisappear: () => {
              // this.clickBookType = ''
            }
          })

          Row({ space: 16 }) {
            Image($r('app.media.search')).width(24).onClick(() => {
              router.pushUrl({
                url: 'pages/view/search/SearchBook'
              });
            })
            Image($r('app.media.more')).width(24)
              .bindMenu([
                {
                  icon: $r('app.media.import_svg'),
                  value: this.THEME_NAMES[0],
                  action: () => {
                    this.changeTheme(0)
                  }
                },
                {
                  icon: $r('app.media.down_svg'),
                  value: this.THEME_NAMES[1],
                  action: () => {
                    this.changeTheme(1)
                  }
                },
                {
                  icon: $r('app.media.import_book_svg'),
                  value: this.THEME_NAMES[2],
                  action: () => {
                    this.changeTheme(2)
                  }
                },
                {
                  icon: $r('app.media.batch_svg'),
                  value: this.THEME_NAMES[3],
                  action: () => {
                    this.changeTheme(3)
                  }
                }
              ])
              .bindSheet($$this.isShowImport, this.ImportDialog(), {
                // 书籍导入弹窗绑定元素
                height: 200,
                showClose: false,
                dragBar: false,
                backgroundColor: "rgba(0, 0, 0, 0.15)",
                blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
              })
          }
        }.margin({ bottom: 12 })
      }
      .padding({ top: this.topRectHeight === 0 ? 30 : this.topRectHeight, left: 20, right: 20 })

      Tabs({
        barPosition: BarPosition.Start,
        controller: this.tabsController
      }) {
        TabContent() {
          this.book()
        }

        TabContent() {
          this.book()
        }

        TabContent() {
          this.book()
        }
      }
      .layoutWeight(1)
      .barWidth(0)
      .barHeight(0)
      .onChange((index) => {
        this.tabsController.changeIndex(index)
        console.log('index:' + index)
        this.currentIndex = index
      })
      .backgroundColor(Color.White)
      .scrollable(this.APP_INDEX_SCROLLABLE)
    }
    .height('100%')
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [["rgb(254, 203, 169)", 0], ["RGB(245, 245, 245)", 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    // .padding({ top: this.topRectHeight})
    .borderRadius({ bottomRight: 5, bottomLeft: 5 })
  }

  @Builder
  book() {
    Column() {
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Scroll() {
          Flex({
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.SpaceBetween
          }) {
            Row({ space: 15 }) {
              IndexSearchType({ title: this.title, searchValue: this.searchValue })
              IndexSearchType({ title: '浏览历史', searchValue: this.searchValue })
                .onClick(() => {
                  this.GROUP = '标签'
                  this.searchValue = '浏览历史'
                })
              if (this.searchValue !== '浏览历史') {
                this.GroupBuilder()
                this.ExhibitBuilder()
                Text('管理')
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/view/bookShelf/Manage/BookManagePage',
                      params: {
                        currentIndex: this.currentIndex,
                        EXHIBIT: this.EXHIBIT,
                        GROUPName: this.GROUP,
                        bookTypes: this.bookType
                      }
                    })
                  })
                  .fontColor('rgba(0,0,0,0.5)')
                  .fontSize(15)
                  .fontWeight(400)
              }
            }
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)

        if (this.searchValue === '浏览历史') {
          Row() {
            Text('清空')
              .onClick(() => {
                if (this.IndexShelf != null) {
                  this.IndexShelf.open()
                }
              })
          }
        }
      }
      .padding(15)

      Stack() {
        if (this.searchValue !== '浏览历史') {
          groupTypeComponent({
            bookType: this.bookType,
            currentIndex: this.currentIndex,
            groupCoverShow: this.groupCoverShow,
            GROUP: this.GROUP
          }).zIndex(999)
        }
        Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
          Scroll() {
            Stack({ alignContent: Alignment.Center }) {
              if (this.bookType === '书单' && this.searchValue !== '浏览历史') {
                ShelfBookList({
                  EXHIBIT: this.EXHIBIT,
                  isClear: this.isClear
                })
              } else {
                if (this.GROUP === '标签') {
                  if (this.currentIndex === 0) {
                    novelPage({
                      searchValue: this.searchValue,
                      currentIndex: 0,
                      isClear: this.isClear,
                      EXHIBIT: this.EXHIBIT
                    })
                      .zIndex(0)
                  } else if (this.currentIndex === 1) {
                    cartoonPage({
                      searchValue: this.searchValue,
                      currentIndex: 1,
                      isClear: this.isClear,
                      EXHIBIT: this.EXHIBIT
                    }).zIndex(1)
                  } else if (this.currentIndex === 2) {
                    soundPage({
                      searchValue: this.searchValue,
                      currentIndex: 2,
                      isClear: this.isClear,
                      EXHIBIT: this.EXHIBIT
                    }).zIndex(2)
                  }
                } else {
                  BookFolder({
                    EXHIBIT: this.EXHIBIT
                  })
                }
              }

            }
            .padding({ left: 10, right: 10 ,bottom:10})
          }

          .margin({ bottom: 110 + (this.topRectHeight === 0 ? 10 : this.topRectHeight) })
          .align(Alignment.TopStart)
          .scrollBar(BarState.Off)
        }
        .margin({ top: this.searchValue === '浏览历史' ? 0 : 30 })
        .onStateChange((refreshStatus: RefreshStatus) => {
          if (refreshStatus === 1 || refreshStatus === 2) {
            this.RefreshingTitle = '松开刷新'
          } else {
            this.RefreshingTitle = '刷新中...'
          }
        })
        .onRefreshing(() => {
          setTimeout(() => {
            this.counter++
            this.isRefreshing = false
          }, 1000)

        })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)
    }
  }

  @Builder
  ExhibitBuilder() {
    Row({ space: 10 }) {
      ForEach(this.EXHIBIT_NAMES, (item: string) => {
        if (item !== this.EXHIBIT) {
          IndexSearchType({ title: item, searchValue: this.searchValue })
            .onClick(() => {
              this.EXHIBIT = item
            })
          Divider()
            .vertical(true)
            .height(15)
            .color('#989797')
            .opacity(0.5)
            .strokeWidth(1)
        }
      })
    }
  }

  @Builder
  GroupBuilder() {
    Row({ space: 10 }) {
      ForEach(this.GROUP_NAMES, (item: string) => {
        if (item !== this.GROUP) {
          IndexSearchType({ title: item, searchValue: this.searchValue })
            .onClick(() => {
              this.GROUP = item
            })
          Divider()
            .vertical(true)
            .height(15)
            .color('#989797')
            .opacity(0.5)
            .strokeWidth(1)
        }
      })
    }
  }

  @Builder
  TabBuilderImage(index: number, name: string) {
    Column() {
      Image($r('app.media.SUB_theme'))
    }.width('100%')
  }

  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }

  @Builder
  // 书籍导入UI盒子
  ImportClickBox(index: number, image: string, text: string) {
    Column({ space: 8 }) {
      Flex() {
        Image($r(`${image}`))
          .width(24)
      }
      .width(48)
      .height(48)
      .borderRadius(24)
      .borderColor("rgba(0, 0, 0, 0.15)")
      .backgroundColor("white")
      .borderWidth(1)
      .padding(12)

      Text(text)
        .lineHeight(20)
        .font({
          size: 12,
          weight: 400
        })
    }
    .padding({
      top: 16,
      bottom: 12,
      left: 21,
      right: 21
    })
    .onClick(async () => {
      switch (index) {
        case 0:
        // 本地导入
        //   router.pushUrl({
        //     url: 'pages/view/bookShelf/LocalImportPage'
        //   });
          let documentSelectOptions = new picker.DocumentSelectOptions();
          let documentPicker = new picker.DocumentViewPicker();
          let filePath: string = ""
          await documentPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
            filePath = documentSelectResult[0];
          })
          FileHandler.CopyFile(filePath)
          this.isShowImport = false
          break
        case 1:
        // 云盘导入
          this.isShowCloudImport = true
          break
        case 2:
        // 网址导入
          this.dialogController.open();
          break
      }
    })
  }

  @Builder
  // 书籍导入弹窗
  ImportDialog() {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        wrap: FlexWrap.Wrap,
        alignContent: FlexAlign.Center,
        justifyContent: FlexAlign.Start
      }) {
        Grid() {
          GridItem() {
            this.ImportClickBox(0, "app.media.my_center_file_icon", "本地导入")
          }

          GridItem() {
            this.ImportClickBox(1, "app.media.my_center_cloud_icon", "网盘导入")
          }

          GridItem() {
            this.ImportClickBox(2, "app.media.official_website", "网址导入")
          }
        }
        .columnsTemplate("1fr 1fr 1fr 1fr")
        .padding({
          top: 12
        })
      }
      .height("60%")

      Divider()

      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(() => {
        this.isShowImport = false
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: 16
      })
    }
  }

  @Builder
  // 书籍导入-网盘导入弹窗
  CloudImportDialog() {
    Column() {
      Row() {
        Text("网盘导入")
          .lineHeight(24)
          .font({
            size: 16,
            weight: 500
          })
      }
      .padding({
        top: 12,
        bottom: 12,
      })

      Divider()

      Row({ space: 16 }) {
        Flex({
          wrap: FlexWrap.Wrap,
          alignContent: FlexAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          Text("坚")
            .lineHeight(24)
            .font({
              size: 16,
              weight: 500
            })
            .opacity(0.45)
        }
        .backgroundColor("rgba(0, 0, 0, 0.04)")
        .width(40)
        .height(40)

        Text("坚果云")
          .lineHeight(22)
          .font({
            size: 14,
            weight: 500
          })
          .opacity(0.88)
      }
      .padding({
        top: 12,
        bottom: 12,
      })
      .width("100%")
      .onClick(() => {

      })

      Row({ space: 16 }) {
        Flex({
          wrap: FlexWrap.Wrap,
          alignContent: FlexAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          Image($r('app.media.add')).width(24)

        }
        .backgroundColor("rgba(0, 0, 0, 0.04)")
        .width(40)
        .height(40)

        Text("添加webdav网盘")
          .lineHeight(22)
          .font({
            size: 14,
            weight: 500
          })
          .opacity(0.88)
      }
      .padding({
        top: 12,
        bottom: 12,
      })
      .width("100%")
      .onClick(() => {

      })

      Divider()

      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(() => {
        this.isShowCloudImport = false
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: 16
      })
    }
    .padding({
      left: 20,
      right: 20
    })
  }

  @Builder
  // 导入书单弹窗
  ImportBookListDialog() {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        wrap: FlexWrap.Wrap,
        alignContent: FlexAlign.Center,
        justifyContent: FlexAlign.Start
      }) {
        Grid() {
          GridItem() {
            this.ImportClickBox(3, "app.media.Paste", "粘贴导入")
          }

          GridItem() {
            this.ImportClickBox(4, "app.media.my_center_file_icon", "本地导入")
          }
        }
        .columnsTemplate("1fr 1fr 1fr 1fr")
        .padding({
          top: 12
        })
      }
      .height("60%")

      Divider()

      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(() => {
        this.isShowImportBookList = false
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: 16
      })
    }
  }

  changeTheme(themeNum: number) {
    // 右上角更多
    switch (themeNum) {
      case 0:
      // 书籍导入弹窗
        this.isShowImport = true
        break
      case 1:
      // 下载管理页
        router.pushUrl({
          url: 'pages/view/bookShelf/DownloadManagementPage'
        });
        break
      case 2:
      // 导入书单弹窗
        this.isShowImportBookList = true
        break
      case 3:
        break
    }
  }
}