/**
 * @author 2008
 * @datetime 2024/7/11 21:33
 * @className: Subscription
 * 新版订阅页面
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import FontConstants from '../../../common/constants/FontConstants'
import ImageConstants from '../../../common/constants/ImageConstants'
import PaddingConstants from '../../../common/constants/PaddingConstants'
import { IconTitleVo } from '../../../componetsmodel/IconTitleVo'

@Component
@Preview
export default struct SubscriptionIndex {
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State NewSubscription: Boolean = false
  @State
  moreList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_rule_paste'), '粘贴导入'),
    new IconTitleVo($r('app.media.icon_rule_export'), '本地导入'),
    new IconTitleVo($r('app.media.icon_rule_add'), '新建订阅'),
    new IconTitleVo($r('app.media.icon_rule_batch'), '批量管理'),
  ]


  build() {
    Column(){
      //搜索Start
      Flex(
        {
          direction:FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Row({
          space:CommonConstants.SPACE_20
        }) {
          Image($r('app.media.icon_subscription_index')).width(CommonConstants.COMMON_WIDTH_45_36).height(CommonConstants.COMMON_HEIGHT_21_6)
          Search({ placeholder: '搜索订阅', icon: "/common/images/search.svg" })
            .layoutWeight(1)
            .height(CommonConstants.COMMON_HEIGHT_40)
            .backgroundColor(Color.White)
        }
        .padding({right: PaddingConstants.PADDING_16})
        Image($r('app.media.addSubscription')).width(ImageConstants.IMG_WIDTH_24).height(ImageConstants.IMG_HEIGHT_24).bindMenu(this.MenuBuilder)
      }
      .height('8%')
      //搜索End

      Scroll(){
        Column(){
          //最近使用Start
          if (this.RecentlyUsed.length !== 0){
            Column(){
              Flex({
                justifyContent:FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text('最近使用')
                  .font({
                    size:12,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_88'))
                  .lineHeight(20)
                  .padding({
                    top: PaddingConstants.PADDING_12,
                    bottom: PaddingConstants.PADDING_12
                  })

                Text('清空')
                  .font({
                    size:12,
                    weight:FontConstants.FONT_WEIGHT_400,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_45'))
                  .lineHeight(20)
                  .padding({
                    top: PaddingConstants.PADDING_12,
                    bottom: PaddingConstants.PADDING_12
                  })
              }
              this.RecentlyUsedBuilder()
            }
          }
          //最近使用End

          //漫画Start
          Column({
            space:20
          }){
            Flex({
              justifyContent:FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center,
              alignContent: FlexAlign.Center
            }) {
              Row({
                space:CommonConstants.SPACE_12
              }){
                Text('漫画')
                  .font({
                    size:FontConstants.FONT_SIZE_16,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_88'))
                  .lineHeight(24)
                  .padding({
                    top: PaddingConstants.PADDING_12,
                  })
                Text('长按编辑')
                  .font({
                    size:12,
                    weight:FontConstants.FONT_WEIGHT_400,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_45'))
                  .lineHeight(20)
                  .padding({
                    top: PaddingConstants.PADDING_12,

                  })
              }.alignItems(VerticalAlign.Bottom)

              Image($r('app.media.more'))
                .fillColor($r('app.string.color_black_45'))
                .width(ImageConstants.IMG_WIDTH_24)
                .height(ImageConstants.IMG_HEIGHT_24)
            }

            Flex({
              justifyContent:FlexAlign.SpaceBetween
            }){
              Row({
                space:12
              }){
                Image($r('app.media.icon_subscription_tencent'))
                  .width(ImageConstants.IMG_WIDTH_24)
                  .height(ImageConstants.IMG_HEIGHT_24)
                  .borderRadius(4)
                Text('腾讯动漫')
                  .font({
                    size:14,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .lineHeight(22)
                  .fontColor($r('app.string.color_black_88'))
              }
              .borderRadius(12)
              .backgroundColor('#FFE5D4')
              .padding(PaddingConstants.PADDING_12)
              .width('48%')

              Row({
                space:12
              }){
                Image($r('app.media.bilibili'))
                  .width(ImageConstants.IMG_WIDTH_24)
                  .height(ImageConstants.IMG_HEIGHT_24)
                  .borderRadius(4)
                Text('bilibili漫画')
                  .font({
                    size:14,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .lineHeight(22)
                  .fontColor($r('app.string.color_black_88'))
              }
              .borderRadius(12)
              .backgroundColor('#FFE3ED')
              .padding(PaddingConstants.PADDING_12)
              .width('48%')
            }
            this.CartoonBuilder()
          }
          .margin({top: PaddingConstants.PADDING_12})
          .borderRadius(12)
          .backgroundColor(Color.White)
          .padding(20)
          //漫画End

          //小说Start
          Column({
            space:20
          }){
            Flex({
              justifyContent:FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center,
              alignContent: FlexAlign.Center
            }) {
              Row({
                space:CommonConstants.SPACE_12
              }){
                Text('小说')
                  .font({
                    size:FontConstants.FONT_SIZE_16,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_88'))
                  .lineHeight(24)
                  .padding({
                    top: PaddingConstants.PADDING_12,
                  })
                Text('长按编辑')
                  .font({
                    size:12,
                    weight:FontConstants.FONT_WEIGHT_400,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_45'))
                  .lineHeight(20)
                  .padding({
                    top: PaddingConstants.PADDING_12,

                  })
              }.alignItems(VerticalAlign.Bottom)

              Image($r('app.media.more'))
                .fillColor($r('app.string.color_black_45'))
                .width(ImageConstants.IMG_WIDTH_24)
                .height(ImageConstants.IMG_HEIGHT_24)
            }

            Flex({
              justifyContent:FlexAlign.SpaceBetween
            }){
              Row({
                space:12
              }){
                Image($r('app.media.icon_subscription_start'))
                  .width(ImageConstants.IMG_WIDTH_24)
                  .height(ImageConstants.IMG_HEIGHT_24)
                  .borderRadius(4)
                Text('起点中文')
                  .font({
                    size:14,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .lineHeight(22)
                  .fontColor($r('app.string.color_black_88'))
              }
              .borderRadius(12)
              .backgroundColor('#FCDFDF')
              .padding(PaddingConstants.PADDING_12)
              .width('48%')

              Row({
                space:12
              }){
                Image($r('app.media.icon_subscription_jinjiang'))
                  .width(ImageConstants.IMG_WIDTH_24)
                  .height(ImageConstants.IMG_HEIGHT_24)
                  .borderRadius(4)
                Text('晋江小说')
                  .font({
                    size:14,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .lineHeight(22)
                  .fontColor($r('app.string.color_black_88'))
              }
              .borderRadius(12)
              .backgroundColor('#E2F4E4')
              .padding(PaddingConstants.PADDING_12)
              .width('48%')
            }
            this.novelBuilder()
          }
          .margin({top: PaddingConstants.PADDING_12})
          .borderRadius(12)
          .backgroundColor(Color.White)
          .padding(20)
          //小说End

          //收藏夹Start
          Column({
            space:20
          }){
            Flex({
              justifyContent:FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center,
              alignContent: FlexAlign.Center
            }) {
              Row({
                space:CommonConstants.SPACE_12
              }){
                Text('收藏夹')
                  .font({
                    size:FontConstants.FONT_SIZE_16,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_88'))
                  .lineHeight(24)
                  .padding({
                    top: PaddingConstants.PADDING_12,
                  })
                Text('长按编辑')
                  .font({
                    size:12,
                    weight:FontConstants.FONT_WEIGHT_400,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .fontColor($r('app.string.color_black_45'))
                  .lineHeight(20)
                  .padding({
                    top: PaddingConstants.PADDING_12,

                  })
              }.alignItems(VerticalAlign.Bottom)

              Image($r('app.media.more'))
                .fillColor($r('app.string.color_black_45'))
                .width(ImageConstants.IMG_WIDTH_24)
                .height(ImageConstants.IMG_HEIGHT_24)
            }

            Flex({
              justifyContent:FlexAlign.SpaceBetween
            }){
              Row({
                space:12
              }){
                Image($r('app.media.icon_subscription_tencent'))
                  .width(ImageConstants.IMG_WIDTH_24)
                  .height(ImageConstants.IMG_HEIGHT_24)
                  .borderRadius(4)
                Text('腾讯动漫')
                  .font({
                    size:14,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .lineHeight(22)
                  .fontColor($r('app.string.color_black_88'))
              }
              .borderRadius(12)
              .backgroundColor('#FFE5D4')
              .padding(PaddingConstants.PADDING_12)
              .width('48%')

              Row({
                space:12
              }){
                Image($r('app.media.bilibili'))
                  .width(ImageConstants.IMG_WIDTH_24)
                  .height(ImageConstants.IMG_HEIGHT_24)
                  .borderRadius(4)
                Text('bilibili漫画')
                  .font({
                    size:14,
                    weight:FontConstants.FONT_WEIGHT_500,
                    family: CommonConstants.FAMILY_PingFANG
                  })
                  .lineHeight(22)
                  .fontColor($r('app.string.color_black_88'))
              }
              .borderRadius(12)
              .backgroundColor('#FFE3ED')
              .padding(PaddingConstants.PADDING_12)
              .width('48%')
            }
            this.CartoonBuilder()
          }
          .margin({top: PaddingConstants.PADDING_12})
          .borderRadius(12)
          .backgroundColor(Color.White)
          .padding(20)
          //收藏夹End
        }
      }
      .padding({bottom:20})
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)


    }
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [["rgb(254, 203, 169)", 0], ["RGB(245, 245, 245)", 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .padding({
      top: this.topRectHeight,
      left: PaddingConstants.PADDING_20,
      right: PaddingConstants.PADDING_20
    }
    )
    .height('100%')
  }

  //最近使用列
  @State
  RecentlyUsed: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_subscription_lazy'), '懒人听书'),
    new IconTitleVo($r('app.media.icon_subscription_inn'), '漫客栈'),
    new IconTitleVo($r('app.media.icon_subscription_start'), '起点中文'),
    new IconTitleVo($r('app.media.icon_subscription_tencent'), '腾讯动漫'),
    new IconTitleVo($r('app.media.icon_subscription_college'), '潇湘书院'),
  ]

  @Builder
  RecentlyUsedBuilder(){
    GridRow({
      columns: 5
    }){
      ForEach(this.RecentlyUsed,(item:IconTitleVo)=>{
        GridCol(){
          Column({
            space: CommonConstants.SPACE_6
          }){
            Image(item.icon)
              .width(ImageConstants.IMG_WIDTH_40)
              .height(ImageConstants.IMG_HEIGHT_40)
              .borderRadius(50)

            Text(`${item.title}`).fontSize(10)
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(18)
              .fontFamily(CommonConstants.FAMILY_PingFANG)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
          }.margin({bottom:20})
        }
      })

    }
  }


  //漫画列
  @State
  CartoonList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_subscription_quick_see'), '快看漫画'),
    new IconTitleVo($r('app.media.icon_subscription_dongman'), '咚漫漫画'),
    new IconTitleVo($r('app.media.icon_subscription_inn'), '漫客栈'),
    new IconTitleVo($r('app.media.icon_subscription_bosom_friend'), '知音漫客'),
    new IconTitleVo($r('app.media.icon_subscription_podo'), 'PODO'),
  ]
  @Builder
  CartoonBuilder(){
    GridRow({
      columns: 5
    }){
      ForEach(this.CartoonList,(item:IconTitleVo)=>{
        GridCol(){
          Column({
            space: CommonConstants.SPACE_6
          }){
            Image(item.icon)
              .width(ImageConstants.IMG_WIDTH_40)
              .height(ImageConstants.IMG_HEIGHT_40)
              .borderRadius(8)

            Text(`${item.title}`).fontSize(10)
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(18)
              .fontFamily(CommonConstants.FAMILY_PingFANG)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
          }.margin({bottom:20})
        }
      })

    }
  }


  //小说列
  @State
  novelList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_subscription_qq'), 'QQ阅读'),
    new IconTitleVo($r('app.media.icon_subscription_red'), '红袖读书'),
    new IconTitleVo($r('app.media.icon_subscription_zongheng'), '纵横小说'),
    new IconTitleVo($r('app.media.icon_subscription_17k'), '17K小说'),
    new IconTitleVo($r('app.media.icon_subscription_college'), '潇湘书院'),
    new IconTitleVo($r('app.media.icon_subscription_xigua'), '番茄小说'),
    new IconTitleVo($r('app.media.icon_subscription_shuqi'), '书旗小说'),
    new IconTitleVo($r('app.media.icon_subscription_motie'), '磨铁阅读'),
    new IconTitleVo($r('app.media.icon_subscription_feilu'), '飞卢小说'),
    new IconTitleVo($r('app.media.icon_subscription_yanyan'), '盐言故事'),
  ]
  @Builder
  novelBuilder(){
    GridRow({
      columns: 5,
    }){
      ForEach(this.novelList,(item:IconTitleVo)=>{
        GridCol(){
          Column({
            space: CommonConstants.SPACE_6
          }){
            Image(item.icon)
              .width(ImageConstants.IMG_WIDTH_40)
              .height(ImageConstants.IMG_HEIGHT_40)
              .borderRadius(8)

            Text(`${item.title}`).fontSize(10)
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(18)
              .fontFamily(CommonConstants.FAMILY_PingFANG)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
          }.margin({bottom:20})
        }
      })

    }
  }

  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column }) {
      ForEach(this.moreList, (item: IconTitleVo, index) => {
        Column() {
          Row() {
            Image(item.icon)
              .width(24)
              .height(24)
              .margin({
                right: 5
              })
            Text(`${item.title}`).fontSize(14)
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

    }
  }
}