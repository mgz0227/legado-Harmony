import { router } from '@kit.ArkUI'
import { IconTitleVo } from '../../componetsmodel/IconTitleVo'
import dialogTitleFuction from './dialogTitleFuction'

@Component
export default struct Header {
  @Builder
  titleBuilder() {
  }

  @BuilderParam customTitleBuilder: () => void = this.titleBuilder
  @StorageLink('topRectHeight') topRectHeight: number = 0
  title: string = ''
  dialogRightData: IconTitleVo[] = []
  dialogRightChange: Function = (_index: number) => {
  }
  @State showFunction: boolean = false

  build() {
    Column() {
      // 顶部固定内容
      Row() {
        Column() {
          Image($r("app.media.return_left"))
            .size({ width: 24, height: 24 })
            .interpolation(ImageInterpolation.Medium)
            .onClick(() => {
              router.back()
            })
        }
        .alignItems(HorizontalAlign.Start)


        if (this.title) {
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
        if (this.customTitleBuilder) {
          this.customTitleBuilder()
        }

        if (this.dialogRightData.length) {
          Image($r('app.media.addSubscription')).width(24)
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
          Row()
            .size({ width: 24, height: 24 })
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
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
      top: this.topRectHeight
    })
  }

  @Builder
  dialogRightFuction() {
    Column() {
      ForEach(this.dialogRightData, (item: IconTitleVo, index) => {
        dialogTitleFuction({
          title: item.title,
          icon: item.icon,
        })
          .onClick(() => {
            this.dialogRightChange(index)
          })
      })
    }
  }
}