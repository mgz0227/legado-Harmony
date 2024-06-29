import CommonConstants from '../../common/constants/CommonConstants'
import ReadRecordItem from '../../componets/bookDetail/ReadRecordItem'
import TagIndex from '../../componets/bookDetail/TagIndex'
import { router, SwipeRefresher } from '@kit.ArkUI'
import NoteIndex from '../../componets/bookDetail/note/NoteIndex'
import { BookList } from 'ets/componets/dataList/bookList'

/**
 * 标题图片样式
 */
@Extend(Image)
function titleImageStyle() {
  .fillColor(Color.White)
  .width(CommonConstants.TITLE_IMG_SIZE)
  .height(CommonConstants.TITLE_IMG_SIZE)
}

/**
 * 分割线样式
 */
@Extend(Divider)
function recordDividerStyle() {
  .vertical(true)
  .width(0.5)
  .height(24)
  .color('#40ffffff')
}

/**
 * 加入书架dialog
 */
@CustomDialog
struct AddBookShelfDialog {
  controller?: CustomDialogController;

  build() {
    Row() {
      Image($r('app.media.ic_public_confirm'))
        .width(24)
        .height(24)
        .fillColor('#FFFFFF')
      Text('加入书架成功')
        .fontSize(14)
        .fontWeight(400)
        .lineHeight(22)
        .fontColor('#FFFFFF')
      Blank()
      Text('移入分组')
        .fontSize(14)
        .fontWeight(400)
        .lineHeight(22)
        .fontColor('#FF9500')
    }
    .height(56)
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      left: 20,
      right: 20,
      top: 16,
      bottom: 16
    })
    .backgroundColor('#333333')
  }
}

