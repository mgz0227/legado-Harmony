import { ExploreItem } from '../../../../database/types/BookSourceType'
import { router } from '@kit.ArkUI'
import { BookSource } from '../../../../database/entities/BookSource'

export interface GroupExploreList {
  title: string,
  url: string,
  columnsTemplate: string
  list: ExploreItem[]
}

@Component
export default struct AllCategory {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Prop list: GroupExploreList[] = []
  @Link showSheet: boolean
  @Prop bookSource?: BookSource

  build() {
    Column() {
      Column() {
        ForEach(this.list, (item: GroupExploreList) => {
          Column() {
            if (item.title !== 'null') {
              Row() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(700)
              }
              .justifyContent(FlexAlign.Start)
              .margin({ top: 24, })
            }

            Grid() {
              ForEach(item.list, (item: ExploreItem) => {
                GridItem() {
                  this.buttonItem(item)
                }
              })
            }
            .columnsTemplate(item.columnsTemplate)
            .columnsGap(12)
            .rowsGap(12)
            .padding({ top: 12 })
          }
          .padding({ left: 20, right: 20 })
          .alignItems(HorizontalAlign.Start)
        })
      }
      .padding({ bottom: 12 })


      Column() {
        Button() {
          Text('取消')
            .fontColor('#73000000')
            .height(24)
            .lineHeight(24)
        }
        .width('100%')
        .borderRadius(24)
        .backgroundColor('#0A000000')
        .padding({
          top: 8,
          bottom: 8
        })
        .onClick(() => {
          this.showSheet = false
        })
      }
      .border({
        width: { top: 1 },
        color: '#0f000000',
        style: BorderStyle.Solid
      })
      .padding({
        top: 12,
        bottom: 12,
        left: 20,
        right: 20
      })
    }
    .padding({ bottom: this.bottomRectHeight + 30 })
  }

  @Builder
  buttonItem(item: ExploreItem) {
    Column() {
      Text(item.title)
        .fontSize(14)
        .textAlign(TextAlign.Center)
        .fontWeight(400)
        .width('100%')
        .height(20)
        .lineHeight(20)
        .fontColor('#73000000')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: 6,
      bottom: 6
    })
    .backgroundColor('#0F000000')
    .borderRadius(4)
    .onClick(() => {
      if (!item.url || !this.bookSource) {
        return
      }
      router.pushUrl({
        url: 'pages/view/Find/CategoryList/Index',
        params: {
          bookSource: this.bookSource,
          exploreItem: item
        }
      })
    })
  }
}