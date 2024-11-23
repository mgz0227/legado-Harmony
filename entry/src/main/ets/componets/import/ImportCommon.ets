/**
 * @author Andy
 * @datetime 2024/7/3 19:56
 * @className: ImportCommon
 * 通用导入页
 */
import SideBar from '../common/SideBar';
import { showMessage } from '../common/promptShow';
import Score from '../common/Score';
import Tag from '../common/Tag';
import BookSourceDao from '../../database/dao/BookSourceDao';
import { BookSource, GroupList, SOURCE_GROUP_MAP } from '../../database/entities/BookSource';
import SourceGroup from '../ui/SourceGroup';
import text from '@ohos.graphics.text';
import { ThemeItem } from '../../common/model/Theme';
import { ThemeStorageKey } from '../../common/constants/Theme';

@Component
export default struct ImportCommon {
  @StorageProp('pathBookSource') pathBookSource: string = ''
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
  @StorageLink('refreshCount') refreshCount: number = 0
  @State isShowGroup: boolean = false
  @State groupName: string = ''
  @State groupIndex: number = 0
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
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
      if (item.bookSourceType >= 3){
        item.bookSourceType = 0 //SOURCE_GROUP_MAP中未有3的情况,会出现数组越界
      }
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

  getSourceGroupAll () {
    return Object.values(SOURCE_GROUP_MAP).flat()
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
              header: this.classifyHeader(`${item.title}`, ` (${item.list.length})` , index, item.list[0].bookSourceType || 0),
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
          .selectedColor(this.theme.mainColor)
          .onChange((val: boolean) => {
            this.fullActive = val
            this.sourceList.forEach((item: BookSource) => {
              this.insertMap[item.bookSourceUrl] = val
            })
          })

        Text() {
          Span('全选（')
          Span(Object.values(this.insertMap).filter(o => o).length + '')
            .fontColor(this.theme.mainColor)
          Span(`/${this.sourceList.length})`)
        }
        .margin({ left: 8 })
      }
      .width('100%')
      .height(40)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)

      Row() {
        Image($r('app.media.warning'))
          .width(20)
          .fillColor(this.theme.mainColor)

        Text('允许对书架中正在使用的书源进行更新')
          .fontSize(14)
          .fontColor('#EF4444')
          .padding({ left: 8 })

        Blank()

        Checkbox()
          .select(this.waringActive)
          .selectedColor(this.theme.mainColor)
          .onChange((val: boolean) => {
            this.waringActive = val
          })
      }
      .width('100%')
      .height(48)
      .padding({ left: 20, right: 20 })
      .backgroundColor(this.theme.secondColor)

      Row({ space: 20 }) {
        Button('取消')
          .height(40)
          .fontColor(this.theme.mainColor)
          .backgroundColor(this.theme.secondColor)
          .layoutWeight(1)
          .onClick(() => {
            this.show = false;
          })

        Button('确认')
          .height(40)
          .fontColor(Color.White)
          .backgroundColor(this.theme.mainColor)
          .layoutWeight(1)
          .onClick(async  () => {
            const insertBookSources = this.sourceList.filter(item => this.insertMap[item.bookSourceUrl] ?? false)
            await BookSourceDao.batchInsert(insertBookSources)
            this.show = false;
            this.resetState()
            showMessage('添加成功')
            this.refreshCount += 1
          })
      }
      .width('100%')
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })

      //分组
      Flex()
        .bindSheet($$this.isShowGroup, this.showCheckGroup(), {
          height: 320,
          dragBar: true,
          showClose: false,
          onDisappear: () => {
            this.isShowGroup = false
          }
        })
    }
    .padding({ top: 12, bottom: 12 })
    .backgroundColor(0xF5F5F5)
  }

  @Builder
  classifyHeader(title: string, num: string, index: number, groupIndex: number) {
    Row() {
      Text(title + num)
        .textAlign(TextAlign.Start)
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })

      Blank()

      if (!this.getSourceGroupAll().includes(title)) {
        Row() {
          Text(SOURCE_GROUP_MAP[groupIndex][0])
            .fontSize(14)
            .lineHeight(22)
            .fontColor(this.theme.mainColor)
          Image($r('app.media.f60_right'))
            .width(16)
        }
        .alignItems(VerticalAlign.Center)
        .padding({ right: 6 })
        .onClick(() => {
          this.groupName = title
          this.groupIndex = groupIndex
          this.isShowGroup = true
        })
      }

      CheckboxGroup({ group: 'checkboxGroup' + index })
        .checkboxShape(CheckBoxShape.CIRCLE)
        .selectedColor(this.theme.mainColor)
    }
    .alignItems(VerticalAlign.Center)
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
          .selectedColor(this.theme.mainColor)
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

  //移动分组
  @Builder
  showCheckGroup() {
    Flex() {
      SourceGroup({
        title: '导入至',
        groupList: SOURCE_GROUP_MAP[this.groupIndex],
        confirm: async (groupName) => {
          const sourceList = this.sourceList.map(item => {
            if (item.bookSourceGroup === this.groupName) {
              item.bookSourceGroup = groupName
            }
            return item
          })
          this.sourceList = sourceList
          this.getGroupList()
          this.isShowGroup = false
        },
        cancel: () => {
          this.isShowGroup = false
        }
      })
    }
  }
}

