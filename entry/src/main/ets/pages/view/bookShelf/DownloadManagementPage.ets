import { router } from '@kit.ArkUI';
import fs from '@ohos.file.fs';

class DownloadItem {
  bookName: string
  downloadNumber: number
  Total: number
  Type: string

  constructor(
    bookName: string,
    downloadNumber: number,
    Total: number,
    Type: string,
  ) {
    this.bookName = bookName
    this.downloadNumber = downloadNumber
    this.Total = Total
    this.Type = Type
  }
}

@Entry
@Component
struct DownloadManagementPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State currentTabIndex: number = 0
  @State currentScrollCardIndex: number = 0
  @State SearchValue: string = ""
  @State IsEdit: boolean = false
  @State questionsList: Array<string> = ["全部", "小说", "漫画", "有声书", "有声书", "有声书"]
  @State DownloadingItemList: DownloadItem[] = [
    new DownloadItem("斗破苍穹", 12, 100, "EPUB"),
    new DownloadItem("斗破苍穹", 70, 150, "TXT"),
    new DownloadItem("斗破苍穹", 50, 200, "PDF"),
    new DownloadItem("斗破苍穹", 50, 200, "PDF"),
  ]
  @State DownloadFinishItemList: DownloadItem[] = [
    new DownloadItem("斗破苍穹完成", 12, 100, "EPUB"),
    new DownloadItem("斗破苍穹完成", 70, 150, "TXT"),
    new DownloadItem("斗破苍穹完成", 50, 200, "PDF"),
  ]

  build() {
    Stack() {
      Row({ space: 12 }) {
        Scroll() {
          Row({ space: 12 }) {
            ForEach(this.questionsList, (item: string, index) => {
              Column() {
                Text(item)
                  .fontColor(this.currentScrollCardIndex === index ? '#FF6600' : 'rgba(0, 0, 0, 0.88)')
                  .fontSize(12)
                  .fontWeight(700)
              }
              .borderRadius(8)
              .padding(8)
              .backgroundColor(this.currentScrollCardIndex === index ? 'rgba(255, 102, 0, 0.12)' : 'rgb(240,240,240)')
              .onClick(() => {
                this.currentScrollCardIndex = index
              })
            })
          }
        }
        .align(Alignment.Start)
        .width("80%")
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)

        Blank(1)
        if (this.IsEdit === false) {
          Image($r('app.media.more_search'))
            .width(24)
            .onClick(() => {
              this.IsEdit = true
            })
        } else {
          Checkbox()
            .onChange((value: boolean) => {
              if (value === true) {

              } else {

              }
            })
        }
      }
      .width("100%")
      .margin({
        top: 55
      })
      .height(40)
      .padding({
        left: 20,
        right: 20
      })
      .zIndex(2)

      Tabs({
        barPosition: BarPosition.Start
      }) {
        TabContent() {
          Column() {
            if (this.DownloadingItemList.length > 0) {
              Row() {
                Text(`下载中 (${this.DownloadingItemList.length})`)
                  .opacity(0.45)
                  .lineHeight(20)
                  .font({
                    size: 12,
                    weight: 500
                  })
                Blank(1)
                Text("全部暂停")
                  .lineHeight(20)
                  .fontColor("#FF6600")
                  .font({
                    size: 12,
                    weight: 500
                  })
              }
              .width("100%")
              .padding({
                top: 12,
                bottom: 12
              })

              ForEach(this.DownloadingItemList, (item: DownloadItem) => {
                this.ShowItem(item, "Downloading")
              })
            }

            if (this.DownloadFinishItemList.length > 0) {
              Row() {
                Text(`已下载 (${this.DownloadFinishItemList.length})`)
                  .opacity(0.45)
                  .lineHeight(20)
                  .font({
                    size: 12,
                    weight: 500
                  })
              }
              .width("100%")
              .padding({
                top: 12,
                bottom: 12
              })

              ForEach(this.DownloadFinishItemList, (item: DownloadItem) => {
                this.ShowItem(item, "DownloadFinish")
              })
              Blank(1)
              Divider()
            }
          }
          .margin({
            top: 40
          })
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
            if (this.DownloadFinishItemList.length > 0) {
              Row() {
                Text(`已下载 (${this.DownloadFinishItemList.length})`)
                  .opacity(0.45)
                  .lineHeight(20)
                  .font({
                    size: 12,
                    weight: 500
                  })
              }
              .width("100%")
              .padding({
                top: 12,
                bottom: 12
              })

              ForEach(this.DownloadFinishItemList, (item: DownloadItem) => {
                this.ShowItem(item, "DownloadFinish")
              })
              Blank(1)
              Divider()
            }
          }
          .margin({
            top: 40
          })
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
    .alignContent(Alignment.TopStart)
    .padding({
      top: this.topRectHeight,
      bottom: this.bottomRectHeight
    })
  }

  @Builder
  ShowItem(item: DownloadItem, isFinish: string) {
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
          if (isFinish === "Downloading") {
            Text(`${item.downloadNumber}/${item.Total}`)
              .lineHeight(18)
              .opacity(0.45)
              .font({
                size: 10,
                weight: 500,
              })
          } else {
            Text(`全书已下载`)
              .lineHeight(18)
              .opacity(0.45)
              .font({
                size: 10,
                weight: 500,
              })
          }
        }
        .width("100%")
      }
      .width("60%")

      Blank(1)
      if (isFinish === "Downloading" && !this.IsEdit) {
        Progress({ value: item.downloadNumber / item.Total * 100, type: ProgressType.Ring })
          .width(32)
      } else if (this.IsEdit) {
        Checkbox({ name: `${item.bookName}`, group: 'checkboxGroup' })
      }
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
            if (this.IsEdit === true) {
              // 下面的flex是扩宽完成按钮的点击区域
              Flex({
                justifyContent: FlexAlign.End
              }) {
                Text("完成")
                  .lineHeight(22)
                  .font({
                    size: 14,
                    weight: 400
                  })
              }
              .width(50)
              .onClick(() => {
                this.IsEdit = false
              })
            } else {
              Image($r('app.media.Column_More'))
                .width(24)
                .onClick(() => {

                })
            }
          } else {
            if (this.IsEdit === true) {
              Text("全选")
                .lineHeight(22)
                .font({
                  size: 14,
                  weight: 400
                })
                .onClick(() => {

                })
            } else {
              Image($r('app.media.return_left'))
                .width(24)
                .onClick(() => {
                  router.back()
                })
            }
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