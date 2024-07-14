/**
 * @author 2008
 * @datetime 2024/7/14 00:46
 * @className: SubscriptionImport
 * 订阅源导入页面
 */
import SideBar from '../common/SideBar';
import { showMessage } from '../common/promptShow';
import Score from '../common/Score';
import Tag from '../common/Tag';
import BookSourceDao from '../../database/dao/BookSourceDao';
import { BookSource, GroupList } from '../../database/entities/BookSource';

@Component
export default struct SubscriptionImport {

  @State localSourceList: BookSource[] = []
  @Prop sourceList: BookSource[] = []
  @Link show: boolean;
  @State groupList: GroupList[] = []
  @State currentIndex: number = 0
  @State insertMap: Record<string, boolean> = {}
  @State alreadyNameMap: Record<string, boolean> = {}
  @State updateNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State waringActive: boolean = false
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()

  aboutToAppear() {
    BookSourceDao.search().then(data => {
      const bookSource = data ?? []
      this.localSourceList = bookSource
      this.getGroupList()
    }).catch(() => {
      this.getGroupList()
    })
  }

  getGroupList() {
    const groupMap: Record<string, GroupList> = {};
    this.sourceList.forEach((item: BookSource) => {
      const title = item.bookSourceGroup;
      const bookSourceName = item.bookSourceName;
      if (title) {
        // 如果groupMap中还没有这个group，则创建一个新的GroupList对象
        if (!groupMap[title]) {
          groupMap[title] = { title: title, list: [] };
        }
        // 向当前group的list中添加BookSource对象
        groupMap[title].list.push(item);
      }
      for (let i = 0; i < this.localSourceList.length; i++) {
        const localItem = this.localSourceList[i];
        if (localItem.bookSourceUrl === item.bookSourceUrl) {
          this.alreadyNameMap[item.bookSourceUrl] = true
          if (
            localItem.bookSourceName !== item.bookSourceName ||
            localItem.searchUrl !== item.searchUrl ||
            localItem.ruleSearch?.bookList !== item.ruleSearch?.bookList ||
            localItem.ruleContent?.content !== item.ruleContent?.content
          ) {
            this.insertMap[item.bookSourceUrl] = true
            this.updateNameMap[item.bookSourceUrl] = true
          }
          break;
        }
      }
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

  resetState() {
    this.sourceList = []
    this.groupList = []
    this.currentIndex = 0
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        SideBar({
          currentIndex: this.currentIndex,
          sideBarList: this.groupList.map(o => o.title),
          scroller: this.scroll,
          clickAction: (index: number) => {
            this.scrollChangeAction(index, true)
          }
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

      Row() {
        Checkbox()
          .select(this.fullActive)
          .selectedColor(0xff6600)
          .onChange((val: boolean) => {
            this.fullActive = val
            this.sourceList.forEach((item: BookSource) => {
              this.insertMap[item.bookSourceUrl] = val
            })
          })

        Text() {
          Span('全选（')
          Span(Object.values(this.insertMap).filter(o => o).length + '')
            .fontColor(0xff6600)
          Span(`/${this.sourceList.length})`)
        }
        .margin({ left: 8 })
      }
      .width('100%')
      .height(40)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)


      Row({ space: 20 }) {
        Button('取消')
          .height(40)
          .fontColor(0xff6600)
          .backgroundColor('rgba(255, 102, 0, 0.12)')
          .layoutWeight(1)
          .onClick(() => {
            this.show = false;
          })

        Button('确认')
          .height(40)
          .fontColor(Color.White)
          .backgroundColor(0xff6600)
          .layoutWeight(1)
          .onClick(async  () => {
            const insertBookSources = this.sourceList.filter(item => this.insertMap[item.bookSourceUrl] ?? false)
            await BookSourceDao.batchInsert(insertBookSources)
            this.show = false;
            this.resetState()
            showMessage('添加成功')
          })
      }
      .width('100%')
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
    }
    .padding({ top: 12, bottom: 12 })
    .backgroundColor(0xF5F5F5)
  }

  @Builder
  classifyHeader(title: string, index: number) {
    Row() {
      Text(title)
        .textAlign(TextAlign.Start)
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      CheckboxGroup({ group: 'checkboxGroup' + index })
        .checkboxShape(CheckBoxShape.CIRCLE)
        .selectedColor(0xff6600)
    }
    .padding({ right: 16 })
    .backgroundColor('#f5f5f5')
  }

  @Builder
  CourseItem(item: BookSource, i: number, j: number) {
    Column() {
      Row() {
        Text(item.bookSourceName)
          .fontSize(16)
          .lineHeight(24)
          .fontWeight(FontWeight.Medium)

        if (i % 2 === 0) {
          Tag({ text: '正在使用', color: '#24B277', bgColor: '#1F24B277' })
        }

        Blank()

        Checkbox({ name: 'checkbox' + j, group: 'checkboxGroup' + i })
          .select(this.insertMap[item.bookSourceUrl] ?? false)
          .selectedColor(0xff6600)
          .onChange((val: boolean) => {
            this.insertMap[item.bookSourceUrl] = val
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Blank()

      Row() {
        Score({ grade: item.bookSourceGrade, score: item.bookSourceScore })

        Text(this.updateNameMap[item.bookSourceUrl] ?? false ?
          '更新' : (this.alreadyNameMap[item.bookSourceUrl] ?? false ? '已有' : '新增'))
          .fontSize(12)
          .fontColor('rgba(0, 0, 0, 0.45)')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100vp')
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

