import { BGColorType, BG_COLOR_ARRAY, Constants, FlipPageType } from '../common/constants/Constants';
import { ReaderChapterItem, ReaderChapterPageItem } from '../common/entity/ReaderChaptersItem';
import { NovelContentParseHelper } from '../common/helper/NovelContentParseHelper';
import { display } from '@kit.ArkUI';

@Component
export struct ReaderProvider {
  @BuilderParam child: () => void // 通用组件
  fontSize: number = Constants.INIT_FONT_SIZE
  lineHeightRatio: number = Constants.INIT_LINE_HEIGHT_RATIO
  bgColor: string = BG_COLOR_ARRAY[BGColorType.WHITE]
  currentPageIndex: number = 0
  currentChapterIndex: number = 0
  displaySize: number[] = [0, 0]
  curPosition: number = 0
  turnStyle: FlipPageType = FlipPageType.COVER_FLIP_PAGE
  chapterList: ReaderChapterItem[] = [];

  build() {
    Row() {
      ReaderConfigProvider({
        turnStyle: this.turnStyle,
        fontSize: this.fontSize,
        lineHeightRatio: this.lineHeightRatio,
        bgColor: this.bgColor,
        child: this.child,
        chapterList: this.chapterList,
        currentChapterIndex: this.currentChapterIndex
      })
    }
  }
}

@Component
struct ReaderSourceProvider {
  @BuilderParam child: () => void // 通用组件
  @Provide('chapterList') chapterList: ReaderChapterItem[] = [];
  @Consume('lineHeightRatio') @Watch('onFontSizeChange') lineHeightRatio: number
  @Consume('fontSize') @Watch('onFontSizeChange') fontSize: number
  @Consume('displaySize') @Watch('calChapterContent') displaySize: number[]
  @Consume('currentChapterIndex') currentChapterIndex: number
  @Consume('paragraphSpacing') paragraphSpacing: number

  onFontSizeChange() {
    this.calChapterContent()
  }

  calChapterContent() {
    let width = this.displaySize[0];
    let height = this.displaySize[1];

    if (width !== 0 && height !== 0 && this.chapterList.length !== 0) {
      NovelContentParseHelper.calculateChapterContent(this.chapterList[this.currentChapterIndex].chapterList,
        this.fontSize,
        this.fontSize * this.lineHeightRatio, width, height).then((chapterList) => {
        let startIndex = 0
        this.chapterList[this.currentChapterIndex].chapterPageList = chapterList.map((item) => {
          let contentLength = item.reduce((accumulator, currentString) => {
            return accumulator + currentString.length;
          }, 0)
          let result = new ReaderChapterPageItem(startIndex, startIndex + contentLength, item);
          startIndex += contentLength;
          return result
        })
        this.chapterList = Array.from(this.chapterList)
      }).catch((reason: string) => {
        console.log(reason);
      });
    }

  }

  aboutToAppear(): void {
  }

  build() {
    Row() {
      this.child()
    }
  }
}

@Component
struct ReaderConfigProvider {
  @BuilderParam child: () => void // 通用组件
  @Provide('turnStyle') turnStyle: FlipPageType = FlipPageType.COVER_FLIP_PAGE;
  @Provide('fontSize') fontSize: number = Constants.INIT_FONT_SIZE;
  @Provide('currentLuminance') currentLuminance: number = 0 // 亮度
  @Provide('lineHeightRatio') lineHeightRatio: number = Constants.INIT_LINE_HEIGHT_RATIO;
  @Provide('bgColor') bgColor: string = BG_COLOR_ARRAY[BGColorType.WHITE];
  @Provide('paragraphSpacing') paragraphSpacing: number = 0;
  chapterList: ReaderChapterItem[] = [];
  currentChapterIndex: number = 0;

  build() {
    Row() {
      ReaderStatusProvider({
        child: this.child,
        chapterList: this.chapterList,
        currentChapterIndex: this.currentChapterIndex
      })
    }
  }
}

@Component
struct ReaderStatusProvider {
  @BuilderParam child: () => void // 通用组件
  @Provide('curPosition') curPosition: number = 0;
  @Provide('currentPageIndex') currentPageIndex: number = 0;
  @Provide('currentChapterIndex') currentChapterIndex: number = 0;
  @Provide('displaySize') displaySize: number[] = [0, 0];
  @Provide('screenH') screenH: number = 0;
  @Provide('screenW') screenW: number = 0;
  chapterList: ReaderChapterItem[] = [];

  constructor() {
    super();
  }

  aboutToAppear(): void {
    this.screenW = px2vp(display.getDefaultDisplaySync().width);
    this.screenH = px2vp(display.getDefaultDisplaySync().height - (AppStorage.get('avoidHeight') as number));
  }

  build() {
    Row() {
      ReaderSourceProvider(
        { chapterList: this.chapterList, child: this.child }
      )
    }
  }
}