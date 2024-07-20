/**
 * @author 2008
 * @datetime 2024/7/20 11:40
 * @className: PreviewEffectImage
 * 自定义图片预览效果
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'

@Component
export default struct PreviewEffectImage{
  @Prop customizeTitle:string = ''
  @Prop sourceIcon:string = ''
  @Prop sourceIconIsUrl:boolean = false
  @Prop PreviewWidth:number = 60
  @Prop PreviewHeight:number = 60
  @Prop isShowTitle:boolean = true
  @Prop ImageRadius:number = 4
  build() {
    Column(){
      if (this.isShowTitle){
        Flex(){
          Text('预览效果')
            .font({
              size:FontConstants.FONT_SIZE_12,
              weight:FontConstants.FONT_WEIGHT_400,
              family:CommonConstants.FAMILY_PingFANG
            })
            .lineHeight(20)
            .fontColor($r('app.string.color_black_45'))
        }
      }
      Stack(){
        if (this.customizeTitle && !this.sourceIconIsUrl){
          Text(this.customizeTitle.slice(0,1)).font({
            size:FontConstants.FONT_SIZE_16,
            weight:FontConstants.FONT_WEIGHT_700,
            family:CommonConstants.FAMILY_PingFANG
          })
            .zIndex(9)
            .fontColor(Color.White)
        }
        if (this.sourceIcon){
          Image(this.sourceIcon.concat('app.media.')?$r(this.sourceIcon):this.sourceIcon)
            .width(this.PreviewWidth)
            .height(this.PreviewHeight)
            .animation(({
              duration:1000
            }))
            .borderRadius(this.ImageRadius)
        } else {
          Image($r('app.media.icon'))
            .width(this.PreviewWidth)
            .height(this.PreviewHeight)
            .animation(({
              duration:1000
            }))
            .borderRadius(4)
        }
      }
    }
  }
}