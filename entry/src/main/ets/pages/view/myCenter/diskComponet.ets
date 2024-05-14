import { dataItem } from '../../../componets/dataList/dataItem'
import { myCenterInputDialog } from '../../../componets/myCenter/myCenterInputDialog'
@Component
export struct diskComponet{
  @ObjectLink deviceName:dataItem

  @State @Watch("diskDialogStatusChange") diskDialogStatus:boolean=false
  @Prop deviceNameValue:string=""
  @State a:string="12"

  build() {
    Row(){
      Row({space:12}){
        Text(this.deviceName.title).fontSize(14).lineHeight(22)
        Image(this.deviceName.icon).size({width:20,height:20})
          .visibility(this.deviceName.icon!=""?Visibility.Visible:Visibility.None)
      }.width("40%")
      Row({space:5}){
        Flex({direction:FlexDirection.RowReverse}){
          Text(this.deviceName.value.toString())
            .fontSize(12)
            .lineHeight(20)
            .fontColor("rgba(0, 0, 0, 0.45)")
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .maxLines(1)
            .ellipsisMode(this.deviceName.status?EllipsisMode.START:EllipsisMode.END)
        }.width(124).margin({bottom:3})
        ImageSpan($r("app.media.right"))
          .size({width:24,height:24})
          .verticalAlign(ImageSpanAlignment.BOTTOM)
          .onClick(()=>{
            this.device_onclick()
          })
      }.width("60%")
      .padding({top:12,bottom:12})
      .justifyContent(FlexAlign.End)
    }.width(280)
  }

  diskDialogStatusChange(){
    if (this.diskDialogStatus) {
      this.deviceNameInfo?.open()
    }
  }
  onCancel() {
    this.diskDialogStatus = false
  }

  onAccept() {
    this.deviceName.value=this.deviceNameValue
    this.diskDialogStatus = false
  }
  //弹窗关闭
  exitApp() {
    this.diskDialogStatus = false
  }
  device_onclick=()=>{
    this.deviceNameValue=this.deviceName.value.toString()
    this.diskDialogStatus=true
  }
  deviceNameInfo: CustomDialogController | null = new CustomDialogController({
    builder: myCenterInputDialog({
      title:"设备名称",
      value:this.deviceNameValue,
      placeholder:"请输入设备名称",
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() }

    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset:{dx:0,dy:20},
    customStyle: true
  })
  aboutToAppear(): void {

  }
}