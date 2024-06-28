/**
 * @author 2008
 * @datetime 2024/6/28 22:24
 * @className: dialogTitleFuction
 */
import CommonConstants from '../../common/constants/CommonConstants'
import FontConstants from '../../common/constants/FontConstants'
import ImageConstants from '../../common/constants/ImageConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'
import TextConstants from '../../common/constants/TextConstants'

@Component
export default struct dialogTitleFuction{
  @Prop title:string
  @Prop icon:Resource
  build() {
    Row({
      space:8
    }){
      Image(this.icon)
        .width(ImageConstants.IMG_WIDTH_20)
        .height(ImageConstants.IMG_HEIGHT_20)

      Text(this.title)
        .font({
          size:FontConstants.FONT_SIZE_14,
          weight:FontConstants.FONT_WEIGHT_400,
          family:CommonConstants.FAMILY_PingFANG
        })
        .fontColor($r('app.string.color_black_88'))
        .lineHeight(TextConstants.TEXT_LINE_HEIGHT_22)
    }
    .padding({
      left:PaddingConstants.PADDING_20,
      right:PaddingConstants.PADDING_20,
      top:PaddingConstants.PADDING_12,
      bottom:PaddingConstants.PADDING_12})
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}