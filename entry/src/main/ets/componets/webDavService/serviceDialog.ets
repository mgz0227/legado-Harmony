

@CustomDialog
export struct serviceDialog{

  controller?: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在所有controller的后面
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  @Prop title:string = ''
  @Prop value:string=""
  @Prop type:string="text"
  @Builder button(title:string,color:Array<ResourceStr|Color>,confirm: () => void){
    Text(title)
      .onClick(() => {
        if (this.controller != undefined) {
          this.controller.close()
          confirm();
        }
      })
      .borderRadius(40)
      .padding({left:30,right:30,top:10,bottom:10})
      .fontColor(color[0])
      .backgroundColor(color[1])
  }


  build() {
    Column({space:15}) {
      Text(this.title)
        .fontWeight(600)
        .fontSize(16)
      if(this.type=="text"){
        Text(this.value)
          .fontWeight(600)
          .fontSize(14)
          .size({width:"80%"})
          .fontColor("rgba(0, 0, 0, 0.45)")
          .textAlign(TextAlign.Center)
          .lineHeight(25)
      }
      Row({space:24}) {
        this.button("取消",[$r('app.color.theme_color'),'rgba(255,120,0,0.12)'],this.cancel)
        this.button("确定",[Color.White,$r('app.color.theme_color')],this.confirm)
      }.padding({top:10})
    }.padding({top:20,bottom:20})
    .width(270)
    .backgroundColor("rgba(255, 255, 255, 1)")
    .borderRadius(15)
  }
}