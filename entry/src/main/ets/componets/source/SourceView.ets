import dayjs from 'dayjs'
import PaddingConstants from '../../common/constants/PaddingConstants'
import { IconTitleVo } from '../../componetsmodel/IconTitleVo'
import BookSourceDao from '../../database/dao/BookSourceDao'
import { GroupPartList } from '../../database/entities/BookSource'
import { BookSourcePart } from '../../database/entities/BookSourcePart'
import dialogTitleFuction from '../common/dialogTitleFuction'
import { showMessage } from '../common/promptShow'
import Score from '../common/Score'
import SideBar from '../common/SideBar'
import Tag from '../common/Tag'
import { router } from '@kit.ArkUI'
import noFind from '../common/noFind'
import { ThemeItem } from '../../common/model/Theme'
import { ThemeStorageKey } from '../../common/constants/Theme'

@Component
export default struct SourceView {
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  titleArray: Array<string> = ['小说', '漫画', '有声书']
  index: number = 0
  type: number = 0
  @Link @Watch('getList') searchValue: string
  @State activeNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State groupList: GroupPartList[] = []
  @State sourceList: BookSourcePart[] = []
  @State loading: boolean = true
  @State errorText: string = ''
  @Link isBatch: boolean
  @State showRightDialogMap: Record<string, boolean> = {}
  @State currentIndex: number = 0
  @State topToggle: boolean = false
  @Link @Watch('getList') refreshCount: number
  closeDialog: () => void = () => {
  }
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  aboutToAppear() {
    console.info('TagInfo', '当前下标： ' + this.index)
    this.loading = true
    this.getList()
  }

  getList() {
    BookSourceDao.flowSearch({
      type: [0, 2, 1][this.type],
      searchKey: this.searchValue,
      showExplore: this.index === 0
    }).then(data => {
      const bookSource = data ?? []
      console.info('TagInfo', JSON.stringify(bookSource.slice(0, 3)))
      this.sourceList = bookSource
      this.getGroupList()
      this.loading = false
      console.info('TagInfo', '数量 ' + this.sourceList.length)
      if (!this.sourceList.length) {
        this.errorText = `当前${this.titleArray[this.type]}还没有添加源`
      }
    })
  }

