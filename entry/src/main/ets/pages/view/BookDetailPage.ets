import CommonConstants from '../../common/constants/CommonConstants'
import ReadRecordItem from '../../componets/bookDetail/ReadRecordItem'
import TagIndex from '../../componets/bookDetail/TagIndex'
import { router, SwipeRefresher } from '@kit.ArkUI'
import NoteIndex from '../../componets/bookDetail/note/NoteIndex'
import { chaptersItem } from '../../componets/dataList/ReaderChaptersItem'
import { FileHandler } from '../../common/utils/FileHandler'
import ChaptersDataSource from '../../common/LazyIDataSource/ChaptersDataSource'
import { Books } from '../../database/entities/Books'
import { BookHistory } from '../../database/entities/BookHistory'
import bookHistoryUtils from '../../common/utils/BookHistoryUtils'
import booksUtil from '../../common/utils/booksUtils'
import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'

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
  @State bookData: Books = router.getParams() as Books
  // 加入书架dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddBookShelfDialog(),
    cornerRadius: 8,
    offset: { dx: 0, dy: -100 },
    gridCount: 4,
    customStyle: false,
  })
  @State txtFiles: chaptersItem[] = [];
  @State txtFile: ChaptersDataSource = new ChaptersDataSource()

  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  onPageShow() {
    this.isShow = true
  }

  async aboutToAppear() {
    console.log('router BookDetailPage:' + JSON.stringify(router.getParams()))
    if (router.getParams() as Books) {
      this.bookData = router.getParams() as Books
      //校验是否加入书架
      if (!this.bookData.isJoin) {
       this.bookData.isJoin = await booksUtil.isExistBooks(this.bookData.bookUrl, this.bookData.bookName)
      }
      let temp = await FileHandler.readFile(this.bookData?.bookUrl||'') //txt小说
      // FileHandler.readerEpubFile(this.bookData?.bookUrl||'')
      this.txtFile.pushAllData(temp)
      this.txtFiles = this.txtFile.getListData()
      this.initUrlBook()
    }
  }
  initUrlBook(){
    let book = this.bookData.bookUrl
    console.log(book)
  }


  @StorageLink('BOOK_IS_BOOK_REFRESHING') isBookRefreshing: number = 0
  // 加入书架函数
  addBookShelf() {
    booksUtil.addBooks(this.bookData)
    this.dialogController.open();
    this.isAddBookShelf = true;
    // 1s后关闭dialog
    setTimeout(() => {
      this.isBookRefreshing++
      this.dialogController.close();
    }, 1000);
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
            if (this.txtFiles.length === 0 || undefined) {
              SwipeRefresher({
                content: '目录加载中...',
                isLoading: true
              })
            } else {
              List() {
                LazyForEach(this.txtFile, (item: chaptersItem, index: number) => {
                  ListItem() {
                    Button({ type: ButtonType.Normal }) {
                      Row() {
                        Text(`${item.chapterTitleNumber} ${item.title}`
                          .replace(new RegExp('\\s{1,}', 'g'), ' ')
                          .replaceAll('=', ''))
                          .layoutWeight(1)
                      }
                      .width('100%')
                      .padding({
                        left: 20,
                        right: 20,
                        top: 12,
                        bottom: 12
                      })
                    }
                    .borderRadius(10)
                    .width('100%')
                    .backgroundColor(Color.White)
                    .onClick(() => {
                      // 跳转到阅读器
                      router.pushUrl({
                        url: 'pages/view/Reader/ReaderPage2',
                        //跳转到对应的章节，传index过去，对面TotalChapters接收
                        params: {
                          bookData: this.bookData,
                          clickBookChapter: index,
                          txtFile: this.txtFiles
                        }
                      })
                      if (this.txtFiles && this.txtFile.getListData()[index]) {
                        this.jumpReadPage(`${item.chapterTitleNumber} ${item.title}`,index)
                      }
                    })
                  }
                })

              }
              .chainAnimation(true)
              .edgeEffect(EdgeEffect.Fade)
              .divider({
                strokeWidth: 0.8,
                color: '#cccccc',
                startMargin: 12,
                endMargin: 12
              })
            }
          }
        }
        .tabBar(this.catalogTab(0, '目录', this.txtFile.totalCount()))

        TabContent() {
          Column() {
            SwipeRefresher({
              content: '书源加载中...',
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
        Button(this.bookData.isJoin ? '已加书架' : '加入书架')
          .padding({
            left: 32,
            right: 32,
            top: 8,
            bottom: 8
          })
          .width(150)
          .height(40)
          .borderRadius(200)
          .backgroundColor(this.theme.secondColor)
          .fontColor(this.theme.mainColor)
          .onClick(() => {
            !this.bookData.isJoin?this.addBookShelf():''
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
          .backgroundColor(this.txtFile.totalCount() > 0 ? this.theme.mainColor : 'gray')
          .fontColor('#FFFFFF')
          .enabled(this.txtFile.totalCount() > 0)
          .onClick(() => {
            // 跳转到阅读器
            router.pushUrl({
              url: 'pages/view/Reader/ReaderPage2',
              params: {
                bookData: this.bookData,
                //后续持久化后再获取已经读到的章节序号，目前先传默认的0
                clickBookChapter: 0,
                txtFile: this.txtFiles
              }
            })
            if (this.txtFiles && this.txtFile.getListData()[0]) {
              this.jumpReadPage(`${this.txtFile.getListData()[0].chapterTitleNumber} ${this.txtFile.getListData()[0].title}`,0)
            }
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
        .color(this.theme.mainColor)
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
        Image(this.bookData.coverUrl)
          .alt($r('app.media.icon_book_default_cover_ten'))
          .width(CommonConstants.NOVEL_IMG_WIDTH)
          .height(CommonConstants.NOVEL_IMG_HEIGHT)
          .borderRadius(5)
        Column({ space: 8 }) {
          Text(this.bookData.bookName.replace(new RegExp('\\..*', 'g'), ''))
            .width('75%')
            .maxLines(2)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .fontColor(Color.White)
            .fontSize(20)
          Blank()
          Row() {
            Text(this.bookData.author ?? '卖报小郎君')
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
        Text(this.bookData.intro ?? '《大奉打更人》（第一卷）实体书已在天猫、当当、京东等全平台，以及各个实体书店发售。 这个世界，有儒；有道；有佛；有妖；有术士。 警校毕业的许七安幽幽醒来，发现自己身处牢狱之中，三日后流放边陲..... ' +
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
  // @StorageLink('BOOK_IS_BOOK_HISTORY_REFRESHING') isBookHistoryRefreshing: number = 0
  //跳转阅读界面更新或者添加阅读历史记录方法
  async jumpReadPage(durChapterTitle:string,durChapterIndex:number) {
    let bookHistory = new BookHistory()
    bookHistory.id = this.bookData.id
    bookHistory.bookName = this.bookData.bookName
    bookHistory.author = this.bookData.author
    bookHistory.durChapterTime = Date.now()
    bookHistory.bookType = this.bookData.bookType
    bookHistory.bookUrl = this.bookData.bookUrl??''
    bookHistory.coverUrl = this.bookData.coverUrl??''
    bookHistory.originBookId = this.bookData.id
    bookHistory.durChapterTitle = durChapterTitle
    bookHistory.durChapterIndex = durChapterIndex
    bookHistoryUtils.addBooks(bookHistory)
  }
}