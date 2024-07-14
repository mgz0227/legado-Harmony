/**
 * @author 2008
 * @datetime 2024/7/14 22:58
 * @className: SubscriptionContent
 * 订阅内容组件
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import ImageConstants from '../../../../common/constants/ImageConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import { IconTitleVo } from '../../../../componetsmodel/IconTitleVo'

@Component
export default struct SubscriptionContent{
  @Prop subscriptionTitle: string

  build() {
    Column(){
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
            Text(this.subscriptionTitle)
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

        this.contentCoverBuilder()
        this.contentListBuilder()
      }
      .margin({top: PaddingConstants.PADDING_12})
      .borderRadius(12)
      .backgroundColor(Color.White)
      .padding(20)
    }
  }

  @Builder
  contentCoverBuilder(){
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
  }

  //漫画列
  @Prop
  contentList: IconTitleVo[] = []
  @Builder
  contentListBuilder(){
    GridRow({
      columns: 5
    }){
      ForEach(this.contentList,(item:IconTitleVo)=>{
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
}