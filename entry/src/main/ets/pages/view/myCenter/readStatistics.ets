import { ColumnModifier } from '../../../common/utils/ComponetModifier';
import { router } from '@kit.ArkUI';
import CommonConstants from '../../../common/constants/CommonConstants';
import { dataItem } from '../../../componets/dataList/dataItem';
import { readStatisticsDataList } from '../../../componets/myCenter/readStatisticsDataList';
import { readBookList } from '../../../componets/dataList/readBookList';
import { readTabs } from '../../../componets/myCenter/readTabs';
import { serviceDialog } from '../../../componets/webDavService/serviceDialog';
import { PublicConstants } from '../../../common/constants/PublicConstants';


@Entry
@Component
struct readStatistics {

  Column = new ColumnModifier()
  @State type:number|string=(router.getParams() as dataItem).value
  @State read_list:dataItem[]=[
    new dataItem("小说",12),
    new dataItem("漫画",12),
    new dataItem("有声书",12),
  ]
  @State title_list:dataItem[]=[
    new dataItem("读过",12),
    new dataItem("读完",12),
    new dataItem("书签",12),
  ]
  @State read_index:number=0
  @State translateNum:number=0
  @State translateX:number=120
  @State dateValue:number[]=[2023,36]
  @Provide delStatus:boolean=false

  @State delDialog:boolean=false
  @State bookList:readBookList[]=[
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[20,23],new Date(),20,0),
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[21,23],new Date(),30,1),
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[22,23],new Date(),40,2),
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[23,23],new Date(),70,3),
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[23,23],new Date(),70,3),
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[23,23],new Date(),70,3),
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[23,23],new Date(),70,3),
    new readBookList("夜的命名术",$r("app.media.book_cover"),"会说话的肘子",[23,23],new Date(),70,3),

  ]
  @Builder head(){
    Row(){
      Row(){
        Image($r("app.media.return_left"))
          .size({width:CommonConstants.TITLE_IMG_SIZE,height:CommonConstants.TITLE_IMG_SIZE})
          .onClick(()=>{
            router.back()
          })
      }.width("33%")
      Row(){
        Text(this.title_list[this.type].title).fontSize(16).fontWeight(600).lineHeight(24)
      }.width("33%")
      .justifyContent(FlexAlign.Center)
      Row(){
        Text(this.delStatus?"完成":"管理")
          .fontSize(14)
          .fontWeight(500)
          .lineHeight(22)
          .fontColor("rgba(0, 0, 0, 0.45)")
          .onClick(()=>{
            this.delStatus=!this.delStatus
          })
      }.width("33%").justifyContent(FlexAlign.End)
    }.width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({top:12,bottom:12})
  }

  @Builder delBottom(){
      Button({ type: ButtonType.Normal, stateEffect: true }){
        Row(){
          Text("删除").fontColor(Color.Red)
        }.height("100%")
      }.backgroundColor(PublicConstants.THEME_COLOR_WHITE)
      .width("100%")
      .height(50)
      .borderColor("rgba(0, 0, 0, 0.06)")
      .borderWidth({
        top:1
      })
      .visibility(this.delStatus?Visibility.Visible:Visibility.None)
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.animation({ duration: 500 }).combine(
            TransitionEffect.translate({ y: 50 }).animation({  duration: 500 }))
          ,
          TransitionEffect.OPACITY.animation({ duration: 500 }).combine(
            TransitionEffect.translate({ y: 0}).animation({ duration: 500 }))
        )
      )
    .onClick(()=>{
      this.deleteList()
    })
  }
  build() {
    Column(){
      Column(){
        this.head()
        readTabs({
          read_list:this.read_list
        })
        //tab条 小说漫画有声书切换
        //书籍组件
        readStatisticsDataList({
          dateValue:this.dateValue,
          bookList:this.bookList
        })
      }.attributeModifier(this.Column)
      .height(CommonConstants.FULL_HEIGHT)
      .width(CommonConstants.FULL_WIDTH)
    }.overlay( this.delBottom(), {
      align: Alignment.Bottom,
      offset: { x: 0, y: 0 }
    })

  }

  //删除列表
  deleteList(){
    this.clearInfoDel?.open()
  }
  onCancel(){

  }
  onAccept(){
    this.bookList=this.bookList.filter(item=>item.status!=true)
    this.bookList.forEach(item=>console.log(item.status+"--"))
    this.delStatus=!this.delStatus

  }
  exitApp() {
    this.delDialog = false
  }
  clearInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: serviceDialog({
      title:"确认删除吗？",
      value:"",
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
      console.log(this.type+"------")
  }

}