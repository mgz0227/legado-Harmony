import { showMessage } from '../componets/common/promptShow'
import ReadShow from '../componets/common/ReadShow'
import { NavItem } from '../componets/dataList/type'
import { updateAppData } from '../storage/appData'
import BookShelf from './view/BookShelf'
import Find from './view/Find/Find'
import MyCenter from './view/myCenter/MyCenter'
import Subscription from './view/Subscription'
import {testGetColorFunction} from '@ohos/colorLibrary'
import { BusinessError, emitter } from '@kit.BasicServicesKit'
import { JSON } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'
import { ThemeStorageKey } from '../common/constants/Theme'
import { ThemeItem } from '../common/model/Theme'

@Entry
@Component
struct Main {
  @State showReadShow:boolean = true
  @State currentTabIndex: number = 0
  @State isShow: boolean = true
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = true
  @State ShowBar: boolean = true
  tabController: TabsController = new TabsController()

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  onPageShow(): void {
    // initBookListData()
    setTimeout(()=>{
      this.showReadShow = false
      this.isShow = false
    }, 5000)

    getContext(this).eventHub.on('SubscriptionBatchEdit', (params: boolean) => {
      this.ShowBar = params
      this.APP_INDEX_SCROLLABLE = !this.APP_INDEX_SCROLLABLE
      console.log('SubscriptionBatchEdit:' + params)
    })
  }

  screenShot() {
    // 切换回首页
    let index = this.currentTabIndex
    this.tabController.changeIndex(0)
    this.getUIContext().getComponentSnapshot().get('main', ((err: Error, pixmap: image.PixelMap) => {
      if (err) {
        console.log("error: " + JSON.stringify(err))
        return
      }
      AppStorage.setOrCreate('screen_shot', pixmap)
    }))
    // 恢复当前页
    this.tabController.changeIndex(index)
  }

  aboutToAppear(): void {
    // 注册监听截图事件 用于我的页面下主题设置预览
    emitter.on('screen_shot', () => {
      this.screenShot()
    })
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
        Image(this.currentTabIndex === index? icon_select:unselected).height(25)
          .draggable(false)
          .fillColor(this.currentTabIndex === index ? this.theme.mainColor : '#000000')
        Text(name).fontSize(11).margin(5).fontColor(this.currentTabIndex === index ? this.theme.mainColor : '#000000')
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

  build() {
    Column() {
      Tabs({
        barPosition:BarPosition.End,
        controller: this.tabController
      }){
        ForEach(this.nav,(item:NavItem) => {
          TabContent() {
            Column() {
              if (item.index === 0){
                BookShelf()
              } else if (item.index === 1){
                Find()
              } else if (item.index === 2){
                Subscription({
                  currentTabIndex:this.currentTabIndex
                })
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
      .barHeight(this.ShowBar?null:0)
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
    .id('main')
  }
}