import Dialog from 'ets/componets/common/Dialog';
import { display, router } from '@kit.ArkUI';
import sourceView from './sourceView';
import DownloadSettingDialog from '../../../componets/Reader/DownloadSettingDialog';
import LayoutMoreDialog from '../../../componets/Reader/LayoutMoreDialog';
import { MusicPlayer } from 'ets/componets/Reader/MusicPlayer';
import purificationView from './purificationView';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { BookList } from 'ets/componets/dataList/bookList';
import { bookParser, readerCore, ReadPageComponent } from '@kit.ReaderKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface ParamsObj {
  bookData: BookList,
  clickBookChapter: number,
  txtFile: chaptersItem[]
}

//2025.4.19 改用官方API16的 ReaderKit
@Entry
@Component
struct ReaderPage3 {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State ReaderPadding: number = 24 // 边距
  @State isShowSetting: boolean = true
  @State isShowDownload: boolean = false
  @State isShowListen: boolean = false
  @State isShowContentSetting: boolean = false
  @State isShowMoreLayout: boolean = false
  @State CurrentChapters: number = 0
  @State TotalChapters: number = 0
  @State CurrentLuminance: number = 0 // 亮度
  @State CurrentFontSize: number = 20 // 字号
  @State LineHeight: number = 1.8
  @State ParagraphSpacing: number = -2
  @State isShowSource: boolean = false
  @State isShowPurification: boolean = false
  @State txtFile: chaptersItem[] = [];
  @State bookData: BookList | null = null;
  // 网址导入Dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: Dialog({
      title: '加入书架',
      CancelString: "暂不加入",
      ConfirmString: "加入书架",
      CancelCallback: () => {
        router.back()
      },
      ConfirmCallback: () => {
        router.back()
      },
    }),
    cornerRadius: 16,
    gridCount: 4,
    offset: { dx: 0, dy: -300 }
  })
  readerComponentController: readerCore.ReaderComponentController = new readerCore.ReaderComponentController();

  async aboutToAppear() {
    //详情页加了个目录序号参数，所以修改了一下params的类型，不影响之前的bookData，但需要多‘.’一次。看看大佬们可以怎么优化一下，上个页面BookDetailPage
    let temp = router.getParams() as ParamsObj
    this.txtFile = temp.txtFile //txt小说
    this.TotalChapters = this.txtFile.length
    this.CurrentChapters = temp.clickBookChapter
    this.bookData = temp.bookData
    this.init()
  }

  async init() {
    try {
      // 当前应用下资源的沙箱路径地址
      let path: string = this.bookData?.bookUrl ?? ''
      let bookParserHandler: bookParser.BookParserHandler = await bookParser.getDefaultHandler(path);
      let spineList: bookParser.SpineItem[] = bookParserHandler.getSpineList();
      let spineIndex: number = spineList[0].index;
      let domPos: string = '';

      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      this.readerComponentController = new readerCore.ReaderComponentController();
      await this.readerComponentController.init(context);
      this.readerComponentController.registerBookParser(bookParserHandler);


      //开始解析渲染
      this.readerComponentController.startPlay(spineIndex || 0, domPos);
    } catch (err) {
      hilog.error(0x0000, 'testTag', `failed to startPlay, Code is ${err.code}, message is ${err.message}`);
    }
  }

  build() {
    Stack() {
      ReadPageComponent({
        controller: this.readerComponentController,
        readerCallback: (err: BusinessError, data: readerCore.ReaderComponentController) => {
          this.readerComponentController = data;
        }
      }).borderWidth(1).width('100%').height('100%')
    }.width('100%').height('100%').onClick(() => {
      // 支持在此实现点击拉起菜单栏功能
    })
  }

  @Builder
  sourceView() {
    Column() {
      Column() {
        Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
      }
      .padding({ top: 12 })

      sourceView()
    }
  }

  @Builder
  purificationView() {
    Column() {
      purificationView({
        isShowPurification: this.isShowPurification
      })
    }
  }

  @Builder
  DialogString() {
    Row() {
      Text("喜欢就加入书架吧")
        .lineHeight(22)
        .font({
          size: 14,
          weight: 400
        })
        .fontColor($r("app.string.color_black_45"))
    }
    .margin({
      top: 12,
      bottom: 16
    })
  }

  onBackPress() {
    this.dialogController.open();
    return true
  }

  @Builder
  BookListen() {
    MusicPlayer({ WidthMinus: 118, isShowListen: this.isShowListen })
      .width("100%")
      .height("100%")
  }

  @Builder
  DownloadDialog() {
    Column() {
      DownloadSettingDialog({
        isShowDownload: this.isShowDownload,
        isShowSetting: this.isShowSetting,
      })
    }
  }

  @Builder
  LayoutMoreDialog() {
    LayoutMoreDialog({ ReaderPadding: this.ReaderPadding })
      .height(500)
      .width("100%")
  }
}
