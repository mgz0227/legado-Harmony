import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import ClassifyList from '../../../../componets/common/ClassifyList'
import { showMessage } from '../../../../componets/common/promptShow'
import Score from '../../../../componets/common/Score'
import Tag from '../../../../componets/common/Tag'
import { BookSource, GroupList } from '../../../../componets/dataList/BookSource'

@Component
export default struct SourceView {
  item: string = ''
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State currentIndex: number = 0
  @State activeNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State groupList: GroupList[] = []
  @State sourceList: BookSource[] = []
  @State searchValue: string = ''
  @State clickNameMap: Record<string, boolean> = {}
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()

  aboutToAppear() {
    axios
      .get('https://node.wisdoms.xin/static/file/20240704/sy.json')
      .then((res: AxiosResponse) => {
        this.sourceList = res.data;
        this.getGroupList()
      }).catch((error: AxiosError) => {
      console.error(error.message);
    })
  }

  getGroupList() {
    const groupMap: Record<string, GroupList> = {};
    this.sourceList.forEach((item: BookSource) => {
      const title = item.bookSourceGroup;
      // 如果groupMap中还没有这个group，则创建一个新的GroupList对象
      if (!groupMap[title]) {
        groupMap[title] = { title: title, list: [] };
      }
      // 向当前group的list中添加BookSource对象
      groupMap[title].list.push(item);
    })
    this.groupList = Object.values(groupMap);
  }

  scrollChangeAction(start: number, flg: Boolean) {
    if (this.currentIndex !== start) {
      this.currentIndex = start;
      if (!flg) {
        this.scroll.scrollToIndex(start);
      } else {
        this.secondScroll.scrollToIndex(start);
      }
    }
  }

  build() {
    Stack() {
      Column() {
        // 搜索框
        Column() {
          Search({
            value: this.searchValue,
            placeholder: `搜索${this.item}`,
            icon: "/common/images/search.svg"
          })
            .width("100%")
            .height(40)
            .backgroundColor(Color.White)
        }
        .padding({
          left: 20,
          right: 20,
          top: 8,
        })

        // 筛选器
        Row() {
          this.filterText('全部')

          Row().width(12)
          this.filterText('排序')

          Row().width(12)
          this.filterText('校验')

          Row().width(12)
          this.filterText('等级')

          Row().width(12)
          this.filterText('登录', false)
        }
        .padding({
          left: 20,
          right: 20,
          top: 12,
          bottom: 12
        })
        .width('100%')
        .height(50)

        // 内容主体
        Row({ space: 12 }) {
          ClassifyList({
            currentIndex: this.currentIndex,
            classifyList: this.groupList,
            scroller: this.scroll,
            clickAction: (index: number) => {
              this.scrollChangeAction(index, true)
            },
            isBadge: true
          })
            .width(88)

          List({ scroller: this.secondScroll }) {
            ForEach(this.groupList, (item: GroupList, index: number) => {
              ListItemGroup({
                header: this.classifyHeader(`${item.title} (${item.list.length})`, index),
                space: 0
              }) {
                ForEach(item.list, (bookSource: BookSource, j: number) => {
                  this.CourseItem(bookSource, index, j)
                })
              }
            })
          }
          .padding({ right: 20 })
          .sticky(StickyStyle.Header)
          .onScrollIndex((start) => {
            this.scrollChangeAction(start, false)
          })
          .layoutWeight(1)
        }
        .layoutWeight(1)
      }
      .height('100%')
    }
    .padding({ bottom: this.bottomRectHeight })
  }

  @Builder
  filterText(title: string, isIcon: boolean = true) {
    Row() {
      Text(title)
        .fontSize(12)

      if (isIcon) {
        Image($r('app.media.down_arrow'))
          .width(8)
          .margin({ left: 6 })
      }
    }
    .height(22)
    .padding({
      top: 2,
      bottom: 2,
      left: 4,
      right: 4
    })
    .layoutWeight(1)
    .backgroundColor(Color.White)
    .borderRadius(4)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  // 分类标题
  @Builder
  classifyHeader(title: string, index: number) {
    Row() {
      Text(title)
        .textAlign(TextAlign.Start)
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .maxLines(1)

      Text('长按批量管理')
        .fontSize(12)
        .fontWeight(400)
        .lineHeight(20)
        .padding({left: 8})

      Blank()
    }
    .width('100%')
    .padding({ right: 16 })
    .backgroundColor('#f5f5f5')
    .justifyContent(FlexAlign.Start)
  }

  // 每个分类的内容主体
  @Builder
  CourseItem(item: BookSource, i: number, j: number) {
    Column() {
      Row() {
        Text(item.bookSourceName)
          .fontSize(16)
          .lineHeight(24)
          .fontWeight(FontWeight.Medium)
          .textOverflow({
            overflow: TextOverflow.Ellipsis,
          })
          .maxLines(1)

        if (i === 0) {
          Tag({ text: '登录', color: '#188BFF', bgColor: '#1F188BFF' })
        }

        if (j * i % 2 === 0) {
          Tag({ text: '发现', color: '#FF6600', bgColor: '#1FFF6600' })
        }

        Blank()

        Image($r('app.media.more_vertical')).width(24).fillColor('#73000000')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Score({ score: j > 5 ? 5 : j, isBoutique: j >= 6 })
      }
      .width('100%')
      .margin({ top: 10 })
      .justifyContent(FlexAlign.Start)

      Row() {
        Text('2023-07-23 12:34:23')
          .fontSize(12)
          .lineHeight(20)
          .fontColor('rgba(0, 0, 0, 0.45)')
        Text('导入')
          .padding({ left: 4 })
          .fontSize(12)
          .lineHeight(20)
          .fontColor('rgba(0, 0, 0, 0.45)')
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.activeNameMap[item.bookSourceName] ?? false })
          .selectedColor(0xff6600)
          .onChange((val: boolean) => {
            this.activeNameMap[item.bookSourceName] = val
          })
      }
      .width('100%')
      .margin({ top: 3 })
      .justifyContent(FlexAlign.SpaceBetween)

      if (j === 1) {
        Row() {
          Text('搜索不到时可以尝试以下格式搜索 ##完整书名 每隔八小时访问一遍签到（搜索的时候访问） 登录注意事项： 1、如果app有重新登录过，就要重新抓token 2、每次重新登录，那么书籍就要更新目录，刷新正文')
            .fontSize(12)
            .fontColor('#73000000')
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
            .maxLines(this.clickNameMap[item.bookSourceName] ? 99 : 1)
            .layoutWeight(1)
            .animation({
              duration: 300
            })
            .onClick(() => {
              this.clickNameMap[item.bookSourceName] = !this.clickNameMap[item.bookSourceName]
            })

          Image($r('app.media.down_arrow'))
            .margin({ top: 4 })
            .width(8)
        }
        .margin({ top: 10 })
        .padding({
          left: 8,
          right: 8,
          top: 4,
          bottom: 4
        })
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor('rgba(0, 0, 0, 0.04)')
      }
    }
    .width('100%')
    .margin({
      bottom: 12
    })
    .borderRadius(12)
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .backgroundColor(Color.White)
  }
}