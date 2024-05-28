import { router } from '@kit.ArkUI';
import fs from '@ohos.file.fs';

class SmartScanItem {
  bookName: string
  Type: string
  CreateTime: Date
  size: string

  constructor(
    bookName: string,
    size: string,
    Type: string = 'EPUB',
    CreateTime: Date = new Date()
  ) {
    this.bookName = bookName
    this.size = size
    this.Type = Type
    this.CreateTime = CreateTime
  }
}

function formatDate(date: Date): string {
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 月份从0开始，所以需要加1
  const day = date.getDate().toString().padStart(2, '0');
  return `${year}/${month}/${day}`;
}

@Entry
@Component
struct LocalImportPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State currentTabIndex: number = 0
  @State SearchValue: string = ""
  @State onSearchClick: boolean = false
  @State SearchTranslateY: number = 0
  SearchController: SearchController = new SearchController()
  FilesTypeImageList: Array<string> = ["EPUB", "TXT", "PDF"]
  @State SmartScanItemList: SmartScanItem[] = [
  // new SmartScanItem("斗破苍穹", "12MB", "EPUB", new Date()),
  // new SmartScanItem("斗破苍穹", "12MB", "TXT", new Date()),
  // new SmartScanItem("斗破苍穹", "12MB", "PDF", new Date()),
  ]
  menuList: string[] = [
    '按时间排序',
    '按名称排序',
    '按大小排序',
    '系统文件夹',
  ]

  // 加载测试
  onPageShow(): void {
    setTimeout(() => {
      this.SmartScanItemList = [
        new SmartScanItem("斗破苍穹", "12MB", "EPUB", new Date()),
        new SmartScanItem("斗破苍穹", "12MB", "TXT", new Date()),
        new SmartScanItem("斗破苍穹", "12MB", "PDF", new Date()),
      ]
    }, 1000)
  }

  build() {
    Stack() {
      Row({ space: 12 }) {
        if (this.onSearchClick) {
          Image($r('app.media.return_left'))
            .width(24)
            .onClick(() => {
              this.onSearchClick = false
              this.SearchTranslateY = 55
            })
        }
        Search({
          value: this.SearchValue,
          placeholder: '搜索',
          icon: "/common/images/search.svg",
          controller: this.SearchController
        })
          .width(this.onSearchClick ? "90%" : "100%")
          .onClick(() => {
            this.onSearchClick = true
            this.SearchTranslateY = -55
          })
          .onBlur(() => {
            this.onSearchClick = false
            this.SearchTranslateY = 0
          })
      }
      .translate({ x: 0, y: this.SearchTranslateY })
      .animation({
        duration: 500,
        curve: Curve.EaseOut,
        playMode: PlayMode.Normal
      })
      .width("100%")
      .height(40)
      .margin({
        top:55
      })
      .padding({
        left: 20,
        right: 20
      })
      .zIndex(2)

      if (!this.onSearchClick) {
        Tabs({
          barPosition: BarPosition.Start
        }) {
          TabContent() {
            Column() {
              if (this.SmartScanItemList.length > 0) {
                ForEach(this.SmartScanItemList, (item: SmartScanItem) => {
                  this.ScanShowItem(item)
                })
                Blank(1)
                Divider()
                this.BottomBar()
              } else {
                Image($r('app.media.no_record'))
                  .width(200)
                  .margin({
                    top: 144
                  })
                Text('暂未扫描到可用书籍，支持txt、epub、pdf、mp3、wma')
                  .textAlign(TextAlign.Center)
                  .lineHeight(22)
                  .opacity(0.45)
                  .font({
                    size: 14,
                    weight: 400
                  })
              }
            }
            .width('100%')
            .height("100%")
          }
          .padding({
            top: 40,
            left: 20,
            right: 20
          })
          .tabBar(this.TabBuilder(0, "智能扫描"))

          TabContent() {
            Column() {
              // this.SearchBar()
              if (this.SmartScanItemList.length > 0) {
                ForEach(this.SmartScanItemList, (item: SmartScanItem) => {
                  this.ScanShowItem(item)
                })
                Blank(1)
                Divider()
                this.BottomBar()
              } else {
                Image($r('app.media.no_record'))
                  .width(200)
                  .margin({
                    top: 144
                  })
                Text('暂未扫描到可用书籍，支持txt、epub、pdf、mp3、wma')
                  .textAlign(TextAlign.Center)
                  .lineHeight(22)
                  .opacity(0.45)
                  .font({
                    size: 14,
                    weight: 400
                  })
              }
            }
            .width('100%')
            .height("100%")
          }
          .padding({
            top: 40,
            left: 20,
            right: 20
          })
          .tabBar(this.TabBuilder(1, "本地目录"))
        }
        .onChange((index: number) => {
          this.currentTabIndex = index
        })
      } else {
        Column()
          .width("100%")
          .height("100%")
          .onClick(() => {
            // 狗鸿蒙的search组件点击其它地方不失焦
            this.onSearchClick = false
            this.SearchTranslateY = 0
          })
      }
    }
    .alignContent(Alignment.TopStart)
    .width("100%")
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight
    })
  }

  @Builder
  SearchBar() {

  }

  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      ForEach(this.menuList, (item: string, index) => {
        Row({ space: 8 }) {
          if (index === this.menuList.length - 1) {
            Image($r("app.media.my_center_file_icon")).width(20)
          }
          Text(`${item}`)
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500
            })
        }
        .padding({
          left: 20,
          right: 20
        })
        .align(Alignment.Center)
        .width("100%")
        .height(46)

        if (index !== this.menuList.length - 1) {
          Divider()
            .width('80%')
            .strokeWidth(index !== this.menuList.length - 1 ? null : 4)
        }
      })
    }.width(140)
  }

  @Builder
  BottomBar() {
    Row() {
      Row() {
        CheckboxGroup({ group: 'checkboxGroup' })
        Text("全选")
          .lineHeight(24)
          .font({
            size: 16,
            weight: 400
          })
      }

      Text("导入书架")
        .lineHeight(24)
        .fontColor("#FF6600")
        .opacity(0.5)
        .font({
          size: 16,
          weight: 400
        })
    }
    .justifyContent(FlexAlign.SpaceAround)
    .width("100%")
    .height(56)
  }

  @Builder
  ScanShowItem(item: SmartScanItem) {
    Row({ space: 12 }) {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        Text(item.Type)
          .fontColor("#188BFF")
          .font({
            size: 10,
            weight: 700,
          })

      }
      .backgroundColor("#D8ECFF")
      .width(32)
      .height(32)
      .padding({
        top: 10,
        bottom: 10
      })
      .margin(4)

      Column() {
        Row() {
          Text(item.bookName)
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500,
            })
        }
        .width("100%")

        Row() {
          Text(`${item.size} ${formatDate(item.CreateTime)}`)
            .lineHeight(18)
            .opacity(0.45)
            .font({
              size: 10,
              weight: 500,
            })
        }
        .width("100%")
      }
      .width("60%")

      Blank(1)
      Checkbox({ name: `${item.bookName}`, group: 'checkboxGroup' })
    }
    .padding({
      top: 10,
      bottom: 10
    })
    .width("100%")
  }

  @Builder
  TabBuilder(index = 0, name: string) {
    Column() {
      Flex({
        direction: index === 0 ? FlexDirection.Row : FlexDirection.RowReverse,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Start
      }) {
        Column() {
          if (index) {
            Image($r('app.media.Column_More'))
              .width(24)
              .bindMenu(this.MenuBuilder)
          } else {
            Image($r('app.media.return_left'))
              .width(24)
              .onClick(() => {
                router.back()
              })
          }

        }
        .padding({
          left: index === 0 ? 20 : null,
          right: index === 1 ? 20 : null
        })
        .width("55.5%")
        .alignItems(index === 0 ? HorizontalAlign.Start : HorizontalAlign.End)

        Column() {
          Text(name)
            .lineHeight(24)
            .font({
              size: 16,
              weight: 500
            })
            .fontColor(this.currentTabIndex === index ? '#FF6600' : '#000000')
            .opacity(this.currentTabIndex === index ? null : 0.45)
        }
      }
      .height("100%")
    }
    .width('100%')
    .height("100%")
  }
}