@Entry
@Component
struct BookDetailPage {
  @State isShow: boolean = true;
  @State currentIndex: number = 0;
  // 是否加入书架
  @State isAddBookShelf: boolean = false;
  @State bookData: BookList = router.getParams() as BookList
  // 加入书架dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddBookShelfDialog(),
    cornerRadius: 8,
    offset: { dx: 0, dy: -100 }
  })

  onPageShow(): void {
    console.log('router BookDetailPage:' + JSON.stringify(router.getParams()))
    if (router.getParams() as BookList) {
      this.bookData = router.getParams() as BookList
    }
  }

  // 加入书架函数
  addBookShelf() {
    this.dialogController.open();
    this.isAddBookShelf = true;
    // 1s后关闭dialog
    let timeoutID = setTimeout(() => {
      this.dialogController.close();
    }, 1000);
    clearTimeout(timeoutID);
  }

  /**
   * Panel
   */
  @Builder
  catalogPanel() {
    Column() {
      Search({ placeholder: '搜索目录' })
        .height(34)
        .padding({ top: 8, bottom: 8 })
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Column() {
            SwipeRefresher({
              content: '目录加载中...',
              isLoading: true
            })
          }
        }
        .tabBar(this.catalogTab(0, '目录', 548))

        TabContent() {
          Column() {
            SwipeRefresher({
              content: '目录加载中...',
              isLoading: true
            })
          }
        }
        .tabBar(this.catalogTab(1, '书源', 24))

        TabContent() {
          NoteIndex()
        }
        .tabBar(this.catalogTab(2, '笔记', 7))
      }
      .layoutWeight(1)
      .onChange((index: number) => {
        this.currentIndex = index;
      })

      Row({ space: 20 }) {
        Button(this.isAddBookShelf ? '已加书架' : '加入书架')
          .padding({
            left: 32,
            right: 32,
            top: 8,
            bottom: 8
          })
          .width(150)
          .height(40)
          .borderRadius(200)
          .backgroundColor('#1fff6600')
          .fontColor('#FF6600')
          .onClick(() => {
            this.addBookShelf();
          })
        Button('立即阅读')
          .padding({
            left: 32,
            right: 32,
            top: 8,
            bottom: 8
          })
          .width(150)
          .height(40)
          .borderRadius(200)
          .backgroundColor('#FF6600')
          .fontColor('#FFFFFF')
          .onClick(() => {
            // 跳转到阅读器
            router.pushUrl({
              url: 'pages/view/Reader/ReaderPage',
              params: this.bookData
            })
          })
      }
      .padding({ top: 12, bottom: 12 })
      .justifyContent(FlexAlign.Center)
      .width(CommonConstants.FULL_WIDTH)
      .height(64)
    }
    .padding({ left: 20, right: 20, bottom: 12 })
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .borderRadius(16)
  }

  /**
   * tab页签
   */
  @Builder
  catalogTab(index: number, name: string, count: number) {
    Column() {
      Row() {
        Text(name)
          .fontSize(16)
          .fontColor(this.currentIndex === index ? '#e0000000' : '#73000000')
          .fontWeight(500)
          .lineHeight(24)
        Text(count.toString())
          .fontSize(12)
          .lineHeight(20)
          .fontColor(this.currentIndex === index ? '#e0000000' : '#73000000')
          .fontWeight(500)
      }

      Divider()
        .width(10)
        .strokeWidth(3)
        .lineCap(LineCapStyle.Round)
        .color('#FF6600')
        .opacity(this.currentIndex === index ? 1 : 0)
    }
    .padding({ top: 8, bottom: 8 })
    .width(59)
    .height(40)
  }

  build() {
    Column() {
      // todo 状态栏
      Row() {

      }
      .width(CommonConstants.FULL_WIDTH)
      .height(40)

      // 标题栏
      Row() {
        // 返回与标题
        Row({ space: 12 }) {
          Image($r("app.media.ic_public_return_left"))
            .titleImageStyle()
            .onClick(() => {
              router.back()
            })
          Text('书籍详情')
            .fontColor(Color.White)
            .fontSize(16)
        }
        .height(24)

        Blank()
        // 右侧功能
        Row({ space: 24 }) {
          Image($r('app.media.ic_public_edit'))
            .titleImageStyle()
            .onClick(() => {
              router.pushUrl({
                url: '/pages/view/BookEditor/BookEditorPage'
              })
            })
          Image($r('app.media.ic_public_share'))
            .titleImageStyle()
          Image($r('app.media.more'))
            .titleImageStyle()
        }
        .height(24)
      }
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
      .height(36)
      .width(CommonConstants.FULL_WIDTH)

      // 小说标题
      Row({ space: CommonConstants.SPACE_20 }) {
        Image($r('app.media.cover_list'))
          .width(CommonConstants.NOVEL_IMG_WIDTH)
          .height(CommonConstants.NOVEL_IMG_HEIGHT)
          .borderRadius(5)
        Column({ space: 8 }) {
          Text(this.bookData.title)
            .fontColor(Color.White)
            .fontSize(20)
          Blank()
          Row() {
            Text('卖报小郎君')
              .fontSize(CommonConstants.FONT_NOVEL_DETAIL_AUTHOR_SIZE)
              .fontColor('#FFF')
              .opacity(0.45)
            Image($r('app.media.ic_public_right'))
              .width(CommonConstants.NOVEL_DETAIL_AUTHOR_IMG_SIZE)
              .height(CommonConstants.FONT_NOVEL_DETAIL_AUTHOR_SIZE)
              .fillColor('#FFF')
              .opacity(0.45)
          }

          Row({ space: 8 }) {
            TagIndex({ tag: '幻想修仙' })
            TagIndex({ tag: '完本' })
            TagIndex({ tag: '300万字' })
          }
        }
        .height(CommonConstants.NOVEL_IMG_HEIGHT)
        .alignItems(HorizontalAlign.Start)
      }
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
      .width(CommonConstants.FULL_WIDTH)
      .height(116)

      // 阅读记录
      Row() {
        Row() {
          ReadRecordItem()
          Divider()
            .recordDividerStyle()
          ReadRecordItem({ count: 16, unit: '天', placeText: '阅读天数' })
          Divider()
            .recordDividerStyle()
          ReadRecordItem({ count: 3, unit: '次', placeText: 'N刷次数' })
        }
        .borderRadius(12)
        .padding({ top: 16, bottom: 16 })
        .height(60)
        .width(CommonConstants.FULL_WIDTH)
        .backgroundColor('#14ffffff')
      }
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
      .width(CommonConstants.FULL_WIDTH)
      .height(88)

      // 书籍简介
      Flex() {
        Text('《大奉打更人》（第一卷）实体书已在天猫、当当、京东等全平台，以及各个实体书店发售。 这个世界，有儒；有道；有佛；有妖；有术士。 警校毕业的许七安幽幽醒来，发现自己身处牢狱之中，三日后流放边陲..... ' +
          '\n他起初的目的只是自保，顺便在这个没有人权的社会里当个富家翁悠闲度日。 ...... 多年后，许七安回首前尘，身后是早已逝去的敌人，以及累累白骨。 ' +
          '\n滚滚长江东逝水，浪花淘尽英雄，是非成败转头空。 ' +
          '\n青山依旧在，几度夕阳红。')
          .fontColor('#FFFFFF')
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(22)
      }
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
      .width(CommonConstants.FULL_WIDTH)
      .bindSheet($$this.isShow, this.catalogPanel(), {
        detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
        backgroundColor: '#FFFFFF',
        showClose: false,
        dragBar: true,
        enableOutsideInteractive: true,
      })

      // 章节目录Panel
      /*Panel(this.isValue) {
        Column() {

        }
      }
      .width(CommonConstants.FULL_WIDTH)
      .type(PanelType.Foldable)
      .halfHeight('50%')
      .backgroundColor('#FFFFFF')*/
    }
    .height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH)
    .backgroundColor($r('app.color.book_detail_background'))
  }
}