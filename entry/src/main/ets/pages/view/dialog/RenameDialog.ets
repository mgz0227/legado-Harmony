/**
 * @author 惟草木之零落兮
 * @date 2024/5/26 16:22
 */
@Preview
@CustomDialog
export default struct RenameDialog{
    controller?: CustomDialogController
    textController: TextInputController = new TextInputController()
    @Require @Prop oldName:string
    newName:string = ""


    cancel: () => void = () => {
    }
    @State maxText: number = this.oldName.length

    confirm?: (value: string)=>void

    @Styles buttonStyles(){
        .height(38)
        .padding({left: 32, right: 32, top: 8, bottom: 8})
        .borderRadius(px2vp(200))
    }

    build(){
        Row(){
            Column(){

                Text('重命名').fontColor('rgba(0, 0, 0, 0.88)').fontSize(18).fontWeight(500).lineHeight(26)
                    .textAlign(TextAlign.Center)
                    .margin({bottom: 16})

                Stack({alignContent: Alignment.End}){
                    TextInput({placeholder: this.oldName, text: this.newName, controller: this.textController})
                        .placeholderFont({size: 14, weight: 400})
                        .placeholderColor("#000000")
                        .fontSize(14)
                        .fontWeight(400)

                        .padding({left: 20, right:20, top: 8, bottom: 8})
                        .height(38)
                        .maxLength(4)
                        .caretColor("rgba(255, 102, 0, 1)")
                        .onChange((value: string)=>{
                            if (value.length > 4){
                                // value 截取前四个
                                value = value.substring(0, 4)
                            }
                            this.maxText = value.length
                            if (this.maxText == 0){
                                this.newName = this.oldName
                                this.maxText = this.oldName.length
                                return
                            }
                            this.newName = value
                        })
                        .zIndex(1)

                    Text(`${this.maxText}/4`)
                        .zIndex(2)
                        .margin({right: 20})
                        .font({size: 12, weight: 400})
                        .opacity(0.45)
                }.height(38).margin({bottom: 24})

                // .onSubmit((enterKey: EnterKeyType, event: SubmitEvent)=>{
                //
                // })

                Row(){

                    Button("取消")
                        .buttonStyles()
                        .margin({left: 24})
                        .fontWeight(500).fontSize(14).fontColor("#FF6600")
                        .backgroundColor("rgba(255, 102, 0, 0.12)")
                        .onClick(()=>{
                            this.controller?.close()
                        })

                    Blank().layoutWeight(1)

                    Button("确定")
                        .buttonStyles()
                        .margin({right: 24})
                        .fontWeight(500).fontSize(14).fontColor("rgba(255, 255, 255, 1)")
                        .backgroundColor("rgba(255, 102, 0, 1)")
                        .onClick(()=>{
                            if (this.confirm) this.confirm(this.newName)
                            this.controller?.close()
                        })
                }
            }
            .backgroundColor("rgba(255, 255, 255, 1)")
            .padding(24)
            .height(190)
            //.margin({left: 38, right: 38})
            .width("100%")
            .borderRadius(16)
        }
        .padding({left: 38, right: 38})
    }
}