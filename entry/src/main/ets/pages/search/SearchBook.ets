import { Ranking } from './Search_Ranking'

@Entry
@Component
struct SearchBook {
  @State SearchValue: string =""
  scroller: Scroller = new Scroller()
  @State  historyBookNames: String[] = ["仙逆","一念永恒","一念永恒","一念永恒", "一念永恒", "吞噬星空", "凡人修仙传", "夜的命名术", "夜的命名术", "一念永恒", "一念永恒", "一念永恒", "一念永恒", "一念永恒"]
  @State rankingList: String[] = ["小说热搜榜", "漫画热搜榜", "听书热搜榜"]
  @State rotateImages: number=0;
  @State rotateState: boolean=false;
  build() {
    Column() {
      //顶部搜索框
      Row({ space: 20 }) {
        Search({ value: this.SearchValue, placeholder: '搜索书名或作者', icon: "/common/images/search.svg" })
          .width("80%")
          .height(40);
        Text("取消").width("15%").height(40).fontWeight(600)
      }.width("100%").height(40)
      //搜索历史
      Row({ space: 90 }) {
        Text("搜索历史").width("40%").height(40).fontWeight(600).fontSize(20);
        Row({ space: 10 }) {
          Row() {
            Text(this.rotateState?"收起":"展开").fontColor($r("app.color.search_launch"))
            Image("/common/images/search_launch.svg").width(24).height(24).fillColor($r("app.color.search_launch"))
              .onClick((event: ClickEvent) => {
                if(this.rotateState==true){
                  this.rotateImages=0;
                  this.rotateState=false;
                }else{
                  this.rotateImages=180;
                  this.rotateState=true;
                }
              })
              .animation({
                duration: 1000,
                tempo:2
              })
              .rotate({angle: this.rotateImages})
          }

          Image("/common/images/search_del.svg").width(24).height(24).fillColor($r("app.color.search_launch"))
        }
      }.width("100%").margin({ top: 20 });

      //历史记录
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(this.historyBookNames, (item: String, index) => {
          Text(item.toString())
            .padding({ top: 5, left: 15, right: 15, bottom: 5 })
            .backgroundColor($r("app.color.search_history"))
            .margin({ right: 10, bottom: 10 })
            .fontSize(13)
        })
      }.width("100%").height(this.rotateState?180:100)
      .margin({ top: 10 }).clip(true);

      //排行榜
      // Scroll(this.scroller) {
      //   Row({ space: 20 }) {
      //     ForEach(this.rankingList, (item) => {
      //       //排行榜内容组件
      //       Ranking()
      //     })
      //   }.width("50%").height("80%").alignItems(VerticalAlign.Top).margin({ top: 20 })
      // }
      // .scrollable(ScrollDirection.Horizontal)
      // .width(1700)
    }.margin(20)

  }
}
