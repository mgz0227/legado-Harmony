import { promptAction } from '@kit.ArkUI';
import { dataItem } from '../../../componets/dataList/dataItem';
import { cloudTitle } from '../../../componets/webDavService/cloudTitle';

@Entry
@Component
struct CloudDisk {
  //旋转角度
  @State refresh: number = 0;
  //备份时间
  @State backups_time:string="2023/8/12 20:34:12"
  //备份状态
  @State backups_status:boolean=false
  //自动备份状态
  @State auto_backups_status:boolean=false

  @State backups_list:dataItem[]=[
    new dataItem("自动备份",1,"",0),
    new dataItem("备份设置",2,"",1),
    new dataItem("备份帮助",3,"",1)
  ]

  @Builder backups_item(item:dataItem){
    Row(){
      Text(item.title).fontSize(16)
      if(item.type==0){
        Toggle({type:ToggleType.Switch,isOn:$$this.auto_backups_status})
          .onChange((isOn: boolean) => {
            this.auto_backups_onClick(isOn)
          }).selectedColor("#F60").hoverEffect(HoverEffect.None)
      }else{
        Image($r("app.media.right"))
          .size({width:30,height:30})
          .onClick(()=>{this.backup_set(parseInt(item.value.toString()))})
      }
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder backups_botton(){
    Row() {
      Text(this.backups_status?"备份中":'立刻备份')
        .fontSize(12)
        .fontColor(0xffffff)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width(110)
    .height(40)
  }


  build() {
      Column() {
        //标题栏
        cloudTitle({title:"云备份"})
        //备份图片及按钮
        Column(){
          Column(){
            Image($r("app.media.cloud_refresh"))
              .size({width:68,height:68})
              .margin({bottom:60})
              .rotate({angle:this.refresh})
              .onClick(()=>{
                // this.cloud_refresh()
              })
          }
          .margin({top:42,bottom:42})
          .backgroundImage($r("app.media.cloud"))
          .size({width:264,height:206})
          .backgroundImageSize({width:"100%",height:"100%"})
          .justifyContent(FlexAlign.Center)
          Text("上次备份时间："+this.backups_time).fontSize(14).fontColor("rgba(0, 0, 0, 0.45)")

          //备份按钮
          Button({ type: ButtonType.Capsule, stateEffect: true }) {
            this.backups_botton()
          }
          .margin({top:32,bottom:42})
          .backgroundColor("rgb(255, 102, 0)")
          .onClick(()=>{this.backups_onClick()})
        }
        //备份设置
        Column({space:10}){
          ForEach(this.backups_list,(item:dataItem)=>{
            this.backups_item(item)
          })
        }.stateStyles({
          normal: this.setStyle,
        })

        Column(){
          this.backups_item(new dataItem("数据恢复",4,"",1))
        }.stateStyles({
          normal: this.setStyle,
        })
        .margin({top:16})
      }.stateStyles({
        normal: this.pageStyle,
      })
  }




  //备份按钮事件
  backups_onClick(){
    this.cloud_refresh()
  }
  //自动备份开关
  auto_backups_onClick(isOn:boolean){
    this.auto_backups_status=isOn
  }
  //备份设置所有事件
  backup_set(index:number){
    switch (index){
      case 2:
        break;
      case 3:
        break;
      case 3:
        break;
    }
  }


  //动画旋转方法
  cloud_refresh(){
    if(!this.backups_status){
      this.backups_status=true
      animateTo({
        duration: 1000,
        curve: Curve.EaseOut,
        iterations: 2,
        playMode: PlayMode.Normal,
        //动画结束方法
        onFinish: () => {
          this.backups_status=false
          promptAction.showToast({
            message: '备份成功',
            duration: 1000,
          })
        }
      }, () => {
        //旋转角度
        this.refresh+=720
      })
    }
  }

  //样式
  @Styles setStyle():void{
    .backgroundColor(0xffffff)
    .size({width:"90%"})
    .borderRadius(15)
    .padding(20)
  }
  @Styles pageStyle():void{
    .padding(10)
    .backgroundColor("rgb(245, 245, 245)")
    .width("100%")
    .height("100%")
  }
}