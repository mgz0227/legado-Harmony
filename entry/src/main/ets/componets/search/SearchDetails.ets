import { SearchBook } from '../dataList/SearchBook'
import { SearchBookList } from './SearchBookList'
import { common } from '@kit.AbilityKit'
import { util } from '@kit.ArkTS'

@Component
export struct SearchDetails{
  @Prop SearchValue:string
  @State isRefreshing: boolean = false
  @State counter: number = 0
  @State typeList: string[] = ["小说","漫画","有声书"]
  @State typeIndex:number=0
  @Consume @Watch("refresh") SearchStatus:number
  @State color:string="rgba(0, 0, 0, 0.45)"
  refresh(){
    if(this.SearchStatus>2){
      this.isRefreshing=true
    }
  }
  @Builder RefreshComponent(){
    Stack(){
      Row(){
        LoadingProgress().color("#FF6600").height(26)
        Text("共搜索到"+this.counter+"个相关结果").fontSize(14).margin({left:20}).fontColor(this.color)
      }.alignItems(VerticalAlign.Center)
    }.width("100%").align(Alignment.Center)
  }
  build() {
    Column(){
      //小说类型切换
      Row(){
        Row({space:30}){
          ForEach(this.typeList,(item:string,index:number)=>{
              Text(item)
                .fontSize(16)
                .fontColor(this.typeIndex==index?"#000000":this.color)
                .onClick(()=>{
                  this.typeIndex=index
                })
          })
        }.width("60%").height("100%")
        //筛选
        Row({space:5}){
          Image($r("app.media.screen")).width(20).height(20).fillColor(this.color)
          Text("筛选").fontColor(this.color)
        }.width("40%").height("100%").justifyContent(FlexAlign.End)
      }.size({width:"100%",height:40}).padding({left:20,right:20}).margin(10)
      //书籍列表
      Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 ,builder:this.RefreshComponent}) {
        SearchBookList({SearchValue:this.SearchValue}).backgroundColor("#ffffff")
      }.onStateChange((refreshStatus: RefreshStatus) => {
        if(refreshStatus=RefreshStatus.Refresh){
          this.counter++
        }
      }).onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
          this.counter=0
        }, 5000)
      }).backgroundColor("rgba(0, 0, 0, 0.06)")
    }
  }
  //初始化
  aboutToAppear(): void {

  }
}