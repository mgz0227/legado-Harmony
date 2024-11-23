import { ThemeColor, ThemeStorageKey } from '../../../common/constants/Theme'
import { ThemeItem } from '../../../common/model/Theme'
import { promptAction, PromptAction, router } from '@kit.ArkUI'
import { themeManager } from '../../../common/utils/ThemeManager'
import { JSON } from '@kit.ArkTS'

// 个性主题组件模块
@Component
export struct MyThemeConfigComp {
  @StorageProp(ThemeStorageKey.THEMEINDEX)
  activeIndex: number = 0 // 被选中的主题
  @State longPressGestureIndex: number = 0 // 长按选中主题

  @StorageProp(ThemeStorageKey.THEMELIST)
  themeList: ThemeItem[] = []

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  dialog: CustomDialogController = new CustomDialogController({
    builder: this.dialogBuilder,
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: false
  })

  // 构建自定义弹窗
  @Builder
  dialogBuilder() {
    Column({space: 24}) {
      Text('确定要删除吗？')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)

      Row({space: 12}) {
        Button('取消')
          .fontSize(14)
          .fontColor(this.theme.mainColor)
          .backgroundColor(this.theme.secondColor)
          .onClick(() => {
            this.dialog.close()
          })
          .width(112)
          .height(38)
        Button('确定')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(this.theme.mainColor)
          .onClick(() => {
            if (this.themeList.length > 1) {
              themeManager.deleteTheme(this.longPressGestureIndex)
            } else {
              promptAction.showToast({message: "删除失败，至少需要保留一个主题"})
            }
            this.dialog.close()
          })
          .width(112)
          .height(38)
      }
      .justifyContent(FlexAlign.Center)

    }
    .padding(24)
    .width(284)
    .height(136)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
    .borderRadius(32)
  }

  // 构建个性主题下列表元素
  @Builder
  themeItemBuilder(item: ThemeItem, index: number) {
    Column({space: 8}) {
      Column() {
        if (this.activeIndex == index) {
          Text('使用中')
            .fontSize(9)
            .fontColor('#fff')
            .backgroundColor('#ef4444')
            .textAlign(TextAlign.Center)
            .lineHeight(14)
            .width(39)
            .height(14)
            .borderRadius({
              topRight: 8,
              bottomLeft: 8
            })
            .position({right: 0, top: 0})
        }
      }
      .width(154)
      .height(77)
      .borderRadius(8)
      .backgroundColor(item.mainColor)

      Text(item.text)
        .fontSize(14)
        .height(22)
        .lineHeight(22)
        .width('100%')
    }
    .width(154)
    .height(107)
  }

  build() {
    Column() {
      Grid() {
        // 自定义主题
        GridItem() {
          Column({space: 8}) {
            Column() {
              Image($r('app.media.my_theme_config_custom'))
                .width(24)
                .aspectRatio(1)
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width(154)
            .height(77)
            .borderRadius(8)
            .backgroundColor('#f5f5f5')
            .onClick(() => {
              router.pushUrl({
                url: '/pages/view/myCenter/CreateCustomTheme'.slice(1)
              })
            })

            Text('自定义主题')
              .fontSize(14)
              .height(22)
              .lineHeight(22)
              .width('100%')
          }
          .width(154)
          .height(107)
        }
        ForEach(this.themeList, (item: ThemeItem, index) => {
          GridItem() {
            this.themeItemBuilder(item, index)
          }
          .onClick(() => {
            this.activeIndex = index
            themeManager.setTheme(this.themeList[index], index)
          })
          .gesture(
            LongPressGesture()
              .onAction(() => {
                this.dialog.open()
                this.longPressGestureIndex = index
              })
          )
        })
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(12)
      .rowsGap(12)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}