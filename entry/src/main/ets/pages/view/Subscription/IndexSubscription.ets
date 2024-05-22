// import router from '@ohos.router'; // 引入路由管理器

@Component
export default struct IndexSubscription {
  MoreList: string[] = ['粘贴导入', '网络导入', '本地导入', '新建订阅', '新建分组', '批量管理']
  NovelList: string[] = ['起点中文网', '小说']
  CartoonList: string[] = ['卡通']
  CollectList: string[] = ['起点中文网', '收藏', '收藏', '收藏']

  @State SearchValue: string = ""
  @State ShowEditManage: Boolean = false
  @State NewSubscription: Boolean = false

  build() {
    Column() {
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceEvenly
        }
      ) {
        Row({ space: 20 }) {
          Text("订阅")
          Search({ value: this.SearchValue, placeholder: '搜索订阅', icon: "/common/images/search.svg" })
            .width("60%")
            .height(40)
          // .onChange(this.onChange)
          // .onSubmit(this.onSubmit);
          Image($r('app.media.addSubscription')).width(24).bindMenu(this.MenuBuilder)
        }
      }
      .height('10%')
      .width('100%')

      SubscriptionCard({
        Title: "小说",
        ButtonList: this.NovelList,
        ShowEditManage: this.ShowEditManage
      })
      SubscriptionCard({
        Title: "漫画",
        ButtonList: this.CartoonList,
        ShowEditManage: this.ShowEditManage

      })
      SubscriptionCard({
        Title: "收藏",
        ButtonList: this.CollectList,
        ShowEditManage: this.ShowEditManage
      })
    }
    .height('100%')
  }

  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column }) {
      ForEach(this.MoreList, (item: String, index) => {
        Column() {
          Row() {
            Image($r('app.media.addSubscription'))
              .width(24)
              .height(24)
              .margin({
                right: 5
              })
            Text(`${item}`).fontSize(14)
          }
          .height(40)
          .justifyContent(FlexAlign.Center)
          .align(Alignment.Center)
          .onClick(() => {
            this.MenuOnclick(index)
          })

          if(index !== 5){
            Divider()
          }
        }

        .padding(5)
        .height(40)
        .margin({ bottom: 20 })
      })
    }
    // 点击 本地导入 时的半模态转场
    .bindSheet($$this.NewSubscription, this.NewSubscriptionDialog(), {
      height: 300,
      showClose: false,
      dragBar: false,
      blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
      onDisappear: () => {
        // this.clickBookType = ''
      }
    })
    .width(100)
  }

  @Builder
  NewSubscriptionDialog() {
    Column() {
      Scroll() {
        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Center,
          justifyContent: FlexAlign.Start
        }) {
          // ForEach(this.BooTypeList, (item: string) => {
          //   this.title(item)
          // })
        }
      }
      .height('65%')
      .scrollBar(BarState.Off)

      Divider()

      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(() => {
        this.NewSubscription = false
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 32,
        right: 32,
        top: 16
      })
    }

    // .width(CommonConstants.FULL_WIDTH)
    // .height(CommonConstants.FULL_HEIGHT)
  }

  MenuOnclick(value:number|string){
    // MoreList: string[] = ['粘贴导入', '网络导入', '本地导入', '新建订阅', '新建分组', '批量管理']
    switch (value){
      case 0:

        break
      case 1:

        break
      case 2:
        this.NewSubscription =true
        break
      case 3:
        break
      case 4:

        break
      case 5:
        this.ShowEditManage = !this.ShowEditManage
        break
    }
  }
}




@Component
struct SubscriptionCard {
  @State Title: string = ''
  @State ButtonList: string[] = []
  @State isCardShowMore: boolean = false
  @State BooTypeList: string[] = ['置顶', '重命名', '移动至', '分享', '导出', '删除']
  @Prop ShowEditManage: Boolean = false

  build() {
    Column() {
      Row({ space: 20 }) {
        Text(this.Title)
        Blank(1)
        if (this.ShowEditManage) {
          Checkbox({})
        } else {
          Image($r('app.media.more_sub'))
            .width(24)
            .height(24)
            .onClick(() => {
              this.isCardShowMore = true
            })
            .bindSheet($$this.isCardShowMore, this.catalogMove(), {
              height: 300,
              showClose: false,
              dragBar: false,
              blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
              maskColor: 'rgba(0,0,0,0.6)',
              onDisappear: () => {
                // this.clickBookType = ''
              }
            })
        }
      }
      .width("88%")
      .margin({
        bottom: 12
      })

      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Center,
        justifyContent: FlexAlign.Start
      }) {
        ForEach(this.ButtonList, (item: string) => {
          Button() {
            Row() {
              // Ellipse图片临时用，修改后记得删除
              Image($r('app.media.Ellipse'))
                .width(30)
                .height(30)
              Text(item)
                .fontSize(14)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .ellipsisMode(EllipsisMode.END)
                .maxLines(1)
                .width(this.ShowEditManage? "45%" : null)
                .margin({
                  left:12
                })
              if (this.ShowEditManage) {
                Blank(1)
                Checkbox({})
              }
            }
            .width("100%")
            .padding({
              left:15,
              right:15
            })
          }
          .onClick(() => {

          })
          .type(ButtonType.Normal)
          .backgroundColor("#FFFFFF")
          .width(154)
          .height(54)
          .margin({ left: 15, bottom: 10 })
          .border({
            radius: 12
          })
        })

        //添加网址按钮
        Button() {
          Row() {
            Image($r('app.media.addURL'))
              .width(30)
              .height(30)
            Text("添加网址")
              .fontSize(14)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(1)
              .width(this.ShowEditManage? "45%" : null)
              .margin({
                left:12
              })
              .fontColor("#000000")
              .opacity(0.45)
          }
          .width("100%")
          .padding({
            left:15,
            right:15
          })
        }
        .type(ButtonType.Normal)
        .backgroundColor("#FFFFFF")
        .width(154)
        .height(54)
        .margin({ left: 15, bottom: 10 })
        .border({
          radius: 12
        })
      }
    }
    .margin({
      bottom: 24
    })
  }

  @Builder
  catalogMove() {
    Column() {
      Scroll() {
        Flex({
          direction: FlexDirection.Row,
          wrap: FlexWrap.Wrap,
          alignContent: FlexAlign.Center,
          justifyContent: FlexAlign.Start
        }) {
          ForEach(this.BooTypeList, (item: string) => {
            this.title(item)
          })
        }
      }
      .height('65%')
      .scrollBar(BarState.Off)

      Divider()

      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(() => {
        this.isCardShowMore = false
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 32,
        right: 32,
        top: 16
      })
    }

    // .width(CommonConstants.FULL_WIDTH)
    // .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder
  title(title: string) {
    Column() {
      Image($r('app.media.Ellipse'))
        .width(24)
        .height(24)
        .margin({ bottom: 10 })
      Text(title).fontSize(12).textOverflow({
        overflow: TextOverflow.Ellipsis
      }).ellipsisMode(EllipsisMode.END).maxLines(1)
    }
    .onClick(() => {

    })
    .margin({ left: 5, bottom: 10 })
    .width(85)
    .height(70)
    // .backgroundColor('rgba(0, 0, 0,0.06)')
    .padding({
      top: 8,
    })
  }
}