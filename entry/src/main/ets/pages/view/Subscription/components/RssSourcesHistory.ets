/**
 * @author 2008
 * @datetime 2024/7/20 15:20
 * @className: RssSourcesHistory
 * 最近使用历史记录
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import ImageConstants from '../../../../common/constants/ImageConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import rssSourcesHistoryDao from '../../../../database/dao/RssSourcesHistoryDao'
import { rssSourcesHistory } from '../../../../database/entities/rssSourcesHistory'
import PreviewEffectImage from './PreviewEffectImage'
import { router } from '@kit.ArkUI'
import rssSourcesUtils from '../../../../common/utils/rssSourcesUtils'

@Component
export default struct RssSourcesHistory{
  //最近使用列
  @Prop
  RecentlyUsed: rssSourcesHistory[] = []

  build() {
    Column(){
      if (this.RecentlyUsed.length > 0){
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
            .onClick(()=>{
              rssSourcesHistoryDao.deleteRssSourcesHistoryList(this.RecentlyUsed)
              this.RecentlyUsed = []
            })
        }
        Flex(){
          this.RecentlyUsedBuilder()
        }
      }
    }.justifyContent(FlexAlign.Start)
  }
  scroller: Scroller = new Scroller()
  @Builder
  RecentlyUsedBuilder(){
    List({
      scroller:this.scroller,
      space:PaddingConstants.PADDING_24
    }){
      ForEach(this.RecentlyUsed,(item:rssSourcesHistory,index:number)=>{
        ListItem(){
          Column({
            space: CommonConstants.SPACE_6
          }){
            PreviewEffectImage({
              sourceIcon:item.sourceIcon,
              customizeTitle:item.customizeTitle,
              PreviewWidth:ImageConstants.IMG_WIDTH_40,
              PreviewHeight:ImageConstants.IMG_HEIGHT_40,
              sourceIconIsUrl:item.sourceIconIsUrl,
              isShowTitle:false,
              sourceName:item.sourceName
            })

            Text(`${item.sourceName}`).fontSize(10)
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(18)
              .fontFamily(CommonConstants.FAMILY_PingFANG)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
          }
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
      })
    }
    .height(80)
    .chainAnimation(true)
    .edgeEffect(EdgeEffect.Spring)
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
    .padding({top:PaddingConstants.PADDING_12})
  }
}