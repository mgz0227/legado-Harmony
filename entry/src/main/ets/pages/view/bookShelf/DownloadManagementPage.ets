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
struct DownloadManagementPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State currentTabIndex: number = 0
  @State SearchValue: string = ""
  FilesTypeImageList: Array<string> = ["EPUB", "TXT", "PDF"]
  @State SmartScanItemList: SmartScanItem[] = [
  new SmartScanItem("斗破苍穹", "12MB", "EPUB", new Date()),
  new SmartScanItem("斗破苍穹", "12MB", "TXT", new Date()),
  new SmartScanItem("斗破苍穹", "12MB", "PDF", new Date()),
  ]

  build() {
    Column() {
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
            }
          }
          .width('100%')
          .height("100%")
        }
        .padding({
          left: 20,
          right: 20
        })
        .tabBar(this.TabBuilder(0, "下载"))

        TabContent() {
          Column() {
            if (this.SmartScanItemList.length > 0) {
              ForEach(this.SmartScanItemList, (item: SmartScanItem) => {
                this.ScanShowItem(item)
              })
              Blank(1)
              Divider()
            }
          }
          .width('100%')
          .height("100%")
        }
        .padding({
          left: 20,
          right: 20
        })
        .tabBar(this.TabBuilder(1, "导出"))
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
        .width("70%")
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