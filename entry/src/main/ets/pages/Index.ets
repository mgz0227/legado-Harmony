@Entry
@Component
struct Main {
  @State message: string = '这是应用主界面'
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
        Text('我的')
      }
      .tabBar(this.TabBarBuilder('首页', $r('app.media.icon'), TabId.HOME))

      TabContent() {
        Text('我的')
      }
      .tabBar(this.TabBarBuilder('明细', $r('app.media.icon'), TabId.FIND))

      TabContent() {
        Text('我的')
      }
      .tabBar(this.TabBarBuilder('统计', $r('app.media.icon'), TabId.SUB))

      TabContent() {
        Text('我的')
      }
      .tabBar(this.TabBarBuilder('我的', $r('app.media.icon'), TabId.MINE))

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