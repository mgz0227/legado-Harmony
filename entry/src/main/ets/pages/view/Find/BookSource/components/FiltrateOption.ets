export interface Options {
  label: string;
  value?: number | string | boolean;
}


@Component
export default struct FiltrateOption {
  options: Options[] = []
  columns: number = 3
  isAgain: boolean = false
  @Prop value?: number | string | boolean
  onChange: (value?: number | string | boolean) => void = () => {}

  build() {
    Grid() {
      ForEach(this.options, (item: Options) => {
        GridItem() {
          Text(item.label)
            .fontColor(this.value === item.value ? '#FF6600' : '#E0000000')
            .fontSize(12)
            .height(20)
            .lineHeight(20)
        }
        .border({
          radius: 4,
          width: 1,
          style: BorderStyle.Solid,
          color: this.value === item.value ? '#FF6600' : '#0A000000'
        })
        .padding({ top: 6, bottom: 6 })
        .backgroundColor(this.value === item.value ? 'rgba(255, 102, 0, 0.12)' : '#0A000000')
        .onClick(() => {
          if (this.value !== undefined && this.isAgain && this.value === item.value) {
            this.onChange(undefined)
            return
          }
          this.onChange(item.value)
        })
      })
    }
    .columnsTemplate(Array(this.columns).fill('1fr').join(' '))
    .columnsGap(16)
    .rowsGap(16)
    .padding({ bottom: 12, top: 12 })
  }
}
