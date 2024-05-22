import { router } from '@kit.ArkUI';

@Entry
@Component
struct LocalImportPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State currentTabIndex: number = 0
  @State SearchValue: string = ""

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.Start
      }) {
        TabContent() {
          Column() {
            this.SearchBar()
            this.SmartScanItem()
            this.SmartScanItem()
            this.SmartScanItem()

          }
          .width('100%')
          .height("100%")
        }
        .padding({
          left: 20,
          right: 20
        })
        .tabBar(this.TabBuilder(0, "智能扫描"))

        TabContent() {
          Column() {
            this.SearchBar()
            this.LocalItem()
          }
          .width('100%')
          .height("100%")
        }
        .padding({
          left: 20,
          right: 20
        })
        .tabBar(this.TabBuilder(1, "本地目录"))
      }
      .onChange((index: number) => {
        this.currentTabIndex = index
      })

    }
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight
    })
  }

  @Builder
  SearchBar() {
    Search({ value: $$this.SearchValue, placeholder: '搜索', icon: "/common/images/search.svg" })
      .width("100%")
      .height(40)
  }

  @Builder
  SmartScanItem() {
    Row({ space: 12 }) {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        Text("EPUB")
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
          Text("斗破苍穹")
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500,
            })
        }
        .width("100%")

        Row() {
          Text("12M 2021/8/13")
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
      Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
    }
    .padding({
      top:10,
      bottom:10
    })
    .width("100%")
  }

  @Builder
  LocalItem() {
    Row({ space: 12 }) {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        Text("EPUB")
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
          Text("斗破苍穹")
            .lineHeight(22)
            .font({
              size: 14,
              weight: 500,
            })
        }
        .width("100%")

        Row() {
          Text("12M 2021/8/13")
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
      Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
    }
    .padding({
      top:10,
      bottom:10
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
          Image($r(index === 0 ? 'app.media.return_left' : 'app.media.Column_More'))
            .width(24)
            .onClick(() => {
              if (index) {

              } else {
                router.back()
              }
            })
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