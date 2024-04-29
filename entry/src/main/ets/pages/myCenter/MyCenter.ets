import { Attribute } from '../../common/utils/Attribute'


@Entry
@Component
struct MyCenter {

  @State reading_time:number = 0
  @State head_list:DataItems[]=[
    new DataItems("读过","20"),
    new DataItems("读完","20"),
    new DataItems("书签","20"),
    new DataItems("勋章","20"),
  ]
  @State center_list:DataItems[]=[
    new DataItems("云盘备份","1",$r("app.media.MyCenter_cloud_icon")),
    new DataItems("书源管理","2",$r("app.media.MyCenter_book_icon")),
    new DataItems("主题","3",$r("app.media.MyCenter_theme_icon")),
    new DataItems("净化","4",$r("app.media.MyCenter_purify_icon")),
  ]

  @State end_list:DataItems[]=[
    new DataItems("帮助中心","1",$r("app.media.MyCenter_help_icon")),
    new DataItems("关于阅读","2",$r("app.media.MyCenter_about_icon")),
    new DataItems("清理缓存","3",$r("app.media.MyCenter_clean_icon")),
    new DataItems("我的设置","4",$r("app.media.MyCenter_setUp_icon")),
  ]

  build() {
    Column(){

      Blank(Attribute.Header)

      //夜间模式图标
      Row(){
          Image($r("app.media.night_icon")).size({width:30,height:30}).interpolation(ImageInterpolation.Medium)
      }.justifyContent(FlexAlign.End).width("100%").onClick(this.night_onclick)

      Blank(30)

      //头像及云盘登录
      Row(){
        //头像
        Image($r("app.media.user_avatar")).size({width:60,height:60})
          .borderRadius(60)
          .interpolation(ImageInterpolation.Medium).onClick(this.avatar_onclick)
        //昵称及阅读时长
        Column({space :10}){
          Text("夏目友人").fontSize(18).fontWeight(600)
          Text("今日阅读"+this.reading_time+"分钟").fontSize(14).fontColor("rgba(0, 0, 0, 0.45)")
        }.alignItems(HorizontalAlign.Start).width("45%")
        //云盘登录
        Row(){
          Text("云盘登录")
            .fontColor("rgba(0, 0, 0, 0.45)")
            .border({width:1,color:"rgba(0, 0, 0, 0.45)",radius:25})
            .fontSize(14)
            .padding({ top:5,left:20,right:20,bottom:5 }).onClick(this.cloudDisk_onclick)
        }
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").onClick(this.night_onclick)

      Blank(30)

      // 统计数据
      Row(){
        ForEach(this.head_list,(item:DataItems)=>{
          Column({space:5}){
            Text(item.value.toString()).fontSize(20).fontWeight(800)
            Text(item.title).fontSize(14).fontWeight(800)
          }
        })
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left:20,right:20})

      Blank(30)

      //云盘 书源 主题 净化设置
      Row({space:10}){
        ForEach(this.center_list,(item:DataItems)=>{
          Column({space:5}){
            Image(item.icon).size({width:20,height:20})
            Text(item.title).fontSize(12).fontColor("rgba(121, 119, 119, 1.00)")
          }.width("18%").height(70).justifyContent(FlexAlign.Center)
        })
      }.width("100%").height(70)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left:10,right:10})
      .backgroundColor(Color.White)
      .borderRadius(10)
      Blank(30)


      Column({space:15}){
        ForEach(this.end_list,(item:DataItems)=>{
          Row({space:10}){
            Image(item.icon).size({width:22,height:22}).interpolation(ImageInterpolation.High)
            Text(item.title).fontSize(16).width("75%" )
            Image($r("app.media.right")).size({width:25,height:25})
          }.width("100%").height(30).justifyContent(FlexAlign.SpaceBetween)
        })
      }.padding(20)
      .backgroundColor(Color.White)
      .borderRadius(10)
      Blank(300)
    }.padding(20).backgroundColor("rgb(245, 245, 245)")
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [["rgb(254, 203, 169)", 0.0], ["RGB(245, 245, 245)", 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })

  }


  //切换夜间模式
  night_onclick(){

  }
  //头像点击事件
  avatar_onclick(){

  }

  //跳转云盘登录
  cloudDisk_onclick(){

  }

}

export class DataItems{

    title:string

    value:String|number

    icon:ResourceStr

    constructor(title:string='',value:String|number='',icon:ResourceStr=''){
      this.title=title;
      this.value=value;
      this.icon=icon;
    }
}