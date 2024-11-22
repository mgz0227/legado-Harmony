import { componentSnapshot, promptAction, router } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import { emitter } from '@kit.BasicServicesKit'
import { ThemeColor, ThemeStorageKey } from '../../../common/constants/Theme'
import { ThemeColorItem, ThemeItem } from '../../../common/model/Theme'
import { themeManager } from '../../../common/utils/ThemeManager'
import { sleep } from '../../../common/utils/utils'

@Entry
@Component
struct CreateCustomTheme {
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  // 颜色列表
  colorList: ThemeColorItem[] = [
    ThemeColor.RED,
    ThemeColor.ORANGE,
    ThemeColor.BLUE,
    ThemeColor.GREEN,
    ThemeColor.YELLOW,
  ]
  @StorageProp('screen_shot') previewIndexPage: PixelMap = {} as PixelMap
  @State activeIndex: number = 0
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  originTheme: ThemeItem = {} as ThemeItem
  selectTheme: ThemeItem = {} as ThemeItem
  @State themeName: string = '新建主题'

  aboutToAppear(): void {
    this.originTheme = this.theme // 暂存原主题配置信息
    this.selectTheme = this.theme
  }

  aboutToDisappear() {
    themeManager.setTheme(this.originTheme, AppStorage.get(ThemeStorageKey.THEMEINDEX) as number)
  }

  build() {
    Column() {
      // 头部标题栏
      RelativeContainer() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24)
          .aspectRatio(1)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .onClick(() => {
            themeManager.setTheme(this.originTheme, AppStorage.get(ThemeStorageKey.THEMEINDEX) as number)
            router.back()
          })
        Row({space: 8}) {
          TextInput({text: $$this.themeName})
            .height(24)
            .lineHeight(24)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .onSubmit(() => {
              this.selectTheme.text = this.themeName
            })
            .padding(0)
            .width(75)
            .backgroundColor(Color.Transparent)
          Image($r('app.media.writing'))
            .width(16)
            .aspectRatio(1)
            .fillColor(Color.Black)
        }
        .layoutWeight(1)
        .alignItems(VerticalAlign.Center)
        .height(24)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

        Text('保存')
          .fontSize(14)
          .height(22)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .onClick(() => {
            themeManager.setTheme(this.originTheme, AppStorage.get(ThemeStorageKey.THEMEINDEX) as number)
            this.selectTheme.text = this.themeName
            themeManager.addTheme(this.selectTheme)
            router.back()
          })

      }
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
      .width('100%')
      .height(48)
      .backgroundColor('#fff')

      // 截图区
      Column() {
        Image(this.previewIndexPage)
          .width(240)
          .backgroundColor('#ffdfca')
          .objectFit(ImageFit.Cover)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({left: 60, right: 60, top: 72, bottom: 88})
      .backgroundColor('#f5f5f5')

      // 底部选色区
      Row({space: 12}) {
        Row() {
          Image($r('app.media.my_theme_config_custom'))
            .width(16)
            .aspectRatio(1)
            .fillColor('#858585')
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .width(40)
        .aspectRatio(1)
        .borderRadius(20)
        .backgroundColor('#f0f0f0')

        Column() {

        }
        .height(40)
        .width(1)
        .backgroundColor('#f0f0f0')

        Scroll() {
          Row({space: 12}) {
            ForEach(this.colorList, (item: ThemeItem, index) => {
              Row() {

              }
              .width(40)
              .aspectRatio(1)
              .borderRadius(20)
              .backgroundColor(item.mainColor)
              .onClick(async () => {
                let count = 10
                while (count--) {
                  themeManager.setTheme(item, AppStorage.get(ThemeStorageKey.THEMEINDEX) as number)
                  this.selectTheme = item
                  emitter.emit('screen_shot'); // 触发首页截图
                  this.previewIndexPage = AppStorage.get('screen_shot') as PixelMap
                  await sleep(100)
                }
              })
            })
          }
          .height('100%')
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .height('100%')
      }
      .height(72)
      .width('100%')
      .backgroundColor('#fff')
      .padding({left: 20, right: 20, top: 16, bottom: 16})

    }
    .width('100%')
    .height('100%')
    .padding({top: this.topRectHeight, bottom: this.bottomRectHeight})
    .backgroundColor('#fff')
  }
}