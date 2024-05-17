
@CustomDialog
export default struct confirmDialogExample {

  controller?: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在所有controller的后面
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  @Prop title:string = '删除'
  @Link delCache:boolean
  @Prop isShowCache:boolean = false

  build() {
    Column() {
      Text(`确定${this.title}吗？` ).fontWeight(600).maxLines(1).minFontSize(12).maxFontSize(20).margin({ top: 20, bottom: 10 })
      if (this.isShowCache){
        Row({
          space:8
        }){
          Checkbox().selectedColor($r('app.color.theme_color')).select(this.delCache)
          Text('同时删除本地缓存')
            .fontColor('rgba(0, 0, 0, 0.45)').fontSize(14).fontWeight(400).lineHeight(22)
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