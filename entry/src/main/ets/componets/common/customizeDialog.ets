import { ThemeStorageKey } from "../../common/constants/Theme"
import { ThemeItem } from "../../common/model/Theme"

/**
 * 自定义标题和内容
 */
@CustomDialog
export default struct customizeDialogExample {

  controller?: CustomDialogController
  confirm: () => void = () => {
  }
  @Prop title:string = '标签锁'
  @Prop content:string = '长按底部tab栏书架图标可锁定分组标签栏，再次长按解锁，锁定后左右滑动将直接切换小说，漫画，有声书分组大类'

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  build() {
    Column() {
      Text(`${this.title}` ).fontWeight(600).maxLines(1).minFontSize(12).maxFontSize(20).margin({ top: 20, bottom: 10 })
      Row({
        space:8
      }){
        Text(this.content)
          .width('70%')
          .fontColor('rgba(0, 0, 0, 0.45)').fontSize(14).fontWeight(400).lineHeight(22)
      }
      Row({space:24}) {
        Text('确认')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              // this.confirm()
            }
          })
          .borderRadius(15)
          .padding({left:30,right:30,top:10,bottom:10})
          .fontColor(Color.White)
          .backgroundColor(this.theme.mainColor)
      }.padding({top:20,bottom:20})
    }
  }
}