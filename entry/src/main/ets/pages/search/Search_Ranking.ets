
/**
 * 废弃组件 搜索页排行榜组件
 */
@Component
export struct Ranking{
  rankList:string[]=["我在精神病院学斩神1111111111111111","暮年修仙，我成长寿道尊","全家流放：我搬空国库去逃荒！","上班摸鱼被抓，反手拉女总裁","我的26岁女房客","我在精神病院学斩神","我在精神病院学斩神","我在精神病院学斩神","我在精神病院学斩神","我在精神病院学斩神"];
  build(){
    Column(){
      Column(){
        Image("/common/images/ranking_1.png").width(260).height(50).objectFit(ImageFit.Auto)
      }.margin({bottom:20})
      ForEach(this.rankList,(item :string,index:number)=>{
        Row({space:20}){
          Text((index+1).toString()).fontColor((index+1)>3?"rgb(191, 191, 191)":"#EF4444").fontWeight(600).margin({bottom:20})
          Text(item).width(150).margin({bottom:20}).textOverflow({overflow:TextOverflow.Ellipsis}).maxLines(1)
        }
      })
      Row(){
        Text("查看更多").fontColor("rgba(0, 0, 0, 0.45)")
        Image("/common/images/search_launch.svg")
          .width(24)
          .height(24)
          .fillColor($r("app.color.search_launch"))
          .rotate({angle: 270})
      }.width("100%").justifyContent(FlexAlign.Center)
    }.border({width:1,color:"rgb(255, 234, 221)",radius:10}).width(260).height("85%").clip(true)
  }
}