import PaddingConstants from '../../common/constants/PaddingConstants'
import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'

/**
 * @author 2008
 * @datetime 2024/7/20 01:21
 * @className: FormInput
 * 自定义Input
 */
export enum FormItemType {
  Input
}

@Component
export  default  struct FormInput {
  @Prop value: string
  type: FormItemType = FormItemType.Input
  label: string = '图标名'
  isLength: boolean = false
  maxLength: number = 5
  onChange: Function = (_value: string) => {}
  showTitle: boolean = false
  icon:Resource|string = $r('app.media.icon_rss_source_check_image_font')
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    Column() {
      Row() {
        Row() {
          if (this.showTitle){
            Text(this.label)
              .fontSize(16)
          }
        }
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Stack(){
        Row({
          space:2
        }){
          Image(this.icon)
            .width(24)
            .height(24)
            .margin({left: PaddingConstants.PADDING_16})
          TextInput({text: this.value, placeholder: `请输入${this.label}`,})
            .maxLength(this.maxLength)
            .backgroundColor(Color.Transparent)
            .placeholderColor('#73000000')
            .placeholderFont({ size: 16, weight: 400 })
            .caretColor(this.theme.mainColor)
            .margin({ top: 10, bottom: 10 })
            .fontSize(16)
            .fontColor('#E0000000')
            .onChange((value: string) => {
              this.onChange(value)
            })
        }
        Row({
          space:12
        }){
          if (this.value.length > 0){
            Image($r('app.media.clear_input_icon')).width(16).height(16)
              .onClick(()=>{
                this.value = ''
              })
          }
          Text(`${this.value?.length ?? 0}/${this.maxLength}`)
            .fontSize(14)
            .fontColor('#73000000')
        }
        .margin({right:PaddingConstants.PADDING_16})
      }
      .alignContent(Alignment.End)
      .borderRadius(4)
      .backgroundColor($r('app.string.color_black_6'))
    }
    .margin({ top: 12 })
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}