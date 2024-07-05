/**
 * @author Andy
 * @datetime 2024/7/6 01:06
 * @className: ClassifyList
 * 分类左侧列表，支持是否开启角标
 */
import { GroupList } from '../dataList/BookSource'

@Component
export default struct ClassifyList {
  @Link currentIndex: number
  @Prop classifyList: GroupList[] | string[] = []
  @Prop isBadge: boolean = false
  clickAction: Function = (_index: number) => {}
  scroller?: Scroller = undefined

  build() {
    List({ scroller: this.scroller }) {
      ForEach(this.classifyList, (item: GroupList | string, index: number) => {
        ListItem() {
          Stack({ alignContent: Alignment.TopStart }) {
            Column() {
              Stack({ alignContent: Alignment.TopEnd }) {
                Text(typeof item === 'string' ? item : item.title)
                  .height('48vp')
                  .textAlign(TextAlign.Center)
                  .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)

                if (this.isBadge && typeof item !== 'string') {
                  Column() {
                    Text(item.list.length.toString())
                      .fontSize(10)
                      .fontWeight(500)
                      .fontColor(Color.White)
                      .textAlign(TextAlign.Center)
                  }
                  .height(16)
                  .position({
                    right: -10
                  })
                  .justifyContent(FlexAlign.Center)
                  .padding({ left: 4, right: 4 })
                  .borderRadius(20)
                  .backgroundColor(0xEF4444)
                }
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(this.currentIndex === index ? 0xF5F5F5 : Color.White)
            .borderRadius({
              topRight: this.currentIndex + 1 === index ? 12 : 0,
              bottomRight: this.currentIndex - 1 === index || this.classifyList.length === index + 1 ? 12 : 0
            })
            .animation({
              duration: 100,
              curve: Curve.Linear
            })
            .onClick(() => {
              this.clickAction(index)
            })

            if (this.currentIndex === index) {
              Row()
                .width(3)
                .height(16)
                .backgroundColor('#FF6600')
                .borderRadius(12)
                .position({
                  top: 16
                })
            }
          }
        }
      })
    }
    .height('100%')
    .width('100%')
    .scrollBar(BarState.Off)
    .borderRadius({
      topRight: 12,
      bottomRight: 12
    })
  }
}