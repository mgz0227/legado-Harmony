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
  build() {
    Column() {
      TextInput({ text: this.text, placeholder:this.TEXT ,controller: this.controller })
        .placeholderColor(this.FontColor)
        .placeholderFont({ size: this.FontSize, weight: 200})
        .caretColor(Color.Blue)
        .fontColor(Color.Black)
        .width(this.Width)
        .height(this.Height)
        .backgroundColor('#00ffffff')
        .height(1000)
        .inputFilter('[a-z]', (e) => {
          console.log(JSON.stringify(e))
        })
        .onChange((value: string) => {
          this.text = value
        })
    }
    .onAppear(()=>{
      this.text = this.TEXT
    })
  }
}
