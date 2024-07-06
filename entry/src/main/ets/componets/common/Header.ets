/**
 * @author Andy
 * @datetime 2024/7/6 01:36
 * @className: Header
 * 公共头部组件，默认使用返回按钮，标题，右侧下拉框的等公共能力
 * 自定义左侧/中间/右侧的内容，内部已设置顶部安全区
 * 右侧的下拉菜单的图标可通过rightIcon传入更改
 * 设置自定义区域后，相应的默认区域失效
 */
import { router } from '@kit.ArkUI'
import { IconTitleVo } from '../../componetsmodel/IconTitleVo'
import dialogTitleFuction from './dialogTitleFuction'

@Component
export default struct Header {
  @Builder leftBuilder() {}
  // 自定义左侧区域
  @BuilderParam customLeftBuilder: () => void = this.leftBuilder
  @Builder titleBuilder() {}
  // 自定义中间区域
  @BuilderParam customTitleBuilder: () => void = this.titleBuilder
  @Builder rightBuilder() {}
  // 自定义右侧区域
  @BuilderParam customRightBuilder: () => void = this.rightBuilder
  @StorageLink('topRectHeight') topRectHeight: number = 0

  paddingTop: number = 0
  @Prop title: string = ''
  dialogRightData: IconTitleVo[] | string[] = []
  dialogRightChange: Function = (_index: number) => {}
  @State showFunction: boolean = false
  flexAlign?: FlexAlign = FlexAlign.SpaceBetween
  // 右侧按钮图标
  rightIcon?: PixelMap | ResourceStr | DrawableDescriptor

  build() {
    Column() {
      // 顶部固定内容
      Row() {
        if (this.customLeftBuilder !== this.leftBuilder) {
          this.customLeftBuilder()
        } else {
          Column() {
            Image($r("app.media.return_left"))
              .size({ width: 24, height: 24 })
              .interpolation(ImageInterpolation.Medium)
              .onClick(() => {
                router.back()
              })
          }
          .alignItems(HorizontalAlign.Start)
        }

        if (this.customTitleBuilder !== this.titleBuilder) {
          this.customTitleBuilder()
        } else {
          Column() {
            Text(this.title)
              .lineHeight(24)
              .font({
                size: 16,
                weight: 500,
                style: FontStyle.Normal,
              })
          }
        }

        if (this.customRightBuilder !== this.rightBuilder) {
          this.customRightBuilder()
        }

        if (this.dialogRightData.length) {
          Image(this.rightIcon ? this.rightIcon : $r('app.media.addSubscription')).width(24)
            .bindMenu(
              this.showFunction,
              this.dialogRightFuction(),
              {
                onDisappear: () => {
                  this.showFunction = false
                }
              })
            .onClick(() => {
              this.showFunction = true
            })
        } else {
          if (this.customRightBuilder === this.rightBuilder && !this.dialogRightData.length) {
            Row()
              .size({ width: 24 })
          }
        }
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(this.flexAlign)
      .padding({
        left: 12,
        right: 20,
        top: 9,
        bottom: 9
      })
      .height(50)
      .width("100%")
    }
    .padding({
      top: this.topRectHeight + this.paddingTop
    })
  }

  @Builder
  dialogRightFuction() {
    Column() {
      ForEach(this.dialogRightData, (item: IconTitleVo | string, index) => {
        dialogTitleFuction({
          title: typeof item === 'string' ? item : item.title,
          icon: typeof item === 'string' ? undefined : item.icon,
          isBorder: this.dialogRightData.length !== index + 1
        })
          .onClick(() => {
            this.dialogRightChange(index)
          })
      })
    }
  }
}