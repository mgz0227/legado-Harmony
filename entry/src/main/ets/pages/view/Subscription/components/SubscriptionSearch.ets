/**
 * @author 2008
 * @datetime 2024/7/13 23:33
 * @className: SubscriptionSearch
 * 订阅搜索页面
 * TODO 测试页面后续调整改为DB数据查询和数据读取
 */
import CommonConstants from '../../../../common/constants/CommonConstants';
import FontConstants from '../../../../common/constants/FontConstants';
import { router } from '@kit.ArkUI';
import PaddingConstants from '../../../../common/constants/PaddingConstants';
import { IconTitleVo } from '../../../../componetsmodel/IconTitleVo';
import ImageConstants from '../../../../common/constants/ImageConstants';

@Entry
@Component
struct SubscriptionSearch {
  @State @Watch('changeSearchValue')searchValue: string = '起点';
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State searchResult:IconTitleVo[] = []
  @State
  searchList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_subscription_lazy'), '懒人听书'),
    new IconTitleVo($r('app.media.icon_subscription_inn'), '漫客栈'),
    new IconTitleVo($r('app.media.icon_subscription_start'), '起点中文'),
    new IconTitleVo($r('app.media.icon_subscription_tencent'), '腾讯动漫'),
    new IconTitleVo($r('app.media.icon_subscription_college'), '潇湘书院'),
  ]

  onPageShow(): void {
    this.changeSearchValue()
  }

  onPageHide(): void {
    this.searchValue = ''
    this.searchResult = []
  }
  aboutToAppear(): void {
    this.changeSearchValue()
  }

  aboutToDisappear(): void {
    this.searchValue = ''
    this.searchResult = []
  }


  changeSearchValue(){
    console.log('模糊匹配中')
    if(this.searchValue.length > 0){
      this.searchResult = this.searchList.filter((item)=>{
        return item.title.indexOf(this.searchValue) !== -1
      })
    } else {
      this.searchResult = []
    }
  }
  build() {
    Column(){
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceEvenly
        }
      ) {
        Row({ space: 20 }) {
          Search({ value: $$this.searchValue, placeholder: '搜索订阅', icon: "/common/images/search.svg" })
            .layoutWeight(1)
            .height(40)
            .backgroundColor(Color.White)

          Text('取消').font({
            size: FontConstants.FONT_SIZE_14,
            weight: FontConstants.FONT_WEIGHT_400,
            family: CommonConstants.FAMILY_PingFANG
          })
            .onClick(() => {
              router.back()
          })
          .fontColor($r('app.string.color_black_88'))

        }
      }
      .height('10%')
      .width('100%')

      Scroll(){
        Column(){

          if (this.searchResult.length === 0){
            this.noResultLog()
          } else {
            this.searchBuilder()
          }
        }
      }
      .align(this.searchResult.length === 0? Alignment.Center:Alignment.Top)
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

  @Builder
  searchBuilder(){
    GridRow({
      columns: 5
    }){
      ForEach(this.searchResult,(item:IconTitleVo)=>{
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

  @Builder
  noResultLog(){
    Column({
      space:32
    }){
      Image($r('app.media.icon_no_find_search')).width(121).height(110)
      Text('暂无搜索结果')
        .font({
          size:14,
          weight:400,
          family:CommonConstants.FAMILY_PingFANG
        })
        .textAlign(TextAlign.Center)
        .fontColor($r('app.string.color_black_45'))

    }
  }
}