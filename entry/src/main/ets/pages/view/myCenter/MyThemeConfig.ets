import { PromptAction, router } from '@kit.ArkUI'
import { ThemeColor, ThemeStorageKey } from '../../../common/constants/Theme'
import { ThemeColorItem, ThemeItem } from '../../../common/model/Theme'
import { MyThemeConfigComp } from './MyThemeConfigComp'

// 中间导航区需要渲染的元素列表
interface NavItem {
  text: string
  img: ResourceStr
}

@Entry
@Component
struct MyThemeConfig {
  @StorageLink('topRectHeight') topRectHeight: number = 0
  // 中间导航区需要渲染的元素列表
  navList: NavItem[] = [
    {text: '个性主题', img: $r('app.media.my_theme_config_theme')},
    {text: '桌面图标', img: $r('app.media.my_theme_config_desktop')},
    {text: '启动页', img: $r('app.media.my_theme_config_welcome')},
  ]
  @State activeNavIndex: number = 0 // 标记当前激活的导航元素 [个性主题 / 桌面图标 / 启动页] 0 1 2
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  // 构建中间导航区TabBar元素
  @Builder
  tabBarBuilder(item: NavItem, index: number) {
    // 最外层包一层Column(用于设置左右间距), 然后设置左右padding
    // 如果不包这一层, 直接用第二层的Column的左右margin设置左右间距好像无效
    Column() {
      Column() {
        Image(item.img)
          .width(24)
          .aspectRatio(1)
          .fillColor(this.activeNavIndex == index ? Color.White : this.theme.mainColor)
          .margin({bottom: 8})
        Text(item.text)
          .lineHeight(20)
          .fontSize(12)
          .fontColor(this.activeNavIndex == index ? Color.White : '#978b83')
        // 选中的tab底部会有三角形的效果
        if (this.activeNavIndex == index) {
          // 边缘光滑版三角形
          // Path()
          //   .width(vp2px(18))
          //   .height(vp2px(6))
          //   .commands('M0 0 L' + vp2px(18) + ' 0 S' + vp2px(9) + ' ' + vp2px(6) + ' 0 0 Z')
          //   .fill('#ff6600')
          //   .stroke('#ff6600')
          //   .position({left: '50%', bottom: 0})
          //   .translate({x: -9, y: '100%'})

          // 正常边缘三角形
          Polygon({ width: 18, height: 6 })
            .points([[0, 0], [9, 6], [18, 0]])
            .fill(Color.Green)
            .fill(this.theme.mainColor)
            .position({left: '50%', bottom: 0})
            .translate({x: '-50%', y: '100%'})
        }
      }
      .padding({left: 24, right: 24, top: 12})
      .backgroundColor(this.activeNavIndex == index ? this.theme.mainColor : this.theme.secondColor)
      .borderRadius(8)
      .width(96)
      .height(78)
      .margin({bottom: 10})
    }
    .padding({
      left: index == 0 ? 20 : 0,
      right: index == this.navList.length - 1 ? 20 : 0
    })
  }

  build() {
    Column() {
      // 头部标题栏
      RelativeContainer() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24)
          .aspectRatio(1)
          .alignRules({
            center: {anchor: '__container__', align: VerticalAlign.Center},
            left: {anchor: '__container__', align: HorizontalAlign.Start}
          })
          .onClick(() => {
            router.back()
          })
        Text('主题')
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: {anchor: '__container__', align: VerticalAlign.Center},
            middle: {anchor: '__container__', align: HorizontalAlign.Center}
          })
      }
      .padding({left: 20, right: 20, top: 12, bottom: 12})
      .width('100%')
      .height(48)

      // 中间导航区
      Tabs({barPosition: BarPosition.Start}) {
       ForEach(this.navList, (item: NavItem, index) => {
         TabContent() {
            Column() {
              // 如果选中个性主题
              if (index == 0) {
                MyThemeConfigComp()
              }
              // 如果选中桌面图标
              else if (index == 1) {

              }
              // 如果选中启动页
              else {

              }
            }
            .padding({left: 20, right: 20, top: 24})
            .borderRadius({
              topLeft: 12,
              topRight: 12
            })
           .backgroundColor('#fff')
           .width('100%')
         }
         .tabBar(this.tabBarBuilder(item, index))
       })
      }
      // 处理点击tab切换逻辑
      .onTabBarClick((index) => {
        this.activeNavIndex = index
      })
      .scrollable(false)
      .width('100%')
      .barHeight(98)
      .backgroundColor('#f5f5f5')
    }
    .height('100%')
    .width('100%')
    .padding({top: this.topRectHeight})
    .backgroundColor('#f5f5f5')

  }
}
