import CommonConstants from '../../common/constants/CommonConstants'
import FontConstants from '../../common/constants/FontConstants'

@Component
export default struct sourceType {
  @Prop title:string
  @Prop sourceType:string

  build() {
    Column({
      space:2
    }) {
      Text(this.title)
        .fontColor(this.title === this.sourceType ? $r('app.string.color_black_88') :  $r('app.string.color_black_45'))
        .fontSize(18)
        .fontWeight(this.title === this.sourceType ? FontConstants.FONT_WEIGHT_700 : FontConstants.FONT_WEIGHT_400)
      Row().width(12).height(3).borderRadius(4).backgroundColor($r('app.color.theme_color'))
        .visibility(this.title === this.sourceType ? Visibility.Visible : Visibility.Hidden)
        .opacity(this.title === this.sourceType?1:0)
        .scale({
          centerX: "50%",
          centerY: "50%",
          x: this.title === this.sourceType ? 1 : 0,
          y: this.title === this.sourceType? 1 : 0,
        })
        .animation({
          duration: 600,
          curve: CommonConstants.UniCurve
        })
    }
  }
}