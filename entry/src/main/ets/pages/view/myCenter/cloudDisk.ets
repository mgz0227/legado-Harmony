import { promptAction, router } from '@kit.ArkUI';
import { dataItem } from '../../../componets/dataList/dataItem';
import { MyCenterTitle } from '../../../componets/myCenter/MyCenterTitle';
import { cloudDisKBindSheetComponet } from '../../../componets/myCenter/cloudDisKBindSheetComponet';
import { ColumnModifier } from '../../../common/utils/ComponetModifier';
import { PublicConstants, TextConstants } from '../../../common/constants/PublicConstants';

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
  @State auto_backups_status:boolean=true
  Columns = new ColumnModifier().setCustom({left:20,right:20})
  @State backups_list:dataItem[]=[
    new dataItem("自动备份",1,"",0),
    new dataItem("备份设置",2,"",1),
    new dataItem("备份帮助",3,"",1)
  ]
  @State dataRecoveryStatus:boolean=false
  @State dataRecovery_list:dataItem[]=[
    new dataItem("本地",1,"",0),
    new dataItem("手机",2,"",1),
    new dataItem("iPhone 14 Pro ",3,"",1),
    new dataItem("iPhone 15 Pro ",3,"",1),
    new dataItem("iPhone 15 Pro ",4,"",1),
    new dataItem("iPhone 15 Pro ",3,"",1),
    new dataItem("iPhone 15 Pro ",3,"",1),
    new dataItem("iPhone 15 Pro ",3,"",1),
  ]
  @State historyRecovery_list:dataItem[]=[
    new dataItem("backup 2023/8/11 .zip",1,"",0),
    new dataItem("backup 2023/8/12 .zip",2,"",1),
    new dataItem("backup 2023/8/13 .zip",3,"",1),
    new dataItem("backup 2023/8/14 .zip",3,"",1),
    new dataItem("backup 2023/8/15 .zip",4,"",1),
    new dataItem("iPhone 15 Pro ",3,"",1),
    new dataItem("iPhone 15 Pro ",3,"",1),
    new dataItem("iPhone 15 Pro ",3,"",1),
  ]
  scroller: Scroller = new Scroller()
  @State zipIndex:number=0
  @State deviceIndex:number=0
  @State zipDataIndex:number=0
  @State deviceDataIndex:number=0
  @State isShow:boolean=false


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
    .padding({top:5,bottom:5})
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
  @Builder bindSheetText(text:string){
    Text(text).fontSize(16).lineHeight(24).fontWeight(500)
  }

  //数据恢复弹窗
  @Builder dataRecoveryBindSheet(){
      Column(){
        Column(){
          this.bindSheetText(this.isShow?"请选择历史备份":"请选择恢复来源")
        }.stateStyles({
          normal: this.bindSheetStyle,
        })
        Scroll(this.scroller) {
          if(!this.isShow){
            cloudDisKBindSheetComponet({
              items:this.dataRecovery_list,
              bindSheetIndex:this.deviceIndex
            }).stateStyles({
              normal: this.transitionsStyles,
            })
          }else{
            cloudDisKBindSheetComponet({
              items:this.historyRecovery_list,
              bindSheetIndex:this.zipIndex
            }).stateStyles({
              normal: this.transitionStyles,
            })

          }
        }.scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off) // 滚动条常驻显示
        .friction(0.6)
        .edgeEffect(EdgeEffect.None)
        .size({width:320,height:200})

        Row({space:20}) {
          this.button("取消",[$r('app.color.theme_color'),'rgba(255,120,0,0.12)'],()=>{this.bindSheetCancel(this.isShow)})
          this.button("确定",[PublicConstants.THEME_COLOR_WHITE,$r('app.color.theme_color')],()=>{this.bindSheetConfirm(this.isShow)})

        }.height(40)
        .width("100%")
        .borderWidth({top:1})
        .borderColor("rgba(0, 0, 0, 0.06)")
        .justifyContent(FlexAlign.Center)
        .padding({top:25})
      }
  }
  @Builder button(title:string,color:Array<ResourceStr|Color>,confirm: () => void){
    Button({type: ButtonType.Normal, stateEffect: true}){
      Text(title)
        .fontSize(16)
        .fontColor(color[0])
    }
    .borderRadius(40)
    .backgroundColor(color[1])
    .width(140)
    .height(40)
    .onClick(() => {
        confirm()
    })

  }

  build() {
      Column() {
        //标题栏

        MyCenterTitle({title:"云备份"})
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
          Text("上次备份时间："+this.backups_time).fontSize(14).fontColor(TextConstants.TEXT_FONT_COLOR)

          //备份按钮
          Button({ type: ButtonType.Capsule, stateEffect: true }) {
            this.backups_botton()
          }
          .margin({top:32,bottom:42})
          .backgroundColor(PublicConstants.THEME_COLOR)
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
        }.backgroundColor(0xffffff)
        .size({width:"100%"})
        .borderRadius(15)
        .margin({top:16})
        .padding({ left:20,right:20,top:10,bottom:10 })
        .bindSheet($$this.dataRecoveryStatus, this.dataRecoveryBindSheet(), {
          height: 320,
          showClose:false,
          backgroundColor: PublicConstants.THEME_COLOR_WHITE,
          shouldDismiss:((sheetDismiss: SheetDismiss)=> {
            this.dataRecoveryStatus=false
            this.zipIndex=this.zipDataIndex
            this.deviceIndex=this.deviceDataIndex
            this.isShow=false
          })
        })

      }.stateStyles({
        normal: this.pageStyle,
      })
      .blur(this.dataRecoveryStatus?40:0)
      .attributeModifier(this.Columns)

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
        router.pushUrl({
          url:"pages/view/myCenter/diskSet"
        })
        break;
      case 3:
        break;
      case 4:
        this.dataRecoveryStatus=true
        break;
    }
  }


  //动画旋转方法
  cloud_refresh(){
    if(!this.backups_status){
      this.backups_status=true
      animateTo({
        duration: 1000,
        curve: Curve.Linear,
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

  aboutToAppear(): void {
    this.zipIndex=this.zipDataIndex
    this.deviceIndex=this.deviceDataIndex
  }
  bindSheetCancel=(status:boolean)=>{
    this.zipIndex=this.zipDataIndex
    this.deviceIndex=this.deviceDataIndex
    this.isShow=false
    this.dataRecoveryStatus=false
  }
  bindSheetConfirm=(status:boolean)=>{
    if(status){
      this.zipDataIndex=this.zipIndex
      this.deviceDataIndex=this.deviceIndex
      this.isShow=false
      this.dataRecoveryStatus=false
    }else{
      this.isShow=true
    }

  }
  //样式
  @Styles setStyle():void{
    .backgroundColor(0xffffff)
    .size({width:"100%"})
    .borderRadius(15)
    .padding(20)
  }
  @Styles pageStyle():void{
    .width("100%")
    .height("100%")
  }
  @Styles bindSheetStyle():void{
    .padding({top:16,bottom:16,left:20,right:20})
  }
  @Styles transitionStyles():void{
    .transition(TransitionEffect.opacity(1).animation({ duration: 1000, curve: Curve.Ease }).combine(
      TransitionEffect.translate({ y: 500  })
    ))
  }
  @Styles transitionsStyles():void{
    .transition(TransitionEffect.opacity(1).animation({ duration: 1000, curve: Curve.Ease }).combine(
      TransitionEffect.translate({ y: 500  })
    ))
  }
}