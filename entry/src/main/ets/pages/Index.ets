import { MainScrollBar, NavItem } from '../componets/dataList/type'
import BookShelf from './view/BookShelf'
import Find from './view/Find'
import MyHome from './view/MyHome'
import Subscription from './view/Subscription'

@Entry
@Component
struct Main {

  @State currentTabIndex: number = 0

  @Builder TabBuilder(index = 0, name: string,icon_select: Resource,unselected: Resource) {
    Flex({
      direction:FlexDirection.Column,
      alignItems:ItemAlign.Center,
      justifyContent:FlexAlign.Center
    }){
      Image(this.currentTabIndex === index?icon_select:unselected).width(25).height(25)
      Text(name).fontSize(11).fontColor(Color.Black).margin(5).fontColor(this.currentTabIndex === index ?'rgb(255,119, 50)' : '#000000')
    }
  }

  nav : NavItem[] = [
    new NavItem(0,$r("app.media.HOME_theme"),$r('app.media.HOME_line') ,'书架'),
    new NavItem(1,$r('app.media.FIND_theme'), $r('app.media.FIND_line') ,'发现'),
    new NavItem(2,$r('app.media.SUB_theme'),$r('app.media.SUB_line'), '订阅源'),
    new NavItem(3, $r('app.media.MINE_theme'),$r('app.media.MINE_line'), '我的')
  ]

  @State scrollType:MainScrollBar[] = [
    new MainScrollBar(false,new Scroller()),
    new MainScrollBar(false,new Scroller()),
    new MainScrollBar(false,new Scroller()),
    new MainScrollBar(false,new Scroller()),
    new MainScrollBar(false,new Scroller())
  ]

  build() {
    Column() {
      Tabs({
        barPosition:BarPosition.End
      }){
        ForEach(this.nav,(item:NavItem) => {
          TabContent() {
            Column() {
              Scroll(this.scrollType[item.index].isScroll) {
                if (item.index === 0){
                  BookShelf()
                } else if (item.index === 1){
                  Find()
                } else if (item.index === 2){
                  Subscription()
                } else if (item.index === 3){
                  MyHome()
                }
              }
            }
          }.tabBar(
            this.TabBuilder(item.index,item.title,item.selectImg,item.unselected)
          )
        })
      }
      .backgroundColor('rgba(214, 213, 213, 0.7)')
      .onChange((index) => {
        this.currentTabIndex = index
      })
    }
  }
}