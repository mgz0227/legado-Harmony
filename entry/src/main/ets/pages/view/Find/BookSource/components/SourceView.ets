import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import dayjs from 'dayjs'
import SideBar from '../../../../../componets/common/SideBar'
import dialogTitleFuction from '../../../../../componets/common/dialogTitleFuction'
import Header from '../../../../../componets/common/Header'
import { showMessage } from '../../../../../componets/common/promptShow'
import Score from '../../../../../componets/common/Score'
import Tag from '../../../../../componets/common/Tag'
import { IconTitleVo } from '../../../../../componetsmodel/IconTitleVo'
import { CustomContentDialog, router } from '@kit.ArkUI'
import BookSourceDao from '../../../../../database/dao/BookSourceDao'
import { GroupPartList, SOURCE_GROUP_MAP } from '../../../../../database/entities/BookSource'
import { BookSourcePart } from '../../../../../database/entities/BookSourcePart'
import { JSON } from '@kit.ArkTS'
import SourceGroup from '../../../../../componets/ui/SourceGroup'
import { BookSourceSearchParams } from '../../../../../database/types/BookSourceType'
import FiltrateOption from './FiltrateOption'
import FilterText from './FilterText'
import { ThemeItem } from '../../../../../common/model/Theme'
import { ThemeStorageKey } from '../../../../../common/constants/Theme'

