import { BGColorType, BG_COLOR_ARRAY, Constants, FlipPageType } from '../common/constants/Constants';
import { ReaderChapterItem, ReaderChapterPageItem } from '../common/entity/ReaderChaptersItem';
import { NovelContentParseHelper } from '../common/helper/NovelContentParseHelper';
import { display } from '@kit.ArkUI';
import taskPool from '@ohos.taskpool';

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

@Concurrent
async function calChapterContent(width: number, height: number, targetParagraphList: string[], fontSize: number,
  lineHeightRatio: number): Promise<string[][]> {
  try {
    return await NovelContentParseHelper.calculateChapterContent(targetParagraphList,
      fontSize,
      fontSize * lineHeightRatio, width, height)
  } catch (e) {
    console.info('loadNovel 出错 ' + e)
    return [];
  }

}

@Component
struct ReaderSourceProvider {
  @BuilderParam child: () => void // 通用组件
  @Provide('chapterList') chapterList: ReaderChapterItem[] = [];
  @Consume('lineHeightRatio') @Watch('onConfigSizeChange') lineHeightRatio: number
  @Consume('fontSize') @Watch('onConfigSizeChange') fontSize: number
  @Consume('displaySize') @Watch('onDisplaySizeChange') displaySize: number[]
  @Consume('currentChapterIndex') @Watch('calChapterContent') currentChapterIndex: number
  @Consume('paragraphSpacing') @Watch('onConfigSizeChange') paragraphSpacing: number

  onConfigSizeChange() {
    this.forceCalChapterContent()
  }

  onDisplaySizeChange() {
    this.forceCalChapterContent()
  }

  private calContentOfTargetChapter(width: number, height: number, chapterIndex: number, fontSize: number,
    lineHeightRatio: number, forceUpdate: boolean) {
    if (!forceUpdate) {
      if (this.chapterList[chapterIndex].chapterPageList.length !== 0) {
        return
      }
    }
    taskPool.execute(calChapterContent, width, height, this.chapterList[chapterIndex].paragraphList, fontSize,
      lineHeightRatio).then((chapterList) => {
      if (Array.isArray(chapterList)) {
        let startIndex = 0
        let result: string[][] = chapterList as string[][]
        if (result.length !== 0) {
          this.chapterList[chapterIndex].chapterPageList = result.map((item) => {
            let contentLength = item.reduce((accumulator, currentString) => {
              return accumulator + currentString.length;
            }, 0)
            let result = new ReaderChapterPageItem(startIndex, startIndex + contentLength, item);
            startIndex += contentLength;
            return result
          })
          this.chapterList = Array.from(this.chapterList)
        }
      }
    })
  }

  calChapterContent() {
    let width = this.displaySize[0];
    let height = this.displaySize[1];

    if (width !== 0 && height !== 0 && this.chapterList.length !== 0) {
      this.calContentOfTargetChapter(width, height, this.currentChapterIndex,
        this.fontSize, this.lineHeightRatio, false);
      if (this.currentChapterIndex > 0) {
        this.calContentOfTargetChapter(width, height, this.currentChapterIndex - 1,
          this.fontSize, this.lineHeightRatio, false);
      }
      if (this.currentChapterIndex < this.chapterList.length - 1) {
        this.calContentOfTargetChapter(width, height, this.currentChapterIndex + 1,
          this.fontSize, this.lineHeightRatio, false);
      }
    }

  }

  forceCalChapterContent() {
    let width = this.displaySize[0];
    let height = this.displaySize[1];

    if (width !== 0 && height !== 0 && this.chapterList.length !== 0) {
      this.calContentOfTargetChapter(width, height, this.currentChapterIndex,
        this.fontSize, this.lineHeightRatio, true);
      if (this.currentChapterIndex > 0) {
        this.calContentOfTargetChapter(width, height, this.currentChapterIndex - 1,
          this.fontSize, this.lineHeightRatio, true);
      }
      if (this.currentChapterIndex < this.chapterList.length - 1) {
        this.calContentOfTargetChapter(width, height, this.currentChapterIndex + 1,
          this.fontSize, this.lineHeightRatio, true);
      }
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