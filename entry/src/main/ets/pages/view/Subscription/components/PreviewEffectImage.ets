/**
 * @author 2008
 * @datetime 2024/7/20 11:40
 * @className: PreviewEffectImage
 * 自定义图片预览效果
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import { ThemeStorageKey } from '../../../../common/constants/Theme'
import { ThemeItem } from '../../../../common/model/Theme'

@Component
export default struct PreviewEffectImage{
  @Prop customizeTitle:string = ''
  @Prop sourceIcon:string = ''
  @Prop sourceIconIsUrl:boolean = false
  @Prop PreviewWidth:number = 60
  @Prop PreviewHeight:number = 60
  @Prop isShowTitle:boolean = true
  @Prop ImageRadius:number = 4
  @Prop sourceName:string = ''
  @State isError:boolean = false
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
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
      if (this.isError){
        this.ImageStack(true)
      } else {
        Stack(){
          this.ImageStack(this.customizeTitle.length > 0 && !this.sourceIconIsUrl)
          Column(){
            LoadingProgress().color(this.theme.mainColor).height(30)
            Text('图片加载中...').fontSize(5).fontColor(this.theme.mainColor)
          }.zIndex(-1)
        }
      }
    }
  }


  initialImage:string[] = ['one','two','three','four','five','six','seven','eight','nine','ten']
  @Builder ImageStack(isShow:boolean){
    Stack(){
      if (isShow || this.isError){
        Text(this.isError?this.sourceName.slice(0,1):this.customizeTitle.slice(0,1)).font({
          size:FontConstants.FONT_SIZE_16,
          weight:FontConstants.FONT_WEIGHT_700,
          family:CommonConstants.FAMILY_PingFANG
        })
          .zIndex(9)
          .fontColor(Color.White)
      }
      if (this.isError){
        Image($r(`app.media.icon_check_image_${this.initialImage[this.sourceName.slice(0,9).length]}`))
          .width(this.PreviewWidth)
          .height(this.PreviewHeight)
          .animation(({
            duration:1000
          }))
          .draggable(false)
          .borderRadius(this.ImageRadius)
      } else {
        Image(this.sourceIcon.indexOf('app.media.')>-1?$r(this.sourceIcon):this.sourceIcon)
          .width(this.PreviewWidth)
          .height(this.PreviewHeight)
          .animation(({
            duration:1000
          }))
          .draggable(false)
          .borderRadius(this.ImageRadius)
          .onError(()=>{
            this.isError = true
          })
      }

    }
  }
}