@Component
export default struct SourceView {
  titleArray: Array<string> = ['小说', '漫画', '有声书']
  index: number = 0
  @StorageProp('pathBookSource') pathBookSource: string = ''
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State currentIndex: number = 0
  @State activeNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State groupList: GroupPartList[] = []
  @State sourceList: BookSourcePart[] = []
  @State searchValue: string = ''
  @State clickNameMap: Record<string, boolean> = {}
  @State enabledMap: Record<string, boolean> = {}
  @Link isBatch: boolean
  @State longCount: number = 0
  @State loading: boolean = true
  @State errorText: string = ''
  @State showRightDialogMap: Record<string, boolean> = {}
  @State showMoreDialog: boolean = false
  @State toggleAll: boolean = true
  @Link @Watch('getList') refresh: number
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()
  @State dialogItem: Partial<BookSourcePart> = {}
  @StorageLink('refreshCount') refreshCount: number = 0
  @State isShowGroup: boolean = false
  @State currentTitle: number = -1
  @State query: BookSourceSearchParams = {
    enabled: undefined,
    bookSourceGrade: undefined,
    order: undefined,
    hasLoginUrl: undefined
  }
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: '书源评分',
      contentAreaPadding: {
        left: 10,
        top: 10,
        right: 10,
        bottom: 10
      },
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          value: '取消',
          background: this.theme.secondColor,
          fontColor: this.theme.mainColor,
          action: () => {
            this.dialogItem = {}
            this.dialogController.close()
          }
        },
        {
          value: '确认',
          background: 'this.theme.mainColor',
          fontColor: '#FFFFFF',
          action: async () => {
            if (this.isBatch) {
              const sourceList: BookSourcePart[] = []
              this.sourceList.forEach((item, i) => {
                if (this.activeNameMap[item.bookSourceUrl]) {
                  item.bookSourceGrade = this.dialogItem.bookSourceGrade
                  item.bookSourceScore = this.dialogItem.bookSourceScore
                  sourceList.push(item)
                }
              })
              await BookSourceDao.batchUpdateFlow(sourceList)
              this.getList()
              this.activeNameMap = {}
              this.dialogController.close()
              this.dialogItem = {}
              return
            }
            await BookSourceDao.updateFlow(this.dialogItem as BookSourcePart)
            this.getList()
            this.dialogItem = {}
            this.dialogController.close()
          }
        }
      ],
      theme: {
        colors: {
          confirm: this.theme.mainColor
        }
      }
    }),
  });

  aboutToAppear() {
    console.info('TagInfo', '当前下标： ' + this.index)
    this.loading = true
    this.getList()
  }

  aboutToDisappear(): void {
    this.searchValue = ''
  }

  getList() {
    this.refreshCount += 1
    BookSourceDao.flowSearch({
      type: [0, 2, 1][this.index],
      searchKey: this.searchValue,
      enabled: this.query.enabled,
      bookSourceGrade: this.query.bookSourceGrade,
      order: this.query.order,
      hasLoginUrl: this.query.hasLoginUrl
    }).then(data => {
      const bookSource = data ?? []
      console.info('TagInfo', JSON.stringify(bookSource.slice(0, 3)))
      this.sourceList = bookSource
      this.getGroupList()
      this.loading = false
      console.info('TagInfo', '数量 ' + this.sourceList.length)
      if (!this.sourceList.length) {
        this.errorText = `当前${this.titleArray[this.index]}还没有添加源`
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
    Stack() {
      // 头部区域
      Column() {
        // 搜索框
        Column() {
          Search({
            value: this.searchValue,
            placeholder: `搜索${this.titleArray[this.index]}`,
            icon: "/common/images/search.svg"
          })
            .width("100%")
            .height(40)
            .backgroundColor(Color.White)
            .onChange((value: string) => {
              this.searchValue = value
              this.getList()
            })
        }
        .padding({
          left: 20,
          right: 20,
          top: 8,
        })

        // 筛选器
        Row() {
          FilterText({
            index: 0,
            title: this.query.enabled === undefined ? '全部' : (this.query.enabled ? '启用' : '禁用'),
            hasActive: this.query.enabled !== undefined,
            onChange: (index) => {
              if (this.currentTitle === index) {
                this.currentTitle = -1
                return
              }
              this.currentTitle = index
            }
          })

          Row().width(12)
          FilterText({
            index: 1,
            title: this.query.order === undefined ? '排序' : ['按评分', '按时间'][this.query.order],
            hasActive: this.query.order !== undefined,
            onChange: (index) => {
              if (this.currentTitle === index) {
                this.currentTitle = -1
                return
              }
              this.currentTitle = index
            }
          })

          Row().width(12)
          FilterText({
            index: 2,
            title: '校验',
            hasActive: this.query.verify !== undefined,
            onChange: (index) => {
              showMessage('校验，开发中')
            }
          })

          Row().width(12)
          FilterText({
            index: 3,
            title: this.query.bookSourceGrade === undefined ? '等级' : ['常规', '优质', '精品'][this.query.bookSourceGrade],
            hasActive: this.query.bookSourceGrade !== undefined,
            onChange: (index) => {
              if (this.currentTitle === index) {
                this.currentTitle = -1
                return
              }
              this.currentTitle = index
            }
          })

          Row().width(12)
          FilterText({
            index: 4,
            title: '登录',
            hasActive: this.query.hasLoginUrl !== undefined,
            isIcon: false,
            onChange: () => {
              if (this.query.hasLoginUrl) {
                this.query.hasLoginUrl = undefined
              } else {
                this.query.hasLoginUrl = true
              }
              this.getList()
            }
          })
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
      .translate({ y: !this.isBatch ? 0 : -122 - this.topRectHeight })
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
        .translate({ y: this.isBatch ? 0 : -50 - this.topRectHeight })
        .zIndex(99)
        .animation({
          duration: this.isBatch ? 300 : 0,
          delay: this.isBatch ? 300 : 0
        })

      Stack() {
        Column() {
          Stack() {
            Column() {
            }
            .backgroundColor('#99000000')
            .width('100%')
            .height('100%')
            .opacity(this.currentTitle !== -1 ? 1 : 0)
            .animation({
              duration: this.currentTitle !== -1 ? 300 : 0
            })

            Row() {
              if (this.currentTitle === 0) {
                FiltrateOption({
                  options: [
                    {
                      label: '全部',
                      value: undefined
                    },
                    {
                      label: '启用',
                      value: true
                    },
                    {
                      label: '禁用',
                      value: false
                    }
                  ],
                  value: this.query.enabled,
                  onChange: (value) => {
                    this.query.enabled = value as boolean
                    this.getList()
                    setTimeout(() => {
                      this.currentTitle = -1
                    }, 200)
                  }
                })
              }
              if (this.currentTitle === 1) {
                FiltrateOption({
                  options: [
                    {
                      label: '按评分排序',
                      value: 0
                    },
                    {
                      label: '按时间排序',
                      value: 1
                    }
                  ],
                  columns: 2,
                  isAgain: true,
                  value: this.query.order,
                  onChange: (value) => {
                    this.query.order = value as number
                    this.getList()
                    setTimeout(() => {
                      this.currentTitle = -1
                    }, 200)
                  }
                })
              }
              if (this.currentTitle === 3) {
                FiltrateOption({
                  options: [
                    {
                      label: '全部',
                      value: undefined
                    },
                    {
                      label: '精选',
                      value: 2
                    },
                    {
                      label: '优质',
                      value: 1
                    },
                    {
                      label: '常规',
                      value: 0
                    }
                  ],
                  columns: 4,
                  value: this.query.bookSourceGrade,
                  onChange: (value) => {
                    this.query.bookSourceGrade = value as number
                    this.getList()
                    setTimeout(() => {
                      this.currentTitle = -1
                    }, 200)
                  }
                })
              }
            }
            .height([0, 1, 3].includes(this.currentTitle) ? 64 : 0)
            .backgroundColor('#f5f5f5')
            .padding({ left: 20, right: 20, bottom: 8 })
            .borderRadius({
              bottomLeft: 8,
              bottomRight: 8
            })
            .translate({ y: this.currentTitle !== -1 ? 0 : -64 })
            .width('100%')
            .animation({
              duration: this.currentTitle !== -1 ? 300 : 0
            })
          }
          .width('100%')
          .height('100%')
          .alignContent(Alignment.Top)
        }
        .width('100%')
        .height('100%')
        .padding({ top: 122 })
        .zIndex(this.currentTitle !== -1 ? 99 : -1)
        .onClick(() => {
          this.currentTitle = -1
        })

        Column() {
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
                console.info('TagInfo bookSourcePartList:', JSON.stringify(bookSourcePartList))
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
                    if (this.longCount >= 1) {
                      this.isBatch = true
                    }
                    this.longCount++
                  }
                })
                .onActionEnd(() => {
                  this.longCount = 0
                })
            )
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

        Column() {
          if (this.errorText && !this.sourceList.length) {
            Text(this.errorText)
          } else {
            LoadingProgress()
              .color(this.theme.mainColor)
              .width('50%')
            Text('加载中...')
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
      .height('100%')


      Row() {
        Row() {
          Column() {
            Image($r('app.media.verify'))
              .width(24)
              .margin({ bottom: 4 })
            Text('校验')
              .fontSize(12)
          }
          .layoutWeight(1)
          .onClick(() => {
            showMessage('校验')
          })

          Row().width(12)
          Column() {
            Toggle({ type: ToggleType.Switch, isOn: this.toggleAll })
              .selectedColor(this.theme.mainColor)
              .margin({ bottom: 4 })
              .onChange(async (val: boolean) => {
                this.toggleAll = val
                this.sourceList.forEach((item, i) => {
                  if (this.activeNameMap[item.bookSourceUrl]) {
                    item.enabled = val
                    this.sourceList[i] = item
                  }
                })
                await BookSourceDao.batchUpdateFlow(this.sourceList)
                this.getList()
              })

            Text(this.toggleAll ? '禁用' : '启用')
              .fontSize(12)
          }
          .layoutWeight(1)

          Row().width(12)
          Column() {
            Image($r('app.media.export_1'))
              .width(24)
              .margin({ bottom: 4 })
            Text('导出')
              .fontSize(12)
          }
          .layoutWeight(1)
          .onClick(() => {
            showMessage('导出')
          })

          Row().width(12)
          Column() {
            Image($r('app.media.delete'))
              .width(24)
              .margin({ bottom: 4 })
            Text('删除')
              .fontSize(12)
          }
          .layoutWeight(1)
          .onClick(async () => {
            if (!Object.values(this.activeNameMap).filter(o => o).length) {
              return showMessage('请至少选择一个')
            }
            await BookSourceDao.batchDelete(Object.keys(this.activeNameMap))
            showMessage('删除成功')
            this.activeNameMap = {}
            this.getList()
          })

          Row().width(12)
          Column() {
            Image($r('app.media.more'))
              .width(24)
              .margin({ bottom: 4 })
            Text('更多')
              .fontSize(12)
          }
          .layoutWeight(1).bindMenu(
            this.showMoreDialog,
            this.rightDialogBuilder(this.More_Right_Dialog_Data, async (index: number) => {
              switch (index) {
                case 0:
                  if (!Object.values(this.activeNameMap).filter(o => o).length) {
                    showMessage('请至少选择一个')
                    return
                  }
                  this.isShowGroup = true;
                  break;
                case 1:
                  if (!Object.values(this.activeNameMap).filter(o => o).length) {
                    showMessage('请至少选择一个')
                    return
                  }
                  this.dialogItem = this.sourceList.filter(item => this.activeNameMap[item.bookSourceUrl])[0]
                  this.dialogController.open()
                  break;
                case 2:
                  showMessage(this.More_Right_Dialog_Data[index].title)
                  break;
              }
            }),
            {
              onDisappear: () => {
                this.showMoreDialog = false
              }
            })
          .onClick(() => {
            this.showMoreDialog = true
          })
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
      .position({ bottom: 0 })
      .zIndex(99)
      .translate({ y: this.isBatch ? 0 : 68 + this.bottomRectHeight })
      .animation({
        duration: 500
      })
      .padding({ bottom: this.bottomRectHeight })


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
    .alignContent(Alignment.Top)
  }

  @Builder
  selectAll() {
    Column() {
      Text('全选')
    }
    .onClick(() => {
      this.sourceList.forEach((item: BookSourcePart) => {
        this.activeNameMap[item.bookSourceUrl] = true
      })
    })
  }

  @Builder
  complete() {
    Column() {
      Text('完成')
    }
    .onClick(async () => {
      this.isBatch = false
      this.activeNameMap = {}
      this.getList()
    })
  }

  @Builder
  buildContent() {
    Column() {
      Rating({ rating: parseInt(this.dialogItem?.bookSourceScore?.replace('分', '') ?? '0') })
        .size({
          width: 192,
          height: 32
        })
        .stars(5)
        .stepSize(1)
        .margin({ bottom: 16 })
        .onChange((value: number) => {
          this.dialogItem.bookSourceScore = value.toFixed(1) + '分'
        })

      Row() {
        Row() {
          Radio({ value: '2', group: 'radioGroup' })
            .checked(this.dialogItem?.bookSourceGrade === 2)
            .radioStyle({
              checkedBackgroundColor: this.theme.mainColor
            })
            .height(20)
            .width(20)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.dialogItem.bookSourceGrade = 2
              }
            })
          Text('精品')
            .padding({ left: 6 })
        }

        Row() {
          Radio({ value: '1', group: 'radioGroup' })
            .checked(this.dialogItem?.bookSourceGrade === 1)
            .radioStyle({
              checkedBackgroundColor: this.theme.mainColor
            })
            .height(20)
            .width(20)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.dialogItem.bookSourceGrade = 1
              }
            })
          Text('优质')
            .padding({ left: 6 })
        }
        .padding({ left: 10 })

        Row() {
          Radio({ value: '0', group: 'radioGroup' })
            .checked(this.dialogItem?.bookSourceGrade === 0)
            .radioStyle({
              checkedBackgroundColor: this.theme.mainColor
            })
            .height(20)
            .width(20)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.dialogItem.bookSourceGrade = 0
              }
            })
          Text('普通')
            .padding({ left: 6 })
        }
        .padding({ left: 10 })
      }
      .justifyContent(FlexAlign.SpaceAround)
    }
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
              this.rightDialogBuilder(this.Item_Right_Dialog_Data, async (index: number) => {
                switch (index) {
                  case 0:
                    router.pushUrl({
                      url: 'pages/view/Find/BookSource/AddSourcePage', params: {
                        id: item.bookSourceUrl
                      }
                    })
                    break;
                  case 1:
                    this.dialogItem = JSON.parse(JSON.stringify(item)) as BookSourcePart
                    this.dialogController.open()
                    break;
                  case 2:
                  case 3:
                    showMessage(this.Item_Right_Dialog_Data[index].title)
                    break;
                  case 4:
                    router.pushUrl({
                      url: 'pages/view/Find/BookSource/AddSourcePage', params: {
                        id: item.bookSourceUrl, type: 1
                      }
                    })
                    break;
                  case 5:
                    await BookSourceDao.delete(item.bookSourceUrl)
                    showMessage('删除成功')
                    this.getList()
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
        Toggle({ type: ToggleType.Switch, isOn: item.enabled })
          .selectedColor(this.theme.mainColor)
          .onChange(async (val: boolean) => {
            item.enabled = val
            await BookSourceDao.updateFlow(item)
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
            .maxLines(this.clickNameMap[item.bookSourceUrl] ? 99 : 1)
            .layoutWeight(1)
            .animation({
              duration: 300
            })
            .onClick(() => {
              this.clickNameMap[item.bookSourceUrl] = !this.clickNameMap[item.bookSourceUrl]
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

  Item_Right_Dialog_Data: IconTitleVo[] = [
    new IconTitleVo($r('app.media.edit'), '编辑'),
    new IconTitleVo($r('app.media.icon_no_source_find'), '评分'),
    new IconTitleVo($r('app.media.search'), '搜索'),
    new IconTitleVo($r('app.media.ic_logout'), '登录'),
    new IconTitleVo($r('app.media.icon_rule_help'), '调试'),
    new IconTitleVo($r('app.media.delete'), '删除')
  ]
  More_Right_Dialog_Data: IconTitleVo[] = [
    new IconTitleVo($r('app.media.ic_folder'), '移动至'),
    new IconTitleVo($r('app.media.icon_no_source_find'), '评分'),
    new IconTitleVo($r('app.media.icon_share'), '分享'),
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

  //移动分组
  @Builder
  showCheckGroup() {
    Flex() {
      SourceGroup({
        groupList: SOURCE_GROUP_MAP[[0, 2, 1][this.index]],
        confirm: async (groupName) => {
          this.sourceList.forEach((item, i) => {
            if (this.activeNameMap[item.bookSourceUrl]) {
              item.bookSourceGroup = groupName
              this.sourceList[i] = item
            }
          })
          await BookSourceDao.batchUpdateFlow(this.sourceList)
          this.getList()
          this.activeNameMap = {}
          this.isShowGroup = false
        },
        cancel: () => {
          this.isShowGroup = false
        }
      })
    }
    .padding({ bottom: this.bottomRectHeight })
  }
}