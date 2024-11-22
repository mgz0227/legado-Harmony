/**
 * @author 2008
 * @datetime 2024/7/13 23:33
 * @className: SubscriptionSearch
 * 订阅搜索页面
 */
import CommonConstants from '../../../../common/constants/CommonConstants';
import FontConstants from '../../../../common/constants/FontConstants';
import { router } from '@kit.ArkUI';
import PaddingConstants from '../../../../common/constants/PaddingConstants';
import ImageConstants from '../../../../common/constants/ImageConstants';
import { rssSources } from '../../../../database/entities/rssSources';
import SubscriptionDao from '../../../../database/dao/SubscriptionDao';
import { showMessage } from '../../../../componets/common/promptShow';
import rssSourcesUtils from '../../../../common/utils/rssSourcesUtils';
import PreviewEffectImage from './PreviewEffectImage';
import { ThemeItem } from '../../../../common/model/Theme';
import { ThemeStorageKey } from '../../../../common/constants/Theme';

@Entry
@Component
struct SubscriptionSearch {
  @State @Watch('changeSearchValue')searchValue: string = '起点';
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State
  searchList: rssSources[] = []
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  onPageShow(): void {
    this.changeSearchValue()
  }

  onPageHide(): void {
    // this.searchValue = ''
    // this.searchList = []
  }

  changeSearchValue(){
    if(this.searchValue.length > 0){
      this.searchSources()
    } else {
      this.searchList = []
    }
  }

  searchSources(){
    SubscriptionDao.search({
      searchKey: this.searchValue,
      enabled: true
    }).then(data =>{
      this.searchList = data
    })
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

          if (this.searchList.length === 0){
            this.noResultLog()
          } else {
            this.searchBuilder()
          }
        }
      }
      .align(this.searchList.length === 0? Alignment.Center:Alignment.Top)
      .padding({bottom:20})
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
    }
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [[this.theme.mainColor, 0], [this.theme.secondColor, 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
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
      ForEach(this.searchList,(item:rssSources)=>{
        GridCol(){
          Column({
            space: CommonConstants.SPACE_6
          }){
            PreviewEffectImage({
              customizeTitle:item.customizeTitle,
              sourceIcon:item.sourceIcon,
              sourceIconIsUrl:item.sourceIconIsUrl,
              isShowTitle:false,
              PreviewWidth:ImageConstants.IMG_WIDTH_40,
              PreviewHeight:ImageConstants.IMG_HEIGHT_40,
              sourceName:item.sourceName
            }).borderRadius(50)

            Text(`${item.sourceName}`).fontSize(10)
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(18)
              .fontFamily(CommonConstants.FAMILY_PingFANG)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
          }
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/view/Subscription/rssWebView',
              params: {
                url: item.sourceUrl
              }
            })
            rssSourcesUtils.pushRssSourcesHistory(item)
          })
          .margin({bottom:20})
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