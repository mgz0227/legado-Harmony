@Entry
@Component
struct Main {

  @State currentIndex: number = 0

  @Builder TabBarBuilder(title: ResourceStr, image: ResourceStr, index: number) {
    Column({ space: 8 }) {
      Image(image)
        .width(22)
        .fillColor(this.selectColor(index))
      Text(title)
        .fontSize(14)
        .fontColor(this.selectColor(index))
    }
  }

  selectColor(index: number) {
    return this.currentIndex === index ? Color.Black : Color.Gray
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {

      TabContent() {
        Text('书架')
      }
      .tabBar(this.TabBarBuilder('书架', $r('app.media.HOME_line'), TabId.HOME))

      TabContent() {
        Text('发现')
      }
      .tabBar(this.TabBarBuilder('发现', $r('app.media.FIND_line'), TabId.FIND))

      TabContent() {
        Text('订阅源')
      }
      .tabBar(this.TabBarBuilder('订阅源', $r('app.media.SUB_line'), TabId.SUB))

      TabContent() {
        Text('我的')
      }
      .tabBar(this.TabBarBuilder('我的', $r('app.media.MINE_line'), TabId.MINE))

    }
    .width('100%')
    .height('100%')
    .onChange(index => this.currentIndex = index)
  }
}

export enum TabId {
  HOME,
  FIND,
  SUB,
  MINE
}