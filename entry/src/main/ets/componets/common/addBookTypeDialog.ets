/**
 * 添加分类类型弹窗
 */
@CustomDialog
export default struct addBookTypeDialog {

  @Link bookType:string

  controller?: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在所有controller的后面
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  @State BookTypeValueLength:number = 0


  build() {
    Column() {
      Text(`新建分组` ).fontWeight(600).fontSize(20).margin({ top: 20, bottom: 10 })
      this.inputBookType()
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
    }.width('80%')
  }
  @State translateX: number = 0;
  @Builder inputBookType(){
    Row(){
      TextInput({ placeholder: '请输入分组名称', text: this.bookType }).height(40)
        .onChange((value: string) => {
          this.bookType = value
          this.BookTypeValueLength = value.length
          if (10 - this.BookTypeValueLength === 0) {
            animateTo({
              duration: 200,
              // curve: curves.springCurve(100, 0, 50, 10),
              iterations: 4,
            },
              () => {
                // 抖动动偏移量
                this.translateX = 10;
              })
            this.translateX = 0;
          }
        })
        .translate({ x: this.translateX})
        .border({width:10 - this.BookTypeValueLength===0?0.5:0, color: Color.Red })
        .maxLength(10)
      if (10 - this.BookTypeValueLength !== 0){
      Row(){
          Text(JSON.stringify(10 - this.BookTypeValueLength)).fontSize(10).fontWeight(600).fontColor(10 - this.BookTypeValueLength ===0?Color.Red:'')
          Text('/').fontSize(10).fontWeight(600).fontColor(10 - this.BookTypeValueLength ===0?Color.Red:'')
          Text('10').fontSize(10).fontWeight(600).fontColor(10 - this.BookTypeValueLength ===0?Color.Red:'')
      }.offset({x:-40})
      } else {
        Text('清空').fontSize(12).fontWeight(500).fontColor(Color.Red).onClick(()=>{
          this.bookType = ''
        }).offset({x:-40})
      }

    }
    .alignItems(VerticalAlign.Center)
  }
}