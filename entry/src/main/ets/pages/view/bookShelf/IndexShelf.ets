import BookMark from '../../../componets/head/BookMark'
import { router } from '@kit.ArkUI'
import BookBodyContent from './components/BookBodyContent'
import { FileHandler } from '../../../common/utils/FileHandler'
import Dialog from '../../../componets/common/Dialog'
import { showMessage } from '../../../componets/common/promptShow'
import { bookShelfImport } from '../../../database/entities/Books'
import { getPasteDataSync, isNetworkUrl, sleep } from '../../../common/utils/utils'
import booksUtil from '../../../common/utils/booksUtils'
import axios, { AxiosResponse } from '@ohos/axios'
import { ThemeItem } from '../../../common/model/Theme'
import { ThemeStorageKey } from '../../../common/constants/Theme'

@Component
export default struct IndexShelf {
  @State currentIndex: number = 0
  THEME_NAMES: string[] = ['书籍导入', '下载管理', '导入书单', '批量管理']
  titleArray: Array<string> = ['小说', '漫画', '有声书']

  @State bookTypeNumber:number = 2
  @State EXHIBIT: string = '列表'
  @State @Watch('changeGroup')GROUP: string = '标签'
  changeGroup(){
    if (this.GROUP === '文件夹') {
      this.bookTypeNumber = 1
    } else {
      this.bookTypeNumber = 2
    }
  }
  @State isShowImport: boolean = false
  @State isShowCloudImport: boolean = false
  @State isShowImportBookList: boolean = false
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = false
  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  @State bookImport:bookShelfImport[] = []
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  // 网址导入dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: Dialog({
      title: '网址导入',
      child: () => {
        this.DialogInput("请输入书籍目录或详情页")
      }
    }),
    cornerRadius: 8,
    offset: { dx: 0, dy: 0 }
  })
  tabsController: TabsController = new TabsController();
  private scrollController: Scroller = new Scroller();
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
        controller: this.tabsController,
        index: this.currentIndex
      }) {
        ForEach(this.titleArray, () => {
          TabContent() {
           Column(){
             BookBodyContent({
               currentIndex: this.currentIndex,
               EXHIBIT: this.EXHIBIT,
               GROUP: this.GROUP,
               bookTypeNumber:this.bookTypeNumber
             })
           }
          }
        })
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
      colors: [[this.theme.mainColor, 0], [this.theme.secondColor, 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .borderRadius({ bottomRight: 5, bottomLeft: 5 })
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
          let FileResult = await FileHandler.documentPickerFile(1, ['.txt', '.epub'])
          FileHandler.CopyFile(FileResult[0], this.currentIndex)
          this.isShowImport = false
          setTimeout(()=>{
            this.isBookRefreshing++
          },500)
          break
        case 1:
          // 云盘导入
          this.isShowCloudImport = true
          break
        case 2:
          // 网址导入
          this.dialogController.open();
          break
        case 3:
          // 书单粘贴导入
          this.pasteBookImport()
          break
        case 4:
          //书单本地导入
          let res = await FileHandler.documentPickerFile(1, ['.json'])
          FileHandler.ReadJSONFile(res[0]).then(async result => {
            if (result.length > 0) {
              this.bookImport = JSON.parse(result) as bookShelfImport[]
              this.bookImport.length>0?await booksUtil.batchAdd(this.bookImport,this.currentIndex):''
              showMessage(this.bookImport.length > 0?`相关书单书籍内容导入${this.bookImport.length}本`:'未找到相关书单书籍内容')
            }
          })
          setTimeout(()=>{
            this.isBookRefreshing++
          },500)
          break
      }
    })
  }

  @Builder
  // 书籍导入弹窗
  ImportDialog() {
    Column() {
      GridRow({
        columns: 3
      }){
        GridCol(){
          this.ImportClickBox(0, "app.media.my_center_file_icon", "本地导入")
        }
        GridCol(){
          this.ImportClickBox(1, "app.media.my_center_cloud_icon", "网盘导入")
        }
        GridCol(){
          this.ImportClickBox(2, "app.media.official_website", "网址导入")
        }
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
  DialogInput(placeholder: string, maxlength?: number) {
    Row() {
      TextInput({ placeholder: placeholder })
        // .maxLength(maxlength)
        // .showCounter(true)
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
        router.pushUrl({
          url: 'pages/view/bookShelf/Manage/BookManagePage',
          params: {
            currentIndex: this.currentIndex,
            EXHIBIT: this.EXHIBIT,
            bookTypeNumber: this.bookTypeNumber
          }
        })
        break
    }
  }

  //书单粘贴导入
  async pasteBookImport() {
    try {
      let url = getPasteDataSync()
      if (!url) {
        showMessage('未获取到粘贴信息，请求默认数据')
        await sleep()
        return
      }
      if (!isNetworkUrl(url ?? '')) {
        showMessage('复制的链接不正确')
        await sleep()
        url = undefined
        return
      }
      const res: AxiosResponse = await axios
        .get(url);
      this.bookImport = res.data as bookShelfImport[]
      showMessage(this.bookImport.length > 0?`相关书单书籍内容导入${this.bookImport.length}本`:'未找到相关书单书籍内容')
      this.bookImport.length>0?booksUtil.batchAdd(this.bookImport,this.currentIndex):''
    } catch (err) {
      console.error('错误 ' + err);
    }
  }
}