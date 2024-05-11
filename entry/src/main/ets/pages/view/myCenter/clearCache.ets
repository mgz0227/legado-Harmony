import { dataItem } from '../../../componets/dataList/dataItem'
import { serviceDialog } from '../../../componets/webDavService/serviceDialog'

@Entry
@Component
struct clearCache{
  @State clearList:dataItem[]=[
    new dataItem("系统缓存",34.35),
    new dataItem("小说缓存",34.35),
    new dataItem("漫画缓存",34.35),
    new dataItem("听书缓存",34.35),
    new dataItem("字体缓存",34.35),
  ]
  @State @Watch("ClearChange") clearDialogStatus:boolean=false
  @State index:number=0
  build() {
    Column({space:20}){
      Row(){
        Row(){
          Image($r("app.media.right")).rotate({angle:180}).size({width:40,height:40})
        }.width("40%")
        Text("清理缓存").fontSize(20).fontWeight(600)
      }.width("100%").justifyContent(FlexAlign.Start)

      Column(){
        ForEach(this.clearList,(item:dataItem,index:number)=>{
          Row({space:10}){
            Text(item.title).width("60%").fontSize(18)
            Text(item.value+"MB").fontSize(16).fontColor("rgba(0, 0, 0, 0.45)")
            Image($r("app.media.right"))
              .size({width:30,height:30})
              .clickEffect({level:ClickEffectLevel.LIGHT, scale: 0.5})
          }.width("90%").padding({top:12,bottom:12}).onClick(()=>{
            this.index=index
            this.clearDialogStatus=true
          })
        })
      }
      .backgroundColor(Color.White)
      .padding({ left:20,right:20,top:10,bottom:10 })
      .borderRadius(15)
    }.padding(10).backgroundColor("rgb(245, 245, 245)").width("100%").height("100%")
  }


  //弹窗关闭
  exitApp() {
    this.clearDialogStatus = false
  }
  onCancel() {
    this.clearDialogStatus = false
  }

  onAccept(index:number) {
    this.clear(index)
    this.clearDialogStatus = false
  }
  ClearChange(){
    if (this.clearDialogStatus) {
      this.clearInfoDel?.open()
    }
  }
  clearInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: serviceDialog({
      title:"确认清除小说缓存吗？",
      value:"",
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept(this.index) }
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset:{dx:0,dy:20},
    customStyle: true
  })
  //清楚方法
  clear(index:number){
    switch (index){
      case 0:
      //系统缓存
        console.log("系统缓存");
        break;
      case 1:
      //小说缓存
        console.log("小说缓存");
        break;
      case 2:
      //漫画缓存
        console.log("漫画缓存");
        break;
      case 3:
      //听书缓存
        console.log("听书缓存");
        break;
      case 4:
      //字体缓存
        console.log("字体缓存");
        break;
    }


  }
}