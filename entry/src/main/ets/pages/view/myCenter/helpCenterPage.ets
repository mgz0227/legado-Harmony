import { router } from '@kit.ArkUI';

@Entry
@Component
struct HelpCenterPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State SearchValue: string = ""
  @State MoreQuestionsIndex: number = 0
  @State MoreQuestionsRightWidth: number | string = 0
  @State questionsList: Array<string> = ["热门问题", "校验问题", "书源问题", "订阅问题", "xx问题"]
  @State questionsShowList: Array<string> = [
    "1、为什么第一次安装好后什么都没有？",
    "2、遇到目录为空怎么办？",
    "3、替换净化是什么？",
  ]
  // @State tutorialQuestionsList: Array<string> = [
  //   "书源制作教程",
  //   "订阅源源制作教程",
  //   "替换净化教程",
  // ]
  @State MoreQuestionsSideBarList: Array<string> = [
    "热门问题",
    "书源校验",
    "书源",
    "订阅源",
    "备份",
    "替换净化",
    "有声书",
    "朗读引擎",
    "其他问题",
  ]
  @State MoreQuestionsItemList: Array<string> = [
    "为什么第一次安装好后打开什么都没有",
    "遇到目录为空怎么办",
    "替换净化是什么",
    "如何进行云备份",
    "如何导入本地书籍"
  ]
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Start,
        justifyContent: FlexAlign.Start
      }) {
        // 顶部固定内容
        Flex() {
          Column() {
            Image($r("app.media.return_left"))
              .size({ width: 24, height: 24 })
              .interpolation(ImageInterpolation.Medium)
              .onClick(() => {
                router.back()
              })
          }
          .alignItems(HorizontalAlign.Start)
          .width('33%')

          Column() {
            Text(`帮助中心`)
              .lineHeight(24)
              .font({
                family: "PingFang SC",
                size: 16,
                weight: 500,
                style: FontStyle.Normal,
              })
          }.width('33%')
        }
        .padding({
          top: 12,
          bottom: 12,
        })
        .height(48)
        .width("100%")

        Search({ value: this.SearchValue, placeholder: '搜索问题关键词', icon: "/common/images/search.svg" })
          .width("100%")
          .height(40)
        // .onChange(this.onChange)
        // .onSubmit(this.onSubmit)
      }
      .padding({
        left: 20,
        right: 20
      })
      .height(110)

      Scroll(this.scroller) {
        Flex({
          direction: FlexDirection.Row,
        }) {
          Flex({
            direction: FlexDirection.Column,
          }) {
            // 帮助中心左页
            Column() {
              Row() {
                Text("猜你想问")
                  .lineHeight(24)
                  .font({
                    family: "PingFang SC",
                    size: 16,
                    weight: 500,
                    style: FontStyle.Normal,
                  })
                Blank(20)
                Row() {
                  Text("更多问题")
                    .lineHeight(22)
                    .opacity(0.45)
                    .font({
                      family: "PingFang SC",
                      size: 14,
                      weight: 400,
                      style: FontStyle.Normal,
                    })
                  Image($r("app.media.right"))
                    .width(24)
                    .height(24)
                    .opacity(0.45)
                    .interpolation(ImageInterpolation.Medium)
                }
                .onClick(() => {
                  this.scroller.scrollEdge(Edge.End)
                })
              }
              .width("100%")

              Row() {
                Scroll() {
                  Row({ space: 12 }) {
                    ForEach(this.questionsList, (item: string, index) => {
                      this.question(item, index)
                    })
                  }
                }
                .scrollBar(BarState.Off)
                .scrollable(ScrollDirection.Horizontal)
              }
              .margin({
                top: 16,
                bottom: 16
              })
              .width("100%")

              ForEach(this.questionsShowList, (item: string, index) => {
                Row() {
                  Text(item)
                    .lineHeight(22)
                    .font({
                      family: "PingFang SC",
                      size: 14,
                      weight: 400,
                      style: FontStyle.Normal,
                    })
                  Blank(20)
                  Image($r("app.media.right"))
                    .width(24)
                    .height(24)
                    .interpolation(ImageInterpolation.Medium)
                    .onClick(() => {

                    })
                }
                .margin({
                  top: 12,
                  bottom: 12
                })
                .width("100%")
              })
            }
            .borderRadius(12)
            .width("100%")
            .backgroundColor("#FFFFFF")
            .padding({
              top: 20,
              left: 16,
              right: 16
            })
            .margin({
              bottom: 16
            })
          }
          .padding({
            left: 20,
            right: 20
          })

          Column() {
            // 帮助中心右页，点击 更多问题 的页面显示
            Row() {
              SideBarContainer(SideBarContainerType.Overlay) {
                Column() {
                  ForEach(this.MoreQuestionsSideBarList, (item: string, index) => {
                    Row() {
                      if (this.MoreQuestionsIndex == index) {
                        Line({ width: 3, height: 16 })
                          .backgroundColor('#FF6600')
                      }
                      Text(item)
                        .lineHeight(22)
                        .font({
                          family: "PingFang SC",
                          size: 14,
                          weight: 500,
                          style: FontStyle.Normal,
                        })
                        .width("100%")
                        .textAlign(TextAlign.Center)
                    }
                    .height(48)
                    .width("100%")
                    .backgroundColor(this.MoreQuestionsIndex == index ? "#F5F5F5" : "white")
                    .onClick(() => {
                      this.MoreQuestionsIndex = index
                    })
                  })
                }
              }
              .showControlButton(false)
              .width("24.4%") // 88/360
              .borderRadius({
                topRight: 12,
                bottomRight: 12
              })

              // 右侧内容显示
              Column() {
                ForEach(this.MoreQuestionsItemList, (item: string, index) => {
                  Row() {
                    Text(item)
                      .width(200)
                      .lineHeight(22)
                      .font({
                        family: "PingFang SC",
                        size: 14,
                        weight: 500,
                        style: FontStyle.Normal,
                      })
                    Blank(20)
                    Image($r("app.media.right"))
                      .width(24)
                      .height(24)
                      .opacity(0.45)
                      .interpolation(ImageInterpolation.Medium)
                  }
                  .padding({
                    top: 12,
                    bottom: 12
                  })
                  .width("100%")
                })
              }
              .padding({
                left: 16,
                right: 16
              })
              .height("100%")
              .width("75.6%") // (360-88)/360

            }
            .width("100%")
            .height(432)
          }

        }
        .width("200%")
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .scrollSnap({ snapAlign: ScrollSnapAlign.START, snapPagination: "100%" })
    }
    .height("100%")
    .backgroundColor("#F5F5F5")
    .padding({
      top: this.topRectHeight
    })
  }

  @Builder
  question(title: string, index: number) {
    Column() {
      Text(title)
        .fontColor(index == 0 ? '#FF6600' : 'rgba(0, 0, 0, 0.88)')
        .fontSize(12)
        .fontWeight(700)
    }
    .borderRadius(8)
    .padding(8)
    .backgroundColor(index == 0 ? 'rgba(255, 102, 0, 0.12)' : 'rgb(240,240,240)')
  }
}