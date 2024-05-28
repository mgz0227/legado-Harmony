import { router } from '@kit.ArkUI';
import picker from '@ohos.file.picker';
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

PersistentStorage.persistProp('ExportSettingList', [false, false, false, false, false]);

@Entry
@Component
struct DownloadManagementPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State currentTabIndex: number = 0
  @State currentScrollCardIndex: number = 0
  @State SearchValue: string = ""
  @State IsEdit: boolean = false
  @State isShowExportSetting: boolean = false
  @StorageLink('ExportSettingList') ExportSettingList: Array<boolean> = [false, false, false, false, false]
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
  @State ExportFinishList: DownloadItem[] = [
    new DownloadItem("斗破苍穹导出", 12, 100, "EPUB"),
    new DownloadItem("斗破苍穹导出", 70, 150, "TXT"),
    new DownloadItem("斗破苍穹导出", 50, 200, "PDF"),
  ]

  build() {
    Stack() {
      if (this.IsEdit === false) {
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
          Image($r('app.media.more_search'))
            .width(24)
            .onClick(() => {
              this.IsEdit = true
            })
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
      }


      Tabs({
        barPosition: BarPosition.Start
      }) {
        TabContent() {
          Column() {
            // 下载-下载中
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
                if (this.IsEdit) {
                  CheckboxGroup({ group: 'DownloadingItemList' })
                } else {
                  Text("全部暂停")
                    .lineHeight(20)
                    .fontColor("#FF6600")
                    .font({
                      size: 12,
                      weight: 500
                    })
                }
              }
              .width("100%")
              .padding({
                top: 12,
                bottom: 12
              })

              ForEach(this.DownloadingItemList, (item: DownloadItem) => {
                this.ShowItem(item, "Downloading", 0)
              })
            }
            // 下载-已下载
            if (this.DownloadFinishItemList.length > 0) {
              Row() {
                Text(`已下载 (${this.DownloadFinishItemList.length})`)
                  .opacity(0.45)
                  .lineHeight(20)
                  .font({
                    size: 12,
                    weight: 500
                  })
                Blank(1)
                if (this.IsEdit) {
                  CheckboxGroup({ group: 'DownloadFinishItemList' })
                }
              }
              .width("100%")
              .padding({
                top: 12,
                bottom: 12
              })

              ForEach(this.DownloadFinishItemList, (item: DownloadItem) => {
                this.ShowItem(item, "DownloadFinish", 0)
              })
              Blank(1)
              Divider()
            }
          }
          .margin({
            top: this.IsEdit ? 0 : 40
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
            // 导出-已下载
            if (this.DownloadFinishItemList.length > 0 && !this.IsEdit) {
              Row() {
                Text(`已下载 (${this.DownloadFinishItemList.length})`)
                  .opacity(0.45)
                  .lineHeight(20)
                  .font({
                    size: 12,
                    weight: 500
                  })
                Blank(1)

                Text("全部导出")
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

              ForEach(this.DownloadFinishItemList, (item: DownloadItem) => {
                this.ShowItem(item, "DownloadFinish", 1)
              })
            }

            // 导出-已导出
            if (this.ExportFinishList.length > 0) {
              Row() {
                Text(`已导出 (${this.ExportFinishList.length})`)
                  .opacity(0.45)
                  .lineHeight(20)
                  .font({
                    size: 12,
                    weight: 500
                  })
                Blank(1)
                if (this.IsEdit) {
                  CheckboxGroup({ group: 'ExportFinishList' })
                } else {
                  Text("查看文件")
                    .lineHeight(20)
                    .fontColor("#FF6600")
                    .font({
                      size: 12,
                      weight: 500
                    })
                }
              }
              .width("100%")
              .padding({
                top: 12,
                bottom: 12
              })

              ForEach(this.ExportFinishList, (item: DownloadItem) => {
                this.ShowItem(item, "ExportFinish", 1)
              })
              Blank(1)
              Divider()
            }

          }
          .margin({
            top: this.IsEdit ? 0 : 40
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
  ShowItem(item: DownloadItem, itemType: string, currentTab: number) { // currentTab: 0 下载;1 导出
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
          if (itemType === "Downloading") {
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
      .width("55%")

      Blank(1)
      if (!this.IsEdit && itemType === "Downloading") {
        Progress({ value: item.downloadNumber / item.Total * 100, type: ProgressType.Ring })
          .width(32)
      } else if (this.IsEdit && itemType === "Downloading") {
        Checkbox({ name: `${item.bookName}`, group: 'DownloadingItemList' })
      } else if (this.IsEdit && itemType === "DownloadFinish" && currentTab === 0) {
        // 下载页的已下载
        Checkbox({ name: `${item.bookName}`, group: 'DownloadFinishItemList' })
      } else if (itemType === "DownloadFinish" && currentTab === 1) {
        // 导出页的已下载
        Progress({ value: 50, total: 100, type: ProgressType.Capsule })
          .color("#FF6600")
          .backgroundColor("#FFAF7A")
          .value(50)
          .width(68)
          .height(28)
          .style({ content: '50%', font: { size: 12, weight: 500 }, fontColor: "#FFFFFF", })
      } else if (this.IsEdit && itemType === "ExportFinish") {
        Checkbox({ name: `${item.bookName}`, group: 'ExportFinishList' })
      }
    }
    .padding({
      top: 10,
      bottom: 10
    })
    .width("100%")
  }

  @Builder
  ExportSettingDialog() {
    Column() {
      Row() {
        Text("导出设置")
          .lineHeight(24)
          .font({
            size: 16,
            weight: 500
          })
      }
      .padding({
        top: 12,
        bottom: 12
      })

      this.ExportSettingSwitchItem(0, "替换净化")
      this.ExportSettingSwitchItem(1, "TXT不导出章节名")
      this.ExportSettingSwitchItem(2, "TXT导出图片")
      this.ExportSettingSwitchItem(3, "多线程导出TXT")
      this.ExportSettingSwitchItem(4, "导出同时上传一份至云盘")

      this.ExportSettingClickItem(5, "导出格式", "TXT")
      this.ExportSettingClickItem(6, "导出路径", "/storage/emulated/阅读")
      this.ExportSettingClickItem(7, "文件命名", "")

      Blank(1)
      Divider()
      Row() {
        Text("取消")
      }
      .justifyContent(FlexAlign.Center)
      .width("100%")
      .onClick(() => {
        this.isShowExportSetting = false
      })
      .padding({
        top: 16,
        bottom: 16
      })
    }
    .padding({
      left: 20,
      right: 20
    })
  }

  @Builder
  ExportSettingSwitchItem(index: number, title: string) {
    Row() {
      Text(title)
        .lineHeight(22)
        .font({
          size: 14,
          weight: 400
        })
      Blank(1)
      Toggle({ type: ToggleType.Switch, isOn: this.ExportSettingList[index] })
        .onChange((value) => {
          this.ExportSettingList[index] = value // 按钮状态同步到数组对应元素
        })
      Text(this.ExportSettingList[index].toString()) // 验证按钮是否双向同步
    }
    .padding({
      top: 12,
      bottom: 12
    })
    .width("100%")
  }

  @Builder
  ExportSettingClickItem(index: number, title: string, rightString: string) {
    Row() {
      Text(title)
        .lineHeight(22)
        .font({
          size: 14,
          weight: 400
        })
      Blank(1)
      if (rightString) {
        Text(rightString)
          .lineHeight(20)
          .font({
            size: 12,
            weight: 400
          })
          .opacity(0.45)
      }
      Image($r('app.media.right'))
        .width(24)
        .onClick(() => {
          switch (index) {
            case 5:
              break
            case 6:
              break
            case 7:
              break
          }
        })
    }
    .padding({
      top: 12,
      bottom: 12
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
                .bindSheet($$this.isShowExportSetting, this.ExportSettingDialog(), {
                  height: 520,
                  showClose: false,
                  dragBar: false,
                  blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
                  onDisappear: () => {
                    // this.clickBookType = ''
                  }
                })
                .onClick(() => {
                  this.isShowExportSetting = true
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