

@CustomDialog
export struct myCenterInputDialog{

  controller?: CustomDialogController

  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  @Prop title:string = ''
  @Link value:string
  @Prop placeholder:string=""
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
    Column({space:24}) {
      Column({space:16}){
        Text(this.title)
          .fontWeight(600)
          .fontSize(16)
        TextInput({text:this.value,placeholder:this.placeholder})
          .fontSize(14).lineHeight(22)
          .width(196).padding({left:20,right:20,top:8,bottom:8})
          .onChange((value:string)=>{
            this.value=value
          })
          .cancelButton({
            style : CancelButtonStyle.CONSTANT,
            icon:{
              size:14,
              src:$r("app.media.clear_input_icon"),
              color: "rgba(0, 0, 0, 0.45)"
            }
          })
      }


      Row({space:12}) {
        this.button("取消",[$r('app.color.theme_color'),'rgba(255,120,0,0.12)'],this.cancel)
        this.button("确定",[Color.White,$r('app.color.theme_color')],this.confirm)
      }
    }.padding(24)
    .width(284)
    .height(190)
    .backgroundColor("rgba(255, 255, 255, 1)")
    .borderRadius(15)
  }
}