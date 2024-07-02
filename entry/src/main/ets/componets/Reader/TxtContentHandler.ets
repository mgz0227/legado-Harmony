import { display } from '@kit.ArkUI';
import { LengthMetrics } from '@ohos.arkui.node';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';

@Component
export struct TxtContentHandler {
  @StorageLink('WindowHeight') WindowHeight: number = 0
  @StorageLink('WindowWidth') WindowWidth: number = 0
  @State txtChapterContent: string = ''; // 当前章节的文本
  @State txtShowContent: string = ''; // 当前章节的文本
  @State ContentHeight: number = 0
  @Prop txtFile: chaptersItem[] = [];
  @Prop CurrentChapters: number = 0;
  @Prop LineHeight: string = '';
  @Prop CurrentFontSize: number = 0;
  @Prop ParagraphSpacing: number = 0;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  aboutToAppear() {
    display.on('foldDisplayModeChange', () => {
      let defaultDisplay = display.getDefaultDisplaySync()
      this.WindowHeight = px2vp(defaultDisplay.height)
      this.WindowWidth = px2vp(defaultDisplay.width)
      console.log('WindowHeight:' + this.WindowHeight)
      console.log('WindowWidth:' + this.WindowWidth)
      // this.drawText(this.startIndex);
    });
  }

  aboutToDisappear(): void {
    display.off('foldDisplayModeChange');
  }

  drawText() {
    // this.txtChapterContent = this.txtFile[this.CurrentChapters]?.content
    // console.log('content:' + JSON.stringify(this.txtChapterContent))
    // console.log('WindowHeight:' + this.WindowHeight)
    // console.log('WindowWidth:' + this.WindowWidth)
    // if (this.ContentHeight < this.WindowHeight) {
    //
    // }
  }

  build() {
    Text(this.txtFile[this.CurrentChapters.toFixed(0)]?.content)
      .lineHeight(this.LineHeight)
      .font({
        size: this.CurrentFontSize, // 用px感觉太小了，用vp算了
        weight: 400
      })
      .lineSpacing(LengthMetrics.vp(this.CurrentFontSize + this.ParagraphSpacing))
      .fontColor("rgba(0, 0, 0, 0.88)")
      .width("100%")
  }
}