import CommonConstants from '../../common/constants/CommonConstants'
import FontConstants from '../../common/constants/FontConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'
import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'
import { HelpInfo } from '../../viewData/HelpInfo'

@Component
@Preview
export default struct Help {
  title: string = ''
  context: string = ''
  btnText: string = ''
  btnClick: Function = () => {
  }
  @Builder contentBuilders() {}
  // 自定义左侧区域
  @BuilderParam contentBuilder: () => void = this.contentBuilders
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  isShowContent:boolean = true
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.SpaceBetween
    }) {
      Column() {
        Text(!this.title ? $r('app.string.export_help') : this.title)
          .font({
            size: FontConstants.FONT_SIZE_16,
            weight: FontConstants.FONT_WEIGHT_500,
            family: CommonConstants.FAMILY_PingFANG
          })
          .textAlign(TextAlign.Center)
          .lineHeight(24)
          .fontColor($r('app.string.color_black_88'))
          .padding({
            bottom: PaddingConstants.PADDING_12
          })
        if (this.contentBuilders !== this.contentBuilder) {
          Column(){
            this.contentBuilder()
          }
          .padding({
            top: PaddingConstants.PADDING_12,
            bottom: PaddingConstants.PADDING_12
          })
        }
        if (this.isShowContent){
          Flex() {
            Text(!this.context ? HelpInfo.HELP_INFO_MESSAGE : this.context)
          }.padding({
            top: PaddingConstants.PADDING_12,
            bottom: PaddingConstants.PADDING_12
          })
        }

      }

      Button(!this.btnText ? $r('app.string.i_know') : this.btnText)
        .width('100%')
        .backgroundColor(this.theme.mainColor)
        .padding({
          left: PaddingConstants.PADDING_32,
          right: PaddingConstants.PADDING_32,
          top: PaddingConstants.PADDING_8,
          bottom: PaddingConstants.PADDING_8
        })
        .onClick(() => {
          this.btnClick()
        })
    }
    .height('100%')
    .padding({
      left: PaddingConstants.PADDING_20,
      right: PaddingConstants.PADDING_20,
      top: PaddingConstants.PADDING_12,
      bottom: PaddingConstants.PADDING_12 + this.bottomRectHeight
    })
  }
}