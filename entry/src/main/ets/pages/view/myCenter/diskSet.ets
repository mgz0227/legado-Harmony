import { ColumnModifier } from '../../../common/utils/ComponetModifier';
import { dataItem } from '../../../componets/dataList/dataItem';

import { MyCenterTitle } from '../../../componets/myCenter/MyCenterTitle';

import { diskComponet } from '../../../componets/myCenter/diskComponet';
import { PublicConstants, TextConstants } from '../../../common/constants/PublicConstants';

@Entry
@Component
struct DiskSet {
  @State message: string = 'Hello World';
  Column= new ColumnModifier()
  modifier = new ColumnModifier().setCustom({left:20,right:20,top:0,bottom:0})
  @State toggleList:dataItem[]=[
    new dataItem("阅读器","","","",false),
    new dataItem("主题","","","",false),
    new dataItem("网络书籍","","","",false),
    new dataItem("本地书籍","","","",false),
    new dataItem("书架","","","",false),
    new dataItem("书源","","","",false),
    new dataItem("订阅","","","",false),
  ]
  @State readingProgress:dataItem= new dataItem("同步阅读进度","进入退出阅读器时同步阅读进度","","",false)
  @State localBackup:dataItem= new dataItem("本地备份","","","",false)
  @State deviceName:dataItem= new dataItem("设备名称","Meta 40 Pro","","",false)
  @State localBackupPath:dataItem= new dataItem("本地备份路径","emulated/emulated/阅读/备份","","",true)


  @Builder toggleComponets(item:dataItem){
    Row(){
      Column(){
        Text(item.title).fontSize(14).lineHeight(22)
        Text(item.value.toString()).fontSize(12).lineHeight(20)
          .visibility(item.value!=""?Visibility.Visible:Visibility.None)
      }.alignItems(HorizontalAlign.Start)
      Toggle({type:ToggleType.Switch,isOn:item.status})
        .onChange((isOn: boolean) => {
          item.status=isOn;
        }).selectedColor(PublicConstants.THEME_COLOR).hoverEffect(HoverEffect.None)
    }.justifyContent(FlexAlign.SpaceBetween)
    .stateStyles({normal: this.componetStyles})
  }


  @Builder ImageComponets(item:dataItem,onClick: () => void ){
    Row(){
      Row({space:12}){
        Text(item.title).fontSize(14).lineHeight(22)
        Image(item.icon).size({width:20,height:20})
          .visibility(item.icon!=""?Visibility.Visible:Visibility.None)
      }.width("40%")
      Row({space:5}){
        Flex({direction:item.status?FlexDirection.RowReverse:FlexDirection.Row}){
          Text(item.value.toString())
            .fontSize(12)
            .lineHeight(20)
            .fontColor(TextConstants.TEXT_FONT_COLOR)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .maxLines(1)
            .ellipsisMode(item.status?EllipsisMode.START:EllipsisMode.END)
        }.width(124).margin({bottom:3})
        Text(){
          ImageSpan($r("app.media.right"))
            .size({width:24,height:24})
            .verticalAlign(ImageSpanAlignment.BOTTOM)
            .onClick(()=>{
              onClick();
            })
        }
      }.width("60%")
      .padding({top:12,bottom:12})
      .justifyContent(FlexAlign.End)
    }.width(280)
  }

  @Builder Text(value:string,fontSize:number,lineHeight:number,fontColor:ResourceColor=PublicConstants.THEME_COLOR_WHITE){
    Text(value).fontSize(fontSize).lineHeight(lineHeight).fontColor(fontColor)
  }

  @Builder title(title:string){
    Row(){
      this.Text(title,12,20,TextConstants.TEXT_FONT_COLOR)
    }.width("100%").justifyContent(FlexAlign.Start).padding({top:16,bottom:8,left:20,right:20})
  }
  build() {
    Column() {
      //标题栏
      MyCenterTitle({title:"备份设置"})

      Column(){
        diskComponet({
          deviceName:this.deviceName,
          deviceNameValue:this.deviceName.value.toString()
        })
      }.attributeModifier(this.modifier)
      .stateStyles({normal: this.columnStyles})
      .margin({top:12})

      this.title("基础设置")
      Column(){
        this.toggleComponets(this.readingProgress)
        this.toggleComponets(this.localBackup)
        this.ImageComponets(this.localBackupPath,()=>{})
      }.attributeModifier(this.modifier)
      .stateStyles({normal: this.columnStyles})

      this.title("选择要备份数据")
      //备份数据
      Column(){
        ForEach(this.toggleList,(item:dataItem,index:number)=>{
          this.toggleComponets(item)
        })
      }.attributeModifier(this.modifier)
      .backgroundColor(PublicConstants.THEME_COLOR_WHITE)
      .borderRadius(12)
    }
    .height('100%')
    .attributeModifier(this.Column)
  }







  @Styles componetStyles():void{
    .padding({top:12,bottom:12})
    .width(280)
  }
  @Styles columnStyles():void{
    .backgroundColor(PublicConstants.THEME_COLOR_WHITE)
    .borderRadius(12)
  }
}