/**
 * 自定义标题和内容弹窗
 * title标题、content内容、confirm确认按钮、cancel取消按钮
 */
@CustomDialog
export default struct TitleContentDialog {

  controller?: CustomDialogController

  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  @Prop title:string = ''
  @Prop content:string = ''

  build() {
    Column() {
      Text(`确定${this.title}吗？` ).fontWeight(600).maxLines(1).minFontSize(12).maxFontSize(20).margin({ top: 20, bottom: 10 })
      if (this.content.length > 0){
        Row({
          space:8
        }){
          Text(this.content)
            .width('70%')
            .fontColor('rgba(0, 0, 0, 0.45)').fontSize(14).fontWeight(400).lineHeight(22).textAlign(TextAlign.Center)
        }
      }
      Row({space:24}) {
        Text('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.cancel()
            }
          })
          .borderRadius(15)
          .padding({left:30,right:30,top:10,bottom:10})
          .fontColor($r('app.color.theme_color'))
          .backgroundColor('rgba(255,120,0,0.12)')
        Text('确认')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.confirm()
            }
          })
          .borderRadius(15)
          .padding({left:30,right:30,top:10,bottom:10})
          .fontColor(Color.White)
          .backgroundColor($r('app.color.theme_color'))
      }.padding({top:20,bottom:20})
    }
  }
}