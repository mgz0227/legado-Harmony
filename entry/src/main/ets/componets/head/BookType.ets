import { ThemeStorageKey } from "../../common/constants/Theme"
import { ThemeItem } from "../../common/model/Theme"

@Component
export default struct BookType {
  @Prop title:string
  @Prop bookType:string
  @Prop index:number
  @Prop bookTypeNumber:number = 0

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  build() {
    Column() {
      Text(this.title)
        .fontColor(this.index === this.bookTypeNumber ? this.theme.mainColor :  'rgba(0,0,0,0.8)')
        .fontSize(12)
        .fontWeight(this.index === this.bookTypeNumber ? 700 : 700)
    }
    .borderRadius(8)
    .padding(8)
    .backgroundColor(this.index === this.bookTypeNumber? this.theme.secondColor:'rgb(240,240,240)')
  }
}