  getGroupList() {
    const groupMap: Record<string, GroupPartList> = {};
    this.sourceList.forEach((item: BookSourcePart) => {
      const title = item.bookSourceGroup;
      const bookSourceName = item.bookSourceName;
      if (bookSourceName.indexOf(this.searchValue) === -1) {
        return
      }
      if (!title) {
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
    Column() {
      Stack() {
        Row() {
          Column() {
            Text('全选')
              .fontSize(14)
              .fontColor('#E0000000')
          }
          .onClick(() => {
            this.sourceList.forEach((item: BookSourcePart) => {
              this.activeNameMap[item.bookSourceUrl] = true
            })
          })

          Text(`已选${Object.values(this.activeNameMap).filter(o => o).length}项`)
            .fontSize(16)
            .fontWeight(700)
            .fontColor('#000000')

          Column() {
            Text('完成')
              .fontSize(14)
              .fontColor('#E0000000')
          }
          .onClick(() => {
            this.isBatch = false
            this.activeNameMap = {}
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({
          left: PaddingConstants.PADDING_20,
          right: PaddingConstants.PADDING_20
        })
        .height(48)
        .translate({ y: this.isBatch ? 0 : -48 })
        .animation({
          duration: 300,
          delay: 300
        })
        .opacity(this.isBatch ? 1 : 0)
        .zIndex(1)

        // 内容主体
        Row({ space: 12 }) {
          SideBar({
            currentIndex: this.currentIndex,
            sideBarList: this.groupList,
            scroller: this.scroll,
            clickAction: (index: number) => {
              this.scrollChangeAction(index, true)
            },
            isBadge: !this.isBatch,
            isDrag: this.isBatch,
            onDragChange: async (list) => {
              this.groupList = list as GroupPartList[]
              const bookSourcePartList =
                this.groupList.reduce((acc: BookSourcePart[], item) => acc.concat(item.list), [])
              const sortBookSourcePartList = bookSourcePartList.map((item, index) => {
                if (index !== 0) {
                  item.customOrder = bookSourcePartList[index - 1].customOrder + 1
                }
                return item
              })
              console.info('TagInfo: 更新成功')
              await BookSourceDao.batchUpdateFlow(sortBookSourcePartList)
              this.refreshCount += 1
            }
          })
            .width(88)

          List({ scroller: this.secondScroll }) {
            ForEach(this.groupList, (item: GroupPartList, index: number) => {
              ListItemGroup({
                header: this.classifyHeader(`${item.title} (${item.list.length})`, index),
                space: 0
              }) {
                ForEach(item.list, (bookSource: BookSourcePart, j: number) => {
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
          .height('100%')
          .layoutWeight(1)
          .gesture(
            LongPressGesture({ repeat: true, duration: 500 })
              .onAction((event: GestureEvent) => {
                if (event && event.repeat) {
                  this.isBatch = true
                }
              })
          )
        }
        .layoutWeight(1)
        .animation({
          duration: 300
        })
        .padding({
          top: this.isBatch ? 50 : 0,
          bottom: this.isBatch ? 56 + this.bottomRectHeight : this.bottomRectHeight
        })


        Row() {
          Row() {
            Column() {
              Text(this.topToggle ? '取消置顶' : '置顶')
                .fontSize(16)
            }
            .layoutWeight(1)
            .onClick(async () => {
              if (!Object.values(this.activeNameMap).filter(o => o).length) {
                showMessage('请至少选择一个')
                return
              }
              this.sourceList.forEach((item, i) => {
                if (this.activeNameMap[item.bookSourceUrl]) {
                  item.isTop = !this.topToggle
                  this.sourceList[i] = item
                }
              })
              await BookSourceDao.batchUpdateFlow(this.sourceList)
              this.activeNameMap = {}
              this.refreshCount += 1
              this.topToggle = !this.topToggle
            })

            Row().width(12)
            Column() {
              Text(this.index === 0 ? '隐藏' : '显示')
                .fontSize(16)
            }
            .layoutWeight(1)
            .onClick(async () => {
              if (!Object.values(this.activeNameMap).filter(o => o).length) {
                showMessage('请至少选择一个')
                return
              }
              this.sourceList.forEach((item, i) => {
                if (this.activeNameMap[item.bookSourceUrl]) {
                  item.showExplore = this.index !== 0
                  this.sourceList[i] = item
                }
              })
              await BookSourceDao.batchUpdateFlow(this.sourceList)
              this.activeNameMap = {}
              this.refreshCount += 1
            })
          }
          .padding({
            left: 20,
            right: 20,
          })
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .height(56)
        }
        .backgroundColor(Color.White)
        .position({ bottom: 0 })
        .zIndex(99)
        .translate({ y: this.isBatch ? 0 : 56 + this.bottomRectHeight })
        .animation({
          duration: 500
        })
        .padding({ bottom: this.bottomRectHeight })

        Column() {
          if (this.loading) {
            LoadingProgress()
              .color(this.theme.mainColor)
              .width('50%')
            Text('加载中...')
          } else if (this.errorText) {
            noFind()
          } else if (!this.sourceList.length) {
            noFind({
              hintIndex: 0
            })
          }
        }
        .justifyContent(FlexAlign.Center)
        .zIndex(this.loading || (this.errorText && !this.sourceList.length) ? 9 : -1)
        .opacity(this.loading || (this.errorText && !this.sourceList.length) ? 1 : 0)
        .width('100%')
        .height('100%')
        .backgroundColor('#f5f5f5')
        .animation({
          duration: 300
        })
      }
      .alignContent(Alignment.Top)
    }
    .height('100%')
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
          .selectedColor(this.theme.mainColor)
      } else {
        Text('长按批量管理')
          .fontSize(12)
          .fontWeight(400)
          .lineHeight(20)
          .padding({ left: 8 })
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
  CourseItem(item: BookSourcePart, i: number, j: number) {
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

        if (item.hasLoginUrl) {
          Tag({ text: '登录', color: '#188BFF', bgColor: '#1F188BFF' })
        }

        if (item.hasExploreUrl) {
          Tag({ text: '发现', color: this.theme.mainColor, bgColor: this.theme.secondColor })
        }

        Blank()

        if (this.isBatch) {
          Checkbox({ name: 'checkbox' + j, group: 'checkboxGroup' + i })
            .select(this.activeNameMap[item.bookSourceUrl] ?? false)
            .selectedColor(this.theme.mainColor)
            .onChange((val: boolean) => {
              this.activeNameMap[item.bookSourceUrl] = val
            })
        } else {
          Image($r('app.media.more_vertical'))
            .width(24).fillColor('#73000000')
            .bindMenu(
              this.showRightDialogMap[item.bookSourceUrl],
              this.rightDialogBuilder(this.Item_Right_Dialog_Data.map((itemData, index) => {
                if (index === 1) {
                  itemData.title = item.isTop ? '取消置顶' : '置顶'
                }
                if (index === 3) {
                  itemData.title = item.showExplore ? '隐藏' : '显示'
                }
                return itemData
              }), async (index: number) => {
                switch (index) {
                  case 0:
                    this.closeDialog()
                    router.pushUrl({
                      url: 'pages/view/Find/BookSource/AddSourcePage', params: {
                        id: item.bookSourceUrl
                      }
                    })
                    break;
                  case 1:
                    item.isTop = !item.isTop
                    this.showRightDialogMap[item.bookSourceUrl] = false
                    await BookSourceDao.updateFlow(item)
                    this.refreshCount += 1
                  case 2:
                    showMessage(this.Item_Right_Dialog_Data[index].title)
                    break;
                  case 3:
                    item.showExplore = !item.showExplore
                    this.showRightDialogMap[item.bookSourceUrl] = false
                    await BookSourceDao.updateFlow(item)
                    this.refreshCount += 1
                    break;
                }
              }),
              {
                onDisappear: () => {
                  this.showRightDialogMap[item.bookSourceUrl] = false
                }
              })
            .onClick(() => {
              this.showRightDialogMap[item.bookSourceUrl] = true
            })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Score({ grade: item.bookSourceGrade, score: item.bookSourceScore })
      }
      .width('100%')
      .margin({ top: 10 })
      .justifyContent(FlexAlign.Start)

      Row() {
        Text(dayjs(item.lastUpdateTime).format('YYYY-MM-DD HH:mm'))
          .fontSize(12)
          .lineHeight(20)
          .fontColor('rgba(0, 0, 0, 0.45)')
        Text('导入')
          .padding({ left: 4 })
          .fontSize(12)
          .lineHeight(20)
          .fontColor('rgba(0, 0, 0, 0.45)')
        Blank()
      }
      .width('100%')
      .margin({ top: 3 })
      .justifyContent(FlexAlign.SpaceBetween)

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
    .border({
      width: 1,
      color: this.activeNameMap[item.bookSourceUrl] ? this.theme.mainColor : Color.White,
      style: BorderStyle.Solid
    })
    .backgroundColor(this.activeNameMap[item.bookSourceUrl] ? this.theme.secondColor : Color.White)
  }

  Item_Right_Dialog_Data: IconTitleVo[] = [
    new IconTitleVo($r('app.media.edit'), '编辑'),
    new IconTitleVo($r('app.media.top'), '置顶'),
    new IconTitleVo($r('app.media.search'), '搜索'),
    new IconTitleVo($r('app.media.ic_logout'), '显示'),
  ]

  @Builder
  rightDialogBuilder(list: IconTitleVo[], dialogRightChange: (_index: number) => void) {
    Column() {
      ForEach(list, (item: IconTitleVo, index) => {
        dialogTitleFuction({
          title: item.title,
          icon: item.icon,
          isBorder: list.length !== index + 1
        })
          .onClick(() => {
            dialogRightChange(index)
          })
      })
    }
  }
}