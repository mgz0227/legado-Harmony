// import router from '@ohos.router'; // 引入路由管理器

@Component
export default struct IndexSubscription {
  MoreList: string[] = ['粘贴导入', '网络导入', '本地导入', '新建订阅', '新建分组', '批量管理']
  @State SearchValue: string = ""
  ButtonList: string[] = ['起点中文网','test']

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
          Image($r('app.media.addSubscription')).width(24).bindMenu([
            {
              // icon: $r('app.media.import_svg'),
              value: this.MoreList[0],
              action: () => {
                // this.changeTheme(0)
              }
            },
            {
              // icon:$r('app.media.down_svg'),
              value: this.MoreList[1],
              action: () => {
                // this.changeTheme(1)
              }
            },
            {
              // icon: $r('app.media.import_book_svg'),
              value: this.MoreList[2],
              action: () => {
                // this.changeTheme(2)
              }
            },
            {
              // icon: $r('app.media.batch_svg'),
              value: this.MoreList[3],
              action: () => {
                // this.changeTheme(3)
              }
            },
            {
              // icon: $r('app.media.batch_svg'),
              value: this.MoreList[4],
              action: () => {
                // this.changeTheme(3)
              }
            },
            {
              // icon: $r('app.media.batch_svg'),
              value: this.MoreList[5],
              action: () => {
                // this.changeTheme(3)
              }
            },
          ])
        }
      }
      .height('10%')
      .width('100%')

      SubscriptionCard({ Title: "小说", ButtonList: this.ButtonList })
      SubscriptionCard({ Title: "漫画", ButtonList: this.ButtonList })
      SubscriptionCard({ Title: "收藏" })

    }
    .height('100%')
  }
}

@Component
struct SubscriptionCard {
  @State Title: string = ''
  @State ButtonList: string[] = []
  @State isShow: boolean = false
  @State BooTypeList:string[] = ['置顶','重命名', '移动至', '分享', '导出', '删除']

  build() {
    Column() {
      Row({ space: 20 }) {
        Text(this.Title)
        Blank(1)
        Image($r('app.media.more_sub'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.isShow = true
          })
          .bindSheet($$this.isShow, this.catalogMove(), {
            height: 300,
            showClose: false,
            dragBar: false,
            blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
            maskColor: 'rgba(0,0,0,0.6)',
            onDisappear: () => {
              // this.clickBookType = ''
              console.log('隐藏')
            }
          })
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
                Row({ space: 12 }) {
                  // Ellipse图片临时用，修改后记得删除
                  Image($r('app.media.Ellipse'))
                    .width(30)
                    .height(30)
                  Text(item)
                }
              }
              .onClick(() => {

              })
              .type(ButtonType.Normal)
              .backgroundColor("#FFFFFF")
              .width(154)
              .height(54)
              .margin({ left:15, bottom: 10 })
              .border({
                radius: 12
              })
            })

            //添加网址按钮
            Button() {
              Row({ space: 12 }) {
                Image($r('app.media.addURL'))
                  .width(30)
                  .height(30)
                Text("添加网址")
                  .fontColor("#000000")
                  .opacity(0.45)
              }
            }
            .type(ButtonType.Normal)
            .backgroundColor("#FFFFFF")
            .width(154)
            .height(54)
            .margin({ left:15, bottom: 10 })
            .border({
              radius: 12
            })
        }
    }
    .margin({
      bottom: 24
    })
  }

  @Builder catalogMove() {
    Column() {
      Scroll() {
        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Center,
          justifyContent: FlexAlign.Start
        }) {
          ForEach(this.BooTypeList,(item:string)=>{
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
        this.isShow = false
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

  @Builder title(title:string) {
    Column() {
        Image($r('app.media.Ellipse'))
          .width(24)
          .height(24)
          .margin({bottom:10})
        Text(title).fontSize(12).textOverflow({
          overflow:TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END).maxLines(1)
    }
    .onClick(()=>{

    })
    .margin({ left:5, bottom: 10 })
    .width(85).height(70)
    // .backgroundColor('rgba(0, 0, 0,0.06)')
    .padding({
      top:8,
    })
  }
}


