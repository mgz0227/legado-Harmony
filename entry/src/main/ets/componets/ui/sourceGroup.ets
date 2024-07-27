/**
 * @author andy
 * @datetime 2024/7/27 01:02
 * @className: BookSourceGroup
 * 通用分组选择弹窗
 */
import CommonConstants from '../../common/constants/CommonConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'

@Component
export default struct SourceGroup {
  @Prop groupList: string[] = []
  @Prop currentName: string
  title: string = '移动至'
  confirm: (groupName: string) => void = (_groupName) => {
  }
  cancel: () => void = () => {
  }

  build() {
    Column() {
      Column() {
        Text(this.title)
          .fontSize(16)
          .fontWeight(700)
          .lineHeight(24)
      }
      .padding({
        right: 20,
        left: 20,
        top: 12,
        bottom: 12
      })

      Divider()
      Scroll() {
        Grid() {
          ForEach(this.groupList, (item: string, index: number) => {
            GridItem() {
              this.titleBuilder(item)
            }
            .onClick(() => {
              this.confirm(item)
            })
          })
        }
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(16)
        .rowsGap(16)
      }
      .padding(PaddingConstants.PADDING_20)
      .align(Alignment.Top)
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      Column() {
        Divider().strokeWidth(0.5)

        Button('取消')
          .padding({
            left: 32,
            right: 32,
            top: 8,
            bottom: 8
          })
          .width('100%')
          .height(56)
          .type(ButtonType.Normal)
          .stateEffect(false)
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .fontColor('#E0000000')
          .onClick(() => {
            this.cancel()
          })
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder
  titleBuilder(title: string) {
    Column() {
      Text(title)
        .fontSize(14)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .lineHeight(20)
        .maxLines(1)
    }
    .width(96)
    .borderRadius(4)
    .backgroundColor($r('app.string.color_black_6'))
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 8
    })
  }
}