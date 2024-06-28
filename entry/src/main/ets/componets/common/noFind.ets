/**
 * @author 2008
 * @datetime 2024/6/26 23:47
 * @className: noSourceFind
 * 公用暂无相关内容
 */
import CommonConstants from '../../common/constants/CommonConstants'
import FontConstants from '../../common/constants/FontConstants'
import ImageConstants from '../../common/constants/ImageConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'

@Component
export default struct noFind {
  @Prop hintIndex:number = 2
  hintMessage:string[] = ['暂无相关内容','网络异常，请检查后重试','内容加载失败，请刷新重试']
  hintIcon:Resource[] = [$r('app.media.icon_no_source_find'),$r('app.media.icon_no_source_net'),$r('app.media.icon_no_source_content')]
  onclick:() => void = () => {

  }
  build() {
    Column(){
        Image(this.hintIcon[this.hintIndex]).width(ImageConstants.IMG_WIDTH_124).height(ImageConstants.IMG_HEIGHT_120)
          .margin({
            bottom:PaddingConstants.PADDING_32
          })
        Text(this.hintMessage[this.hintIndex])
          .fontColor($r('app.string.color_black_45'))
          .width(280)
          .font({
            size:FontConstants.FONT_SIZE_14,
            weight:FontConstants.FONT_WEIGHT_400,
            family:CommonConstants.FAMILY_PingFANG
          })
          .textAlign(TextAlign.Center)
          .margin({bottom:PaddingConstants.PADDING_24})
        Button($r('app.string.retry'))
          .padding({
            left:32,right:32,
            bottom:8,top:8
          })
          .fontSize(FontConstants.FONT_SIZE_14)
          .fontWeight(FontConstants.FONT_WEIGHT_500)
          .fontFamily(CommonConstants.FAMILY_PingFANG)
          .backgroundColor($r('app.color.theme_color'))
          .onClick(()=>{
          this.onclick()
        })
    }
  }
}