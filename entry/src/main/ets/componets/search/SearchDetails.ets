
import { SearchBookList } from './SearchBookList'
import { SearchBook } from '../../database/entities/SearchBook'
import { ThemeItem } from '../../common/model/Theme'
import { ThemeStorageKey } from '../../common/constants/Theme'

@Component
export struct SearchDetails{
  @Prop SearchValue:string
  @State isRefreshing: boolean = false
  @State counter: number = 0
  @State typeList: string[] = ["小说","漫画","有声书"]
  @State typeIndex:number=0
  @Consume @Watch("refresh") SearchStatus:number
  @Consume('searchBookList') books:SearchBook[]
  @Consume('isSearch') isSearch:boolean
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  refresh(){
    if(this.SearchStatus>2){
      this.isRefreshing=true
    }
  }
  @Builder RefreshComponent(){
    Stack(){
      Row(){
        LoadingProgress().color(this.theme.mainColor).height(26)
        Text("共搜索到"+this.books.length+"个相关结果").fontSize(14).margin({left:20}).fontColor($r('app.string.color_black_45'))
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
                .fontColor(this.typeIndex==index?"#000000":$r('app.string.color_black_45'))
                .onClick(()=>{
                  this.typeIndex=index
                })
          })
        }.width("60%").height("100%")
        //筛选
        Row({space:5}){
          Image($r("app.media.screen")).width(20).height(20).fillColor($r('app.string.color_black_45'))
          Text("筛选").fontColor($r('app.string.color_black_45'))
        }.width("40%").height("100%").justifyContent(FlexAlign.End)
      }.size({width:"100%",height:40}).padding({left:20,right:20}).margin(10)
      //书籍列表
      Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 ,builder:this.RefreshComponent}) {
        SearchBookList({SearchValue:this.SearchValue,booksList:this.books,typeIndex:this.typeIndex,isSearch:this.isSearch}).backgroundColor("#ffffff")
      }
      //给border添加加载动画
      .border({
        width: { top:this.isSearch?2:0 },color:this.theme.mainColor
      })
      .borderStyle({
        top:BorderStyle.Solid,
      })
      .onStateChange((refreshStatus: RefreshStatus) => {
      }).onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 5000)
      }).backgroundColor("rgba(0, 0, 0, 0.06)")
    }
    .padding({
      bottom:this.bottomRectHeight
    })
    .layoutWeight(1)
  }
  //初始化
  aboutToAppear(): void {

  }
}