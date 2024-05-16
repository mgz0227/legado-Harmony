
@CustomDialog
export default struct hideDialogExample {

  controller?: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在所有controller的后面
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  @Prop title:string

  build() {
    Column() {
      Text(`确定隐藏吗？` ).fontWeight(600).maxLines(1).minFontSize(12).maxFontSize(20).margin({ top: 20, bottom: 10 })
      Text('隐藏后可点击分组标签栏右侧分组管理入口查看隐藏分组并进入').width('70%').textAlign(TextAlign.Center)
        .fontColor('rgba(0, 0, 0, 0.45)').fontSize(14).fontWeight(400).lineHeight(22)
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