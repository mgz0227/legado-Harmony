import { serviceList } from '../../../componets/dataList/serviceList'
import { font } from '@kit.ArkUI'

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
      //web服务开关
      Row(){
        Row({space:10}){
          Image($r("app.media.pc_icon")).size({width:20,height:20})
          Text("web服务").fontWeight(600)
          Image($r("app.media.doubt")).size({width:20,height:20})
        }
        Row(){
          Toggle({type:ToggleType.Switch,isOn:$$this.webDavStatus})
            .onChange((isOn: boolean) => {
              this.webDavStatus=isOn
            }).selectedColor("#F60")
        }
      }.width("100%").justifyContent(FlexAlign.SpaceBetween)

      //wifi 阅读 写源
      Row({space:10}){
        ForEach(this.List,(item:serviceList)=>{
          Column({space:5}){
            Text(item.name)
              .fontSize(13)
              .fontColor("rgba(121, 119, 119, 1.00)")
              .width("100%")
              .fontWeight(500)
              .fontColor(item.background[0])
              .fontFamily("JinBuTi")
            Image(item.img).size({width:28,height:28})
            this.canvas(item.background[2],-18,-25)
            this.canvas(item.background[2],5,-30)
          }.backgroundColor(item.background[1])
            .alignItems(HorizontalAlign.End)
            .size({width:85,height:70})
            .padding({top:10,bottom:10,left:10,right:12})
            .borderRadius(12)
        })
      }


      Row({space:20}){
        Text(this.address).fontColor("rgba(0, 0, 0, 0.45)").fontSize(14).width("70%")
        Text("|").fontColor("rgba(0, 0, 0, 0.45)").fontSize(14)
        Text("复制").fontColor("#FF6600").fontSize(14).fontWeight(600)
      }
      .width(280)
      .height(40)
      .backgroundColor("rgba(0, 0, 0, 0.04)")
      .borderRadius(8)
      .padding({left:20,right:20})
      .visibility(this.webDavStatus?Visibility.Visible:Visibility.None)
    }
    .width(320)
    .backgroundColor("#FFF")
    .padding({top:10,bottom:20,left:10,right:10})

    .borderRadius(10)
  }

  aboutToAppear() {
    font.registerFont({
      familyName: 'JinBuTi',
      familySrc: $rawfile("DingTalkJinBuTi.ttf") // font文件与pages目录同级
    })
  }
}
