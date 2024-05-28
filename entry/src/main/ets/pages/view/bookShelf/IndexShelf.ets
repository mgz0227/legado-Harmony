import cartoonPage from './cartoonPage'
import novelPage from './novelPage'
import BookMark from '../../../componets/head/BookMark'

import soundPage from './soundPage'
import IndexSearchType from '../../../componets/head/IndexSearchType'
import router from '@ohos.router'; // 引入路由管理器
import confirmDialogExample from '../../../componets/common/confirmDialog'
import BookFolder from './BookFolder'
import groupTypeComponent from '../../../componets/group/GroupType'
import BookShelfInfo from './Shelf/BookShelfInfo'
import ShelfBookList from './Shelf/ShelfBookList'

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

  @State currentIndex: number = 0
  THEME_NAMES: string[] = ['书籍导入', '下载管理', '导入书单', '批量管理']
  EXHIBIT_NAMES: string[] = ['列表', '宫格']
  GROUP_NAMES: string[] = ['标签', '文件夹']
  @State EXHIBIT: string = '列表'
  @State GROUP: string = '文件夹'
  @State searchValue: string = '最近阅读'
  @State bookType: string = '分组'
  @State title: string = '最近阅读'
  @State isClear: boolean = false
  @State isRefreshing: boolean = false
  @State counter: number = 0
  @State RefreshingTitle: string = '松开刷新'
  @State groupCoverShow: boolean = false
  @State isShowImport: boolean = false
  @State isShowCloudImport: boolean = false
  @State isShowImportBookList: boolean = false
  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = false
  // 网址导入dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CloudPasteDialog(),
    cornerRadius: 8,
    offset: { dx: 0, dy: 0 }
  })

  build() {
    Column() {
      Blank(20)
      Tabs({
        barPosition: BarPosition.Start
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
      .barHeight(0)
      .onChange((index) => {
        console.log('index:' + index)
        this.currentIndex = index
      })
      .scrollable(this.APP_INDEX_SCROLLABLE)
    }
    .padding({ bottom: 10 })
    .borderRadius({ bottomRight: 5, bottomLeft: 5 })
    .backgroundImage($r('app.media.backgroundimage'))
    .backgroundImageSize({ width: '100%', height: '10%' })
    .width('100%')
  }

  @Builder
  book() {
    Column() {
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.End
      }) {
        Row({ space: 20 }) {
          BookMark({ title: '小说', index: 0, currentIndex: this.currentIndex }).onClick(() => {
            this.currentIndex = 0
            console.log(this.currentIndex + '')
          })
          BookMark({ title: '漫画', index: 1, currentIndex: this.currentIndex }).onClick(() => {
            this.currentIndex = 1
            console.log(this.currentIndex + '')
          })
          BookMark({ title: '有声书', index: 2, currentIndex: this.currentIndex }).onClick(() => {
            this.currentIndex = 2
            console.log(this.currentIndex + '')
          })
        }
        .padding({ left: 15 })

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
              onDisappear: () => {
                // this.clickBookType = ''
              }
            })
        }.margin({ right: 20 })
      }

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
            groupCoverShow: this.groupCoverShow
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
            .padding({ left: 10, right: 10 })
          }
          .height('85%')
          .align(Alignment.TopStart)
          // .height(this.searchValue==='浏览历史'?'83%':'78%')
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
    Row() {
      if (this.RefreshingTitle !== '松开刷新') {
        LoadingProgress().height(30)
      }
      Text(this.RefreshingTitle).fontSize(16).margin({ left: 20 })
    }
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
    .onClick(() => {
      switch (index) {
        case 0:
        // 本地导入
          router.pushUrl({
            url: 'pages/view/bookShelf/LocalImportPage'
          });
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

@CustomDialog
  // 网址导入自定义弹窗
struct CloudPasteDialog {
  controller?: CustomDialogController;

  build() {
    Column() {
      Row() {
        Text("网址导入")
          .lineHeight(26)
          .font({
            size: 18,
            weight: 500
          })
      }

      Row() {
        Search({ placeholder: '请输入书籍目录或详情页地址' })
      }
      .margin({
        top:16,
        bottom:24
      })

      Flex({
        justifyContent: FlexAlign.SpaceEvenly,
        alignItems: ItemAlign.Center
      }) {
        Button() {
          Text("取消")
            .fontColor("#FF6600")
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500
            })
        }
        .width(112)
        .height(38)
        .backgroundColor("rgba(255, 102, 0, 0.12)")
        .onClick(() => {
          if (this.controller != undefined) {
            this.controller.close()
          }
        })

        Button() {
          Text("确定")
            .fontColor("#FFFFFF")
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500
            })
        }
        .width(112)
        .height(38)
        .backgroundColor("#FF6600")
        .onClick(() => {

        })
      }
    }
    .padding({
      top: 24,
      bottom: 24,
      left: 24,
      right: 24
    })
  }
}