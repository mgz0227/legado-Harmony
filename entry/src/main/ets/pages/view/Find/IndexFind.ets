import groupTypeComponent from '../../../componets/group/GroupType';
import BookMark from '../../../componets/head/BookMark';
import { router } from '@kit.ArkUI';
import novelFind from './novelFind';
import RefreshComponent from '../../../componets/common/RefreshComponent';
import noSourceFind from '../../../componets/common/noSourceFind';
import cartoonFind from './cartoonFind';
import soundFind from './soundFind';
/**
 * @author 2008
 * @datetime 2024/6/26 23:55
 * @className: RefreshComponent
 * 发现入口
 */
@Component
@Entry
@Preview
export default struct IndexFind {
  private scrollController: Scroller = new Scroller();
  titleArray:Array<string> = ['小说', '漫画', '有声书']
  @State currentIndex:number = 0
  tabsController: TabsController = new TabsController();
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = false
  @State groupCoverShow: boolean = false
  @State bookType: string = '全部'
  @State GROUP: string = '标签'
  build() {
    Column(){
      Flex({
        justifyContent:FlexAlign.SpaceBetween
      }){
        Row(){
          List({scroller:this.scrollController}){
            ListItem(){
              BookMark({ title: '小说', index: 0, currentIndex: this.currentIndex }).onClick(() => {
                this.currentIndex = 0
                this.tabsController.changeIndex(0)
                console.log(this.currentIndex + '')
              })
            }
            ListItem(){
              BookMark({ title: '漫画', index: 1, currentIndex: this.currentIndex }).onClick(() => {
                this.currentIndex = 1
                this.tabsController.changeIndex(1)
                console.log(this.currentIndex + '')
              })
            }
            ListItem(){
              BookMark({ title: '有声书', index: 2, currentIndex: this.currentIndex }).onClick(() => {
                this.currentIndex = 2
                this.tabsController.changeIndex(2)
                console.log(this.currentIndex + '')
              })
            }
          }
          .height(40)
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)
        }
        Image($r('app.media.addSubscription')).width(24)
      }
      .padding({top:this.topRectHeight === 0 ? 30 : this.topRectHeight,left:20,right:20})

      Search({
        placeholder:'搜索书名或作者'
      })
        .margin({
          top:8,bottom:8,
          left:20,right:20
        })
        .backgroundColor(Color.White)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/view/search/SearchBook'
          });
        })

      Tabs({
        barPosition: BarPosition.Start,
        controller: this.tabsController
      }) {
       ForEach(this.titleArray,(item:string)=>{
         TabContent() {
           this.indexFind()
         }
         .align(Alignment.Top)
       })
      }
      .layoutWeight(1)
      .barWidth(0)
      .barHeight(0)
      .onChange((index) => {
        this.tabsController.changeIndex(index)
        this.currentIndex = index
      })
      .scrollable(this.APP_INDEX_SCROLLABLE)
    }
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [
        ["rgb(254, 203, 169)", 0], ["RGB(245, 245, 245)", 0.15]
        ,["RGB254, 203, 169)", 0.25]] // 数组末尾元素占比小于1时满足重复着色效果
    })
  }
  @State isRefreshing: boolean = false
  @State counter: number = 0
  @State RefreshingTitle: string = '松开刷新'
  @State isShowNoFind:boolean = true
  @Builder
  indexFind() {
    Column(){
      groupTypeComponent({
        bookType: this.bookType,
        currentIndex: this.currentIndex,
        groupCoverShow: this.groupCoverShow,
        GROUP: this.GROUP
      })
        .padding(5)
        .zIndex(999)
      if (this.isShowNoFind){
        noSourceFind({
          setOnclick: () => {
            this.isShowNoFind = false
          }
        })
      } else {
        Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
          Scroll(){
            Stack({ alignContent: Alignment.Center }) {
              if (this.currentIndex === 0){
                novelFind()
              } else if (this.currentIndex === 1){
                cartoonFind()
              } else if (this.currentIndex === 2){
                soundFind()
              }
            }
            .padding({
              left:20,right:20,bottom:20
            })
          }
          .scrollBar(BarState.Off)
        }
        .layoutWeight(1)
        .onStateChange((refreshStatus: RefreshStatus) => {
          if (refreshStatus === 1 || refreshStatus === 2) {
            this.RefreshingTitle = '松开刷新'
          } else {
            this.RefreshingTitle = '刷新中...'
          }
        })
        .onRefreshing(() => {
          setTimeout(() => {
            this.counter++
            this.isRefreshing = false
          }, 1000)
        })
      }
    }
  }

  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }

}