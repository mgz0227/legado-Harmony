
import font from '@ohos.font';

import web_webview from '@ohos.web.webview'

import { promptAction, router } from '@kit.ArkUI';
import { ColumnModifier } from '../../../common/utils/ComponetModifier';

@Entry
@Component
struct  WebDav{
  @State host: string = ''
  @State account: string = ''
  @State password: string = ''
  @State inputs : Input_items[]=[
    new Input_items("","服务器地址",InputType.Normal),
    new Input_items("","账号",InputType.Number),
    new Input_items("","密码",InputType.Password)
  ]
  @State helper_status:boolean=false
  controller: web_webview.WebviewController = new web_webview.WebviewController()
  Column = new ColumnModifier().setPadding(0,0)
  @Builder input_type(item:Input_items){
    Column(){
      TextInput({ text:item.text, placeholder: item.placeholder })
        .placeholderColor(Color.Grey)
        .type(item.type)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(14)
        .fontColor(Color.Black)
        .borderRadius(10)
        .padding({left:20})
        .onChange((value: string) => {
          item.text= value
        })
        .onFocus(() => {

        })
    }
  }
  @Builder helper(){
    Blank(20)
    Web({ src: $rawfile("webDavHelp.html"), controller: this.controller })
  }
  aboutToAppear() {
    font.registerFont({
      familyName: 'JinBuTi',
      familySrc: $rawfile("DingTalkJinBuTi.ttf") // font文件与pages目录同级
    })
  }

  build() {
    Column(){
      //输入框
      Column(){
        Column({space:30}){
          Text("WebDav云盘登录")
            .fontSize(30)
            .fontWeight(700)
            .fontFamily("JinBuTi")
          Column({space:30}){
            ForEach(this.inputs,(item:Input_items)=>{
              this.input_type(item)
            })
          }.width("80%")
          //提交按钮
          Button("授权并登录")
            .width("80%").height(50)
            .backgroundColor("rgb(128, 128, 128)")
            .borderRadius(10)
            .onClick(()=>{
              promptAction.showToast({
                message: '登录成功',
                duration: 1000,
              })
              setTimeout(()=>{
                router.pushUrl({
                  url: "pages/view/myCenter/FileManagement",
                  params:{
                    webDavStatus:1
                  }
                })
              },2000)
            })

        }.width("100%").height("95%")
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      //查看帮助
      Column(){
        Text("不会填写？查看帮助")
          .fontColor("rgba(255, 149, 0, 1)")
          .fontSize(14)
      }.bindSheet($$this.helper_status,this.helper,{
        height:600,
        enableOutsideInteractive:false,
        dragBar:false
      }).onClick(()=>{
        this.helper_status=true;
      }).width("100%").height(20)
    }.justifyContent(FlexAlign.Start)
    .attributeModifier(this.Column)
  }
}






class Input_items{

  text:string

  placeholder:string

  type:InputType

  constructor(text:string,placeholder:string,type:InputType){
    this.text=text;
    this.placeholder=placeholder;
    this.type=type;
  }
}
