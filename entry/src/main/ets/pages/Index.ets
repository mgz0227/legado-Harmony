import { showMessage } from '../componets/common/promptShow'
import ReadShow from '../componets/common/ReadShow'
import { NavItem } from '../componets/dataList/type'
import { updateAppData } from '../storage/appData'
import BookShelf from './view/BookShelf'
import Find from './view/Find/Find'
import MyCenter from './view/myCenter/MyCenter'
import Subscription from './view/Subscription'
import {testGetColorFunction} from '@ohos/colorLibrary'

@Entry
@Component
struct Main {
  @State showReadShow:boolean = true
  @State currentTabIndex: number = 0
  @State isShow: boolean = true
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = true
  onPageShow(): void {
    // initBookListData()
    setTimeout(()=>{
      this.showReadShow = false
      this.isShow = false
    },5000)
  }

  aboutToAppear(): void {
    //测试颜色模块
    testGetColorFunction();
  }

  @Builder TabBuilder(index = 0, name: string,icon_select: Resource,unselected: Resource) {
    Column(){
      Flex({
        direction:FlexDirection.Column,
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.Center
      }){
        Image(this.currentTabIndex === index?icon_select:unselected).height(25)
        Text(name).fontSize(11).margin(5).fontColor(this.currentTabIndex === index ?'rgb(255,119, 50)' : '#000000')
      }
    }.gesture(
      LongPressGesture({ repeat: index === 0,duration:1000 })
        .onAction((event: GestureEvent) => {
          console.log('onAction' + event.repeat)
          if (event.repeat) {
            updateAppData(!this.APP_INDEX_SCROLLABLE)
            showMessage(this.APP_INDEX_SCROLLABLE?'标签栏锁已开启':'标签栏已解锁')}}))
    .width('100%')
    .margin({top:4})
    .height("100%")
  }

  nav : NavItem[] = [
    new NavItem(0,$r("app.media.HOME_theme"),$r('app.media.HOME_line') ,'书架'),
    new NavItem(1,$r('app.media.FIND_theme'), $r('app.media.FIND_line') ,'发现'),
    new NavItem(2,$r('app.media.SUB_theme'),$r('app.media.SUB_line'), '订阅源'),
    new NavItem(3, $r('app.media.MINE_theme'),$r('app.media.MINE_line'), '我的')
  ]

  // @State scrollType:MainScrollBar[] = [
  //   new MainScrollBar(false,new Scroller()),
  //   new MainScrollBar(false,new Scroller()),
  //   new MainScrollBar(false,new Scroller()),
  //   new MainScrollBar(false,new Scroller()),
  //   new MainScrollBar(false,new Scroller())
  // ]

  build() {
    Column() {
      Tabs({
        barPosition:BarPosition.End
      }){
        ForEach(this.nav,(item:NavItem) => {
          TabContent() {
            Column() {
              if (item.index === 0){
                BookShelf()
              } else if (item.index === 1){
                Find()
              } else if (item.index === 2){
                Subscription()
              }
              if (item.index === 3){
                MyCenter()
              }
            }
          }.tabBar(
            this.TabBuilder(item.index,item.title,item.selectImg,item.unselected)
          )
        })
      }
      .scrollable(!this.APP_INDEX_SCROLLABLE)
      .padding({bottom:this.bottomRectHeight})
      .onChange((index) => {
        this.currentTabIndex = index
      })
      if (this.showReadShow){
        ReadShow({showReadShow:this.showReadShow}).offset({y:-150 - this.bottomRectHeight})
      }
    }
    .width("100%")
    .height("100%")
  }
}