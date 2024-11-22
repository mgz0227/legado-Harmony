/**
 * @author 2008
 * @datetime 2024/7/19 23:58
 * @className: RssSourceCheckImage
 * 自定义图标选择器
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import { ThemeStorageKey } from '../../../../common/constants/Theme'
import { ThemeItem } from '../../../../common/model/Theme'
import buttonCommon from '../../../../componets/common/buttonCommon'
import FormInput from '../../../../componets/Form/FormInput'
import PreviewEffectImage from './PreviewEffectImage'

@Component
@Preview
export default struct RssSourceCheckImage{
  @Prop customizeTitle:string = ''
  @State imageIndex:number = 0
  maxLength:number = 1
  //
  // ImageResource:Resource[] = [
  //   $r('app.media.icon_check_image_one'),
  //   $r('app.media.icon_check_image_two'),
  //   $r('app.media.icon_check_image_three'),
  //   $r('app.media.icon_check_image_four'),
  //   $r('app.media.icon_check_image_five'),
  //   $r('app.media.icon_check_image_six'),
  //   $r('app.media.icon_check_image_seven'),
  //   $r('app.media.icon_check_image_eight'),
  //   $r('app.media.icon_check_image_nine'),
  //   $r('app.media.icon_check_image_ten')
  // ]
  @State
  ImageCheckString:string[] = [
    'app.media.icon_check_image_one',
    'app.media.icon_check_image_two',
    'app.media.icon_check_image_three',
    'app.media.icon_check_image_four',
    'app.media.icon_check_image_five',
    'app.media.icon_check_image_six',
    'app.media.icon_check_image_seven',
    'app.media.icon_check_image_eight',
    'app.media.icon_check_image_nine',
    'app.media.icon_check_image_ten'
  ]
  @Prop imageString:string = ''
  //提交
  onSubmit:Function = (_value: string, _imageString:string) => {}
  //取消
  onCancel:Function = ()=>{}
  scroller: Scroller = new Scroller()
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  build() {
    Flex({
      direction:FlexDirection.Column,
      justifyContent:FlexAlign.SpaceBetween
    }){
      Column({
        space:12
      }){
        Text('自定义图标')
          .font({
            size:FontConstants.FONT_SIZE_16,
            weight:FontConstants.FONT_WEIGHT_500,
            family:CommonConstants.FAMILY_PingFANG
          })
          .fontColor($r('app.string.color_black_88'))
          .lineHeight(24)
        FormInput({
          value:this.customizeTitle,
          maxLength:this.maxLength,
          onChange:(value:string)=>{
            this.customizeTitle = value
          }
        })
       Column(){
         Flex(){
           Text('选择图标背景')
             .font({
               size:FontConstants.FONT_SIZE_12,
               weight:FontConstants.FONT_WEIGHT_400,
               family:CommonConstants.FAMILY_PingFANG
             })
             .lineHeight(20)
             .fontColor($r('app.string.color_black_45'))
         }
         List({
           scroller:this.scroller,
           space:12
         }){
           ForEach(this.ImageCheckString,(item:string,index:number)=>{
             ListItem(){
               Stack(){
                 Radio({value:JSON.stringify(index),group:'iconGroup'})
                   .radioStyle({
                     checkedBackgroundColor: this.theme.mainColor
                   })
                   .zIndex(999)
                   .onChange(()=>{
                     this.imageString = item
                   })
                 Image($r(item))
                   .width(42)
                   .height(42)
               }
             }
           })
         }
         .chainAnimation(true)
         .edgeEffect(EdgeEffect.Spring)
         .listDirection(Axis.Horizontal)
         .scrollBar(BarState.Off)
         .padding({top:PaddingConstants.PADDING_12})
       }
       .height(80)
        PreviewEffectImage({
          customizeTitle:this.customizeTitle,
          sourceIcon:this.imageString
        })
          .visibility(this.imageString && this.customizeTitle ?Visibility.Visible:Visibility.None)
          .opacity(this.imageString && this.customizeTitle ?1:0)
          .scale({
            centerX: "50%",
            centerY: "50%",
            x: this.imageString && this.customizeTitle  ? 1 : 0,
            y: this.imageString && this.customizeTitle  ? 1 : 0,
          })
          .animation({
            duration: 600,
            curve: CommonConstants.UniCurve
          })
      }
      .padding(PaddingConstants.PADDING_20)
      Column(){
        Divider().strokeWidth(0.5)
        buttonCommon({
          confirm:()=>{
            this.onSubmit(this.customizeTitle,this.imageString)
          },
          cancel:()=>{
            this.onCancel()
          }
        })
      }
      .padding({
        bottom:PaddingConstants.PADDING_20
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }
}