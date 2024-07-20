/**
 * @author 2008
 * @datetime 2024/6/27 0:34
 * @className: mayAlsoLike
 */
import CommonConstants from '../../../common/constants/CommonConstants'

@Component
export default struct mayAlsoLike {
  @Prop mayAlsoLike: string = '猜你喜欢'
  handleClick: () => void = () => {}

  build() {
    Row() {
      Text(`${this.mayAlsoLike}`)
        .font({
          size: 20,
          weight: 500,
          family: CommonConstants.FAMILY_PingFANG
        })
        .fontColor($r('app.string.color_black_88'))
        .lineHeight(28)

      Row() {
        Text('全部分类').font({
          size: 14,
          weight: 400,
          family: CommonConstants.FAMILY_PingFANG
        })
          .fontColor($r('app.string.color_black_45'))
          .lineHeight(22)
        Image($r('app.media.icon_right'))
          .width(16)
          .height(16)
          .fillColor($r('app.string.color_black_45'))
      }
      .height(28)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.handleClick()
      })
    }
    .width('100%')
    .height(28)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }
}