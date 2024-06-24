import { serviceList } from '../dataList/serviceList'
import { font, promptAction } from '@kit.ArkUI'
import { pasteboard } from '@kit.BasicServicesKit'
import { serviceDialog } from './serviceDialog'
import CommonConstants from '../../common/constants/CommonConstants'


@Component
export struct WebdavService {
  @State webDavStatus:boolean=false
  @State List:serviceList[]=[
    new serviceList("wifi传书","1",$r("app.media.wifi_line"),["#188BFF","#D8ECFF","#B5DAFF"]),
    new serviceList("电脑阅读","1",$r("app.media.computer"),["#FF9500","#FFEDD4","#FFDDAD"]),
    new serviceList("电脑写源","1",$r("app.media.writing"),["#24B277","#DAF2E8","#B9E6D3"]),
  ]
  @State address:string="http://192.168.41.12.1122"

  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State serviceDialogStatus:boolean=false


  @Builder canvas(color:ResourceColor,X:number,Y:number){
    Canvas(this.context)
      .width(14)
      .height(10)
      .backgroundColor(color)
      .opacity(0.7)
      .onReady(() => {
        this.context.fillRect(0, 30, 100, 100)
      }).offset({x:X,y:Y})
  }
  build() {
    Column({space:15}){
      //Web服务开关
      Row(){
        Row({space:10}){
          Image($r("app.media.pc_icon")).size({width:20,height:20})
          Text("Web服务").fontWeight(600)
          Image($r("app.media.doubt")).size({width:20,height:20}).onClick(()=>{
            this.bookInfoDel?.open()
          })
        }
        Row(){
          Toggle({type:ToggleType.Switch,isOn:$$this.webDavStatus})
            .onChange((isOn: boolean) => {
              this.webDavStatus=isOn
            }).selectedColor("#F60").hoverEffect(HoverEffect.None)
        }
      }.width("100%").justifyContent(FlexAlign.SpaceBetween)
      //wifi 阅读 写源
      Flex({
        direction:FlexDirection.Row,
        justifyContent:FlexAlign.Center,
        alignContent:FlexAlign.Center,
        alignItems:ItemAlign.Center
      }){
        ForEach(this.List,(item:serviceList,index: number)=> {
          if (index != 0) {
            Column()
              .width(10)
              .flexBasis('auto')
              .flexGrow(0)
              .flexShrink(0)
          }

          Column({space:5}){
            Text(item.name)
              .fontSize(12)
              .fontColor("rgba(121, 119, 119, 1.00)")
              .width("100%")
              .fontWeight(500)
              .fontColor(item.background[0])
              .fontFamily("JinBuTi")
            Image(item.img).size({width:28,height:28})
            this.canvas(item.background[2],-18,-25)
            this.canvas(item.background[2],5,-30)
          }
          .backgroundColor(item.background[1])
          .alignItems(HorizontalAlign.End)
          .width(95)
          .height(70)
          .padding({top:10,bottom:10,left:10,right:12})
          .borderRadius(12)
          .flexBasis('auto')
          .flexGrow(1)
          .flexShrink(1)
        })
      }
      .width("100%")

      //复制地址
      Row({space:20}){
        Text(this.address)
          .fontColor("rgba(0, 0, 0, 0.45)")
          .fontSize(14)
          .width("70%")
        Text("|")
          .fontColor("rgba(0, 0, 0, 0.45)")
          .fontSize(14)
        Text("复制")
          .fontColor("#FF6600")
          .fontSize(14)
          .fontWeight(600)
          .onClick(()=>{this.copy(this.address)})
      }
      .width("100%")
      .height(40)
      .backgroundColor("rgba(0, 0, 0, 0.04)")
      .borderRadius(8)
      .padding({left:20,right:20})
      .visibility(this.webDavStatus?Visibility.Visible:Visibility.None)
      .opacity(this.webDavStatus?1:0)
      .scale({
        centerX: "50%",
        centerY: "50%",
        x: this.webDavStatus ? 1 : 0,
        y: this.webDavStatus? 1 : 0,
      })
      .animation({
        duration: 600,
        curve: CommonConstants.UniCurve
      })
    }
    .width("100%")
    .backgroundColor("#FFF")
    .padding({top:16,bottom:16,left:20,right:20})
    .borderRadius(10)
  }

  aboutToAppear() {
    font.registerFont({
      familyName: 'JinBuTi',
      familySrc: $rawfile("DingTalkJinBuTi.ttf") // font文件与pages目录同级
    })
  }
  //复制方法
  copy(value:string){
    let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN,value);
    const systemPasteboard = pasteboard.getSystemPasteboard()
    systemPasteboard.setData(pasteData)
    promptAction.showToast({
      message: '复制成功',
      duration: 1000,
    })
  }
  //弹窗关闭
  exitApp() {
    this.serviceDialogStatus = false
  }

  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: serviceDialog({
      title:"帮助说明",
      value:"打开后请复制下方链接，用电脑浏览器访问，并确认手机和电脑连接在同一WiFi下"
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset:{dx:0,dy:20},
    customStyle: true
  })

}
