/**
 * @author Andy
 * @datetime 2024/7/6 01:06
 * @className: SideBar
 * 分类左侧列表，支持是否开启角标，支持是否开启拖拽
 */
import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'
import { GroupList, GroupPartList } from '../../database/entities/BookSource'

@Component
export default struct SideBar {
  @Link currentIndex: number
  @Prop sideBarList: GroupList[] | GroupPartList[] | string[]
  @Prop isBadge: boolean = false
  @Prop isDrag: boolean = false
  clickAction: Function = (_index: number) => {
  }
  scroller?: Scroller = undefined
  onDragChange: (list: GroupList[] | GroupPartList[] | string[]) => void = (_list) => {}

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  // 交换listArr数组中listItem的位置
  changeListItemIndex(index1: number, index2: number) {
    let tempItem = this.sideBarList[index1];
    this.sideBarList[index1] = this.sideBarList[index2];
    this.sideBarList[index2] = tempItem;
    this.onDragChange(this.sideBarList)
  }

  build() {
    List({ scroller: this.scroller }) {
      ForEach(this.sideBarList, (item: GroupList | string, index: number) => {
        ListItem() {
          Stack({ alignContent: Alignment.TopStart }) {
            this.ItemBuilder(item, index)

            if (this.currentIndex === index) {
              Row()
                .width(3)
                .height(16)
                .backgroundColor(this.theme.mainColor)
                .borderRadius(12)
                .position({
                  top: 16
                })
            }
          }
        }
        .height(48)
      })
    }
    .height('100%')
    .width('100%')
    .scrollBar(BarState.Off)
    .lanes({ minLength: 48, maxLength: 88 })
    .borderRadius({
      topRight: 12,
      bottomRight: 12
    })
    .onItemDragStart((event: ItemDragInfo, index: number) => {
      console.info('TagInfo index:', index)
      if (!this.isDrag) {
        return;
      }
      const item = this.sideBarList[index] as GroupList;
      return this.ItemBuilder(item, index, 88);
    })
    .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
      if (!this.isDrag) return;
      if (!isSuccess || insertIndex >= this.sideBarList.length) {
        return;
      }
      this.changeListItemIndex(itemIndex, insertIndex);
    })
  }

  @Builder
  ItemBuilder(item: GroupList | string, index: number, width: number | string = '100%') {
    Row() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Text(typeof item === 'string' ? item : item.title)
          .height(48)
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

      if (this.isDrag) {
        Column() {
          Image($r('app.media.drag'))
            .width(32)
            .width(24)
            .draggable(false)
        }
        .padding(5)
        .margin({ right: -10 })
      }
    }
    .width(width)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(this.currentIndex === index ? 0xF5F5F5 : Color.White)
    .borderRadius({
      topRight: this.currentIndex + 1 === index ? 12 : 0,
      bottomRight: this.currentIndex - 1 === index || this.sideBarList.length === index + 1 ? 12 : 0
    })
    .animation({
      duration: 100,
      curve: Curve.Linear
    })
    .onClick(() => {
      this.clickAction(index)
    })
  }
}