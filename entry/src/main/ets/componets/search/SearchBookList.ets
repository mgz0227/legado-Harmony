
import { common } from '@kit.AbilityKit'
import { util } from '@kit.ArkTS'
import CommonConstants from '../../common/constants/CommonConstants'
import { ThemeStorageKey } from '../../common/constants/Theme'
import taskSearchBooks from '../../common/model/taskSearchBook'
import { ThemeItem } from '../../common/model/Theme'
import { SearchBook } from '../../database/entities/SearchBook'
import { SearchBookItem } from './SearchBookItem'

@Component
export struct SearchBookList {
  @Link isSearch:boolean
  @State cachedCountNumber: number = 5; // 懒加载缓存数
  @State firstIndex: number = 0; // 当前显示在屏幕上的子组件索引值，用来控制下方按钮跳转
  @Prop SearchValue:string
  @State titleLists:string[]=[]
  @State isRefreshing: boolean = false
  @State counter: number = 0
  @Prop typeIndex:number
  @Prop booksList:SearchBook[]
  listScroller: ListScroller = new ListScroller(); // scroller控制器
  historyOffset: number = 0; // 上次浏览到列表距离顶端的偏移量offset
  readonly DEFAULT_OFFSET: number = 0; // 默认跳转位置，用于第一次进入页面的跳转位置
  readonly ANIMATION_DURATION: number = 500; // 动画持续时间
  readonly SWITCH_BUTTON: number = 5; // 当前显示在屏幕上的子组件Index到达该阈值时，将跳转到历史记录按钮切换成跳转到顶部
  @State listOffsetY:number=0
  @State listScrollerY:number = 0
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    Column(){
      List({space:8,scroller:this.listScroller}){
        ForEach(this.booksList,(item:SearchBook,index)=>{
          if (item.bookType === this.typeIndex){
            ListItem(){
              SearchBookItem({book:item,SearchValue:this.SearchValue,index:index})
            }
          }
        })
      }
      .onAreaChange((oldNumber,newNumber)=>{
        this.listOffsetY = newNumber.height as number
      })
      .cachedCount(this.cachedCountNumber)
      .layoutWeight(1)
      .chainAnimation(true)
      .scrollBar(BarState.Off)
      .onScrollIndex((first: number) => {
        this.firstIndex = first;
      })
      .onWillScroll(()=>{
        this.listScrollerY = this.listScroller.currentOffset().yOffset
      })

      Row(){
        LoadingProgress()
          .color(this.theme.mainColor)
          .width(30)
          .height(30)
        Text('搜索中...')
          .font({
            size:14,
            weight:500
          })
          .fontColor(this.theme.mainColor)
      }
      .visibility(this.isSearch?Visibility.Visible:Visibility.None)
      .position({ x: '95%', y: '0%'})
      .markAnchor({ x:'95%'})

      Column({
        space:5
      }){
        Image($r('app.media.icon_search_stop'))
          .width(24).height(24)
          .fillColor(this.theme.mainColor)
        Text('停止')
          .font({
            size:14,
            weight:500
          })
          .fontColor(this.theme.mainColor)
      }
      .onClick(()=>{
        this.isSearch = false
        taskSearchBooks.cancelAllTasks()
      })
      .visibility(this.isSearch?Visibility.Visible:Visibility.None)
      .padding(10)
      .position({ x: '95%', y: '80%'})
      .markAnchor({ x:'90%'})
      .opacity(0.8)
      .borderRadius(8)


      Column({
        space:CommonConstants.SPACE_6
      }){
        Image(this.firstIndex < this.SWITCH_BUTTON ?$r('app.media.icon_back') :$r('app.media.pip_to_top'))
          .width(12)
          .height(12)
          .fillColor('#FFF')
        Text(this.firstIndex < this.SWITCH_BUTTON ? '返回浏览处': '顶部')
          .font({
            size:14,
            weight:500
          })
          .fontColor('#fff')
      }
      .visibility(this.listScrollerY  > this.listOffsetY || this.historyOffset > 0 ?Visibility.Visible:Visibility.None)
      .padding(10)
      .position({ x: '95%', y: '90%'})
      .markAnchor({ x:'90%'})
      .opacity(0.8)
      .backgroundColor(this.theme.mainColor)
      .borderRadius(8)
      .onClick(() => {
        // 当前显示的index值小于设定的SWITCH_BUTTON时，按钮为跳转到上次浏览记录，否则为跳转到顶部
        if (this.firstIndex < this.SWITCH_BUTTON) {
          this.listScroller.scrollTo({
            xOffset: 0,
            yOffset: this.historyOffset === 0 ? this.DEFAULT_OFFSET : this.historyOffset,
            animation: { duration: this.ANIMATION_DURATION, curve: Curve.LinearOutSlowIn }
          });
        } else {
          this.historyOffset = this.listScroller.currentOffset().yOffset;
          this.listScroller.scrollTo({
            xOffset: 0,
            yOffset: 0,
            animation: { duration: this.ANIMATION_DURATION, curve: Curve.LinearOutSlowIn }
          });
        }
      })
    }
  }





  subKeyword(key:string,str:string):string[]{
    let start=str.indexOf(key)
    if(start<0){
      return [str]
    }
    let end=start+key.length
    let key_start=str.substring(0,start)
    let key_end=str.substring(end,str.length)
    console.log(key_start+"---"+key_end);
    return [key_start,key,key_end]
  }
  //获取rawfile目录文件
  getBookList(){
    let context=getContext() as common.UIAbilityContext;
    let resourceManager=context.resourceManager
    let values:string=""
    resourceManager.getRawFileContent("book.json", (error, value) => {
      if (error != null) {
        console.log("error is " + error);
      } else {
        let decoder = util.TextDecoder.create('utf-8',{ignoreBOM : true })
        values = decoder.decodeWithStream(value,{stream:false});
        // this.bookList=JSON.parse(values)
      }
    });
  }
}

