import { ThemeStorageKey } from "../../../../../common/constants/Theme"
import { ThemeItem } from "../../../../../common/model/Theme"

@Component
export default struct FilterText {
  index: number = 0
  @Prop title: string
  @Prop hasActive: boolean = false
  isIcon: boolean = true
  onChange: (val: number) => void = (_val) => {}
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  build() {
    Row() {
      Text(this.title)
        .fontSize(12)
        .fontColor(this.hasActive ? this.theme.mainColor : '#E0000000')
      if (this.isIcon) {
        Image($r('app.media.down_arrow'))
          .width(8)
          .margin({ left: 6 })
          .fillColor(this.hasActive ? this.theme.mainColor : '#E0000000')
      }
      if (this.index === 4 && this.hasActive) {
        Image($r('app.media.close'))
          .width(8)
          .margin({ left: 2 })
          .fillColor(this.hasActive ? this.theme.mainColor : '#E0000000')
      }
    }
    .height(22)
    .padding({
      top: 2,
      bottom: 2,
      left: 4,
      right: 4
    })
    .layoutWeight(1)
    .backgroundColor(this.hasActive ? this.theme.secondColor : Color.White)
    .borderRadius(4)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onChange(this.index)
    })
  }
}
