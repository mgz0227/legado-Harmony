import { Attribute } from '../../../common/utils/Attribute'
import router from '@ohos.router'
import { WebdavService } from '../../../componets/webDavService/WebdavService'
import { promptAction } from '@kit.ArkUI'
import { dataItem } from '../../../componets/dataList/dataItem'
import { PublicConstants, TextConstants } from '../../../common/constants/PublicConstants'
import { ColumnModifier } from '../../../common/utils/ComponetModifier'

@Entry
@Component
export default struct MyCenter {

  @State reading_time:number = 0
  @State head_list:dataItem[]=[
    new dataItem("读过",20),
    new dataItem("读完",20),
    new dataItem("书签",20),
    new dataItem("勋章",20),
  ]
  @State center_list:dataItem[]=[
    new dataItem("备份",1,$r("app.media.my_center_cloud_icon")),
    new dataItem("主题",2,$r("app.media.my_center_book_icon")),
    new dataItem("书源",3,$r("app.media.my_center_theme_icon")),
    new dataItem("净化",4,$r("app.media.my_center_purify_icon")),
  ]

  @State end_list:dataItem[]=[
    new dataItem("帮助中心",1,$r("app.media.my_center_help_icon")),
    new dataItem("关于我们",2,$r("app.media.my_center_about_icon")),
    new dataItem("清理缓存",3,$r("app.media.my_center_clean_icon")),
    new dataItem("文件管理",4,$r("app.media.my_center_file_icon")),
  ]
  @StorageLink('topRectHeight') topRectHeight: number = 0
  Column = new ColumnModifier()
  build() {
    Column(){
      Blank(this.topRectHeight-20)
      //右上角模式图标
      Row({space:10}){
        //设置图标
        Image($r("app.media.my_center_set_icon")).size({width:30,height:30}).interpolation(ImageInterpolation.Medium)
          .onClick(()=>{
            this.toMySetPage()
          })
          //夜间模式图标
        Image($r("app.media.night_icon")).size({width:30,height:30}).interpolation(ImageInterpolation.Medium)
      }.justifyContent(FlexAlign.End).width("100%").onClick(this.night_onclick)

      Blank(30)

      //头像及云盘登录
      Row(){
        //头像
        Image($r("app.media.user_avatar")).size({width:54,height:54})
          .borderRadius(60)
          .interpolation(ImageInterpolation.Medium).onClick(this.avatar_onclick)
        //昵称及阅读时长
        Column({space :8}){
          Text("夏目友人").fontSize(16).fontWeight(600).lineHeight(24)
          Text("今日阅读"+this.reading_time+"分钟").fontSize(12).fontColor(TextConstants.TEXT_FONT_COLOR)
            .lineHeight(20)
        }.alignItems(HorizontalAlign.Start).width("45%").height("100%")

        .justifyContent(FlexAlign.SpaceBetween)
        //云盘登录
        Row(){
          Text("云盘登录")
            .fontColor(TextConstants.TEXT_FONT_COLOR)
            .fontSize(12)
            .width(48)
            .height(22)
        }.onClick(()=>{this.cloudDisk_onclick()})

        .border({width:1,color:TextConstants.TEXT_FONT_COLOR,radius:25})
        .padding({ top:4,left:14,right:14,bottom:4 }).borderWidth(1)
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").height(54).onClick(this.night_onclick)

      Blank(24)

      // 统计数据
      Row(){
        ForEach(this.head_list,(item:dataItem,index:number)=>{
          Column({space:5}){
            Text(item.value.toString()).fontSize(20).fontWeight(600)
            Text(item.title).fontSize(10).fontWeight(500)
          }.onClick(()=>{
            this.head_onclick(index)
          })
        })
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left:20,right:20})

      Blank(16)

      //云盘 书源 主题 净化设置
      Row(){
        ForEach(this.center_list,(item:dataItem)=>{
          Column({space:4}){
            Image(item.icon).size({width:24,height:24})
            Text(item.title).fontSize(12)
          }
          .width(80)
          .height(48)
          .justifyContent(FlexAlign.Center)
          .onClick(()=>this.centerOnclick(item.value))
        })
      }.width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({top:16,bottom:16})
      .backgroundColor(PublicConstants.THEME_COLOR_WHITE)
      .borderRadius(10)
      Blank(16)

      //web服务

      WebdavService()
      Blank(16)

      //帮助 关于 清理缓存 设置
      Column(){
        ForEach(this.end_list,(item:dataItem)=>{
          Row({space:10}){
            Image(item.icon).size({width:20,height:20}).interpolation(ImageInterpolation.High)
            Text(item.title).fontSize(14).width("75%" )
            Image($r("app.media.right")).size({width:24,height:24})
          }.width(300)
          .height(48)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({top:12,bottom:12})
          .onClick(()=>this.endOnclick(item.value))
        })
      }.padding({top:5,bottom:5})
      .backgroundColor(PublicConstants.THEME_COLOR_WHITE)
      .borderRadius(10)
      .justifyContent(FlexAlign.SpaceBetween)
      .size({width:"100%",height:210})
      Blank(200)
    }
    .attributeModifier(this.Column)
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

  //读过点击事件
  head_onclick(value:number){
    console.log("点击了"+value)
    if(value==3){
      //勋章
    }else{
      router.pushUrl({
        url:"pages/view/myCenter/readStatistics",
        params:{
          value:value
        }
      })
    }
  }
  //云盘,书源,主题,净化点击事件
  centerOnclick(value:number|string){
    switch (value){
      case 1:
        // promptAction.showToast({
        //   message: '请点击右上角，完成云盘登录',
        //   duration: 1000,
        // })
        router.pushUrl({
          url: 'pages/view/myCenter/cloudDisk'
        })
        break
      case 2:
        break
      case 3:
        break
      case 4:
        break
    }
  }

  //帮助中心,关于阅读,清理缓存,我的设置点击事件
  endOnclick(value:number|string){
    switch (value){
      case 1:
        // 帮助中心
        router.pushUrl({
          url: 'pages/view/myCenter/helpCenterPage'
        })
        break;
      case 2:
        // 关于我们
        router.pushUrl({
          url: 'pages/view/myCenter/aboutUs/aboutUsPage'
        })
        break;
      case 3:
        // 清理缓存
        router.pushUrl({
          url: 'pages/view/myCenter/clearCache'
        })
        break;
      case 4:

    }
  }
  toMySetPage(){
    router.pushUrl({
      url: 'pages/view/myCenter/MySetPage'
    })
  }
  //跳转云盘登录
  cloudDisk_onclick(){
    router.pushUrl({
      url: 'pages/view/myCenter/WebDav'
    })
  }
}
