import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import ClassifyList from '../../../../componets/common/ClassifyList'
import Header from '../../../../componets/common/Header'
import { showMessage } from '../../../../componets/common/promptShow'
import Score from '../../../../componets/common/Score'
import Tag from '../../../../componets/common/Tag'
import { BookSource, GroupList } from '../../../../componets/dataList/BookSource'

@Component
export default struct SourceView {
  item: string = ''
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State currentIndex: number = 0
  @State activeNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State groupList: GroupList[] = []
  @State sourceList: BookSource[] = []
  @State searchValue: string = ''
  @State clickNameMap: Record<string, boolean> = {}
  @State selectNameMap: Record<string, boolean> = {}
  @Link isBatch: boolean
  @State longCount: number = 0
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

  aboutToDisappear(): void {
    this.searchValue = ''
  }

  getGroupList() {
    const groupMap: Record<string, GroupList> = {};
    this.sourceList.forEach((item: BookSource) => {
      const title = item.bookSourceGroup;
      const bookSourceName = item.bookSourceName;
      if (bookSourceName.indexOf(this.searchValue) === -1) {
        return
      }
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
      // 头部区域
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
            .onChange((value: string) => {
              this.searchValue = value
              this.getGroupList()
            })
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
      }
      .backgroundColor('#f5f5f5')
      .height(122)
      .translate({y: !this.isBatch ? 0 : -122 - this.topRectHeight})
      .zIndex(99)
      .animation({
        duration: 700
      })
      // 批量操作头部内容
      Header({
        customLeftBuilder: () => {
          this.selectAll()
        },
        title: `已选${Object.values(this.activeNameMap).filter(o => o).length}项`,
        customRightBuilder: () => {
          this.complete()
        }
      })
        .backgroundColor('#f5f5f5')
        .translate({y: this.isBatch ? 0 : -50 - this.topRectHeight})
        .zIndex(99)
        .animation({
          duration: this.isBatch ?  300 : 0,
          delay: this.isBatch ?  300 : 0
        })

      Column() {
        // 内容主体
        Row({ space: 12 }) {
          ClassifyList({
            currentIndex: this.currentIndex,
            classifyList: this.groupList,
            scroller: this.scroll,
            clickAction: (index: number) => {
              this.scrollChangeAction(index, true)
            },
            isBadge: !this.isBatch
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
        .animation({
          duration: 300
        })
      }
      .height('100%')
      .padding({
        top: this.isBatch ? 50 + this.topRectHeight : 122,
        bottom: this.isBatch ? 68 + this.bottomRectHeight : this.bottomRectHeight
      })

      Row() {
        Row() {
          Column() {
            Image($r('app.media.verify'))
              .width(24)
              .margin({bottom: 4})
            Text('校验')
              .fontSize(12)
          }
          .layoutWeight(1)

          Row().width(12)
          Column() {
            Toggle({ type: ToggleType.Switch, isOn: true })
              .selectedColor(0xff6600)
              .margin({bottom: 4})
              .onChange((val: boolean) => {
                console.log(val + '')
              })

            Text('禁用')
              .fontSize(12)
          }
          .layoutWeight(1)

          Row().width(12)
          Column() {
            Image($r('app.media.export_1'))
              .width(24)
              .margin({bottom: 4})
            Text('导出')
              .fontSize(12)
          }
          .layoutWeight(1)

          Row().width(12)
          Column() {
            Image($r('app.media.delete'))
              .width(24)
              .margin({bottom: 4})
            Text('删除')
              .fontSize(12)
          }
          .layoutWeight(1)

          Row().width(12)
          Column() {
            Image($r('app.media.more'))
              .width(24)
              .margin({bottom: 4})
            Text('更多')
              .fontSize(12)
          }
          .layoutWeight(1)
        }
        .padding({
          left: 20,
          right: 20,
        })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(68)
      }
      .backgroundColor(Color.White)
      .position({bottom: 0})
      .zIndex(99)
      .translate({y: this.isBatch ? 0 : 68 + this.bottomRectHeight})
      .animation({
        duration: 500
      })
      .padding({ bottom: this.bottomRectHeight })
    }
    .alignContent(Alignment.Top)
  }

  @Builder selectAll () {
    Column() {
      Text('全选')
    }
    .onClick(() => {
      this.sourceList.forEach((item: BookSource) => {
        this.activeNameMap[item.bookSourceName] = true
      })
    })
  }

  @Builder complete () {
    Column() {
      Text('完成')
    }
    .onClick(() => {
      this.isBatch = false
      this.activeNameMap = {}
    })
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

      if (this.isBatch) {
        Blank()
        CheckboxGroup({ group: 'checkboxGroup' + index })
          .checkboxShape(CheckBoxShape.CIRCLE)
          .selectedColor(0xff6600)
      } else {
        Text('长按批量管理')
          .fontSize(12)
          .fontWeight(400)
          .lineHeight(20)
          .padding({left: 8})
          .gesture(
            LongPressGesture({ repeat: true, duration: 100 })
              .onAction((event: GestureEvent) => {
                if (event && event.repeat) {
                  if (this.longCount>= 4) {
                    this.isBatch = true
                  }
                  this.longCount++
                }
              })
              .onActionEnd(() => {
                this.longCount = 0
              })
          )
        Blank()
      }
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

        if (this.isBatch) {
          Checkbox({ name: 'checkbox' + j, group: 'checkboxGroup' + i })
            .select(this.activeNameMap[item.bookSourceName] ?? false)
            .selectedColor(0xff6600)
            .onChange((val: boolean) => {
              this.activeNameMap[item.bookSourceName] = val
            })
        } else {
          Image($r('app.media.more_vertical')).width(24).fillColor('#73000000')
        }
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
        Toggle({ type: ToggleType.Switch, isOn: this.selectNameMap[item.bookSourceName] ?? false })
          .selectedColor(0xff6600)
          .onChange((val: boolean) => {
            this.selectNameMap[item.bookSourceName] = val
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