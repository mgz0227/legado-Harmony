@Component
export default struct inputComponent {

  @State color:string = "#61ffffff"
  @State isFocus:boolean = false
  @Prop text: ResourceStr = ''
  controller: TextInputController = new TextInputController()

  @Prop TEXT:ResourceStr;
  @Prop FontSize:number = 14
  @Prop FontColor:string | Color
  @Prop Width:number
  @Prop Height:number
  @Prop textAlign:Alignment = Alignment.Start
  build() {
      TextArea({ text: this.text, placeholder:this.TEXT, controller: this.controller })
        .align(this.textAlign)
        .placeholderColor(this.FontColor)
        .placeholderFont({ size: this.FontSize})
        .caretColor('#F60')
        .fontColor(Color.Black)
        .width(this.Width)
        .height(this.Height)
        .backgroundColor('#00ffffff')
        .inputFilter('[a-z]', (e) => {
          console.log(JSON.stringify(e))
        })
        .onChange((value: string) => {
          this.text = value
        })
  }
}
