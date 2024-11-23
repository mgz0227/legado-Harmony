import { ThemeStorageKey } from "../../common/constants/Theme"
import { ThemeItem } from "../../common/model/Theme"

export enum FormItemType {
  Input
}

@Component
export  default  struct FormItem {
  @Builder rightBuilder() {}
  // 自定义右侧区域
  @BuilderParam customRightBuilder: () => void = this.rightBuilder
  @Prop value: string
  type: FormItemType = FormItemType.Input
  label: string = ''
  required: boolean = false
  isLength: boolean = false
  maxLength: number = 10
  onChange: Function = (_value: string) => {}
  showTitle: boolean = true

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

          if (this.required) {
            Text('*')
              .fontSize(16)
              .padding({ left: 10 })
              .fontColor(Color.Red)
          }
        }
        .alignItems(VerticalAlign.Center)

        if (this.customRightBuilder !== this.rightBuilder) {
          this.customRightBuilder()
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Stack() {
        if (this.type === FormItemType.Input) {
          TextInput({ text: this.value ?? '', placeholder: `请输入${this.label}` })
            .placeholderColor('#73000000')
            .placeholderFont({ size: 14, weight: 400 })
            .caretColor(this.theme.mainColor)
            .height(38)
            .margin({ top: 10, bottom: 10 })
            .fontSize(14)
            .fontColor('#E0000000')
            .borderRadius(4)
            .onChange((value: string) => {
              this.onChange(value)
            })
        }

        if (this.isLength) {
          Text(`${this.value?.length ?? 0}/${this.maxLength}`)
            .fontSize(14)
            .fontColor('#73000000')
            .position({ top: 20, right: 10 })
        }
      }.width('100%')
    }
    .margin({ top: 12 })
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}