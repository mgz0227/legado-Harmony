/**
 * @author Andy
 * @datetime 2024/7/3 19:56
 * @className: ImportCommon
 * 通用导入页
 */
import { FileHandler } from '../../common/utils/FileHandler';
import ClassifyList from '../common/ClassifyList';
import { showMessage } from '../common/promptShow';
import Score from '../common/Score';
import Tag from '../common/Tag';
import { BookSource, GroupList } from '../dataList/BookSource';
import { JSON } from '@kit.ArkTS';
import json from '@ohos.util.json';
import { deduplicateObjects } from '../../common/utils/utils';

@Component
export default struct ImportCommon {
  @StorageProp('pathBookSource') pathBookSource: string = ''
  @State localSourceList: BookSource[] = []
  @Prop sourceList: BookSource[] = []
  @Link show: boolean;
  @State groupList: GroupList[] = []
  @State currentIndex: number = 0
  @State activeNameMap: Record<string, boolean> = {}
  @State alreadyNameMap: Record<string, boolean> = {}
  @State updateNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State waringActive: boolean = false
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()

  aboutToAppear() {
    FileHandler.readJsonFile<BookSource[]>(this.pathBookSource).then(data => {
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
      // 如果groupMap中还没有这个group，则创建一个新的GroupList对象
      if (!groupMap[title]) {
        groupMap[title] = { title: title, list: [] };
      }
      // 向当前group的list中添加BookSource对象
      groupMap[title].list.push(item);
      for (let i = 0; i < this.localSourceList.length; i++) {
        const localItem = this.localSourceList[i];
        if (localItem.bookSourceGroup + localItem.bookSourceName === title + bookSourceName) {
          this.alreadyNameMap[title + bookSourceName] = true
          if (JSON.stringify(localItem) !== JSON.stringify(item)) {
            this.activeNameMap[title + bookSourceName] = true
            this.updateNameMap[title + bookSourceName] = true
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
        ClassifyList({
          currentIndex: this.currentIndex,
          classifyList: this.groupList.map(o => o.title),
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
              this.activeNameMap[item.bookSourceGroup + item.bookSourceName] = val
            })
          })

        Text() {
          Span('全选（')
          Span(Object.values(this.activeNameMap).filter(o => o).length + '')
            .fontColor(0xff6600)
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
          .fillColor(0xff6600)

        Text('允许对书架中正在使用的书源进行更新')
          .fontSize(14)
          .fontColor('#EF4444')
          .padding({ left: 8 })

        Blank()

        Checkbox()
          .select(this.waringActive)
          .selectedColor(0xff6600)
          .onChange((val: boolean) => {
            this.waringActive = val
          })
      }
      .width('100%')
      .height(48)
      .padding({ left: 20, right: 20 })
      .backgroundColor('rgba(239, 68, 68, 0.12)')

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
          .onClick(() => {
            const newDataList = [...this.localSourceList];
            const activeDataList =
              this.sourceList.filter(item => this.activeNameMap[item.bookSourceGroup + item.bookSourceName] ?? false)
            activeDataList.forEach(item => {
              const localIndex = newDataList.findIndex(localItem => localItem.bookSourceGrade + localItem.bookSourceName === item.bookSourceGrade + item.bookSourceName)
              if (localIndex != -1) {
                newDataList[localIndex] = item
              } else {
                newDataList.push(item)
              }
            })
            FileHandler.writeJsonFile(this.pathBookSource, JSON.stringify(deduplicateObjects(newDataList)))
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
          .select(this.activeNameMap[item.bookSourceGroup + item.bookSourceName] ?? false)
          .selectedColor(0xff6600)
          .onChange((val: boolean) => {
            this.activeNameMap[item.bookSourceGroup + item.bookSourceName] = val
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Blank()

      Row() {
        Score({ score: j > 5 ? 5 : j, isBoutique: j >= 6 })

        Text(this.updateNameMap[item.bookSourceGroup + item.bookSourceName] ?? false ?
          '更新' : (this.alreadyNameMap[item.bookSourceGroup + item.bookSourceName] ?? false ? '已有' : '新增'))
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

