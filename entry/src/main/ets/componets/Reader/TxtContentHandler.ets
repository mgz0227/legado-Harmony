//todo: Text方案，用原生Text组件渲染
// import { display } from '@kit.ArkUI';
// import { LengthMetrics } from '@ohos.arkui.node';
// import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
//
// @Component
// export struct TxtContentHandler {
//   @StorageLink('WindowHeight') WindowHeight: number = 0
//   @StorageLink('WindowWidth') WindowWidth: number = 0
//   @State txtChapterContent: string = ''; // 当前章节的文本
//   @State txtShowContent: string = ''; // 当前章节的文本
//   @State ContentHeight: number = 0
//   @Prop txtFile: chaptersItem[] = [];
//   @Prop CurrentChapters: number = 0;
//   @Prop LineHeight: string = '';
//   @Prop CurrentFontSize: number = 0;
//   @Prop ParagraphSpacing: number = 0;
//   private settings: RenderingContextSettings = new RenderingContextSettings(true);
//   private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
//
//   aboutToAppear() {
//     display.on('foldDisplayModeChange', () => {
//       let defaultDisplay = display.getDefaultDisplaySync()
//       this.WindowHeight = px2vp(defaultDisplay.height)
//       this.WindowWidth = px2vp(defaultDisplay.width)
//       console.log('WindowHeight:' + this.WindowHeight)
//       console.log('WindowWidth:' + this.WindowWidth)
//       // this.drawText(this.startIndex);
//     });
//   }
//
//   aboutToDisappear(): void {
//     display.off('foldDisplayModeChange');
//   }
//
//   drawText() {
//     // this.txtChapterContent = this.txtFile[this.CurrentChapters]?.content
//     // console.log('content:' + JSON.stringify(this.txtChapterContent))
//     // console.log('WindowHeight:' + this.WindowHeight)
//     // console.log('WindowWidth:' + this.WindowWidth)
//     // if (this.ContentHeight < this.WindowHeight) {
//     //
//     // }
//   }
//
//   build() {
//     Text(this.txtFile[this.CurrentChapters.toFixed(0)]?.content)
//       .lineHeight(this.LineHeight)
//       .font({
//         size: this.CurrentFontSize, // 用px感觉太小了，用vp算了
//         weight: 400
//       })
//       .lineSpacing(LengthMetrics.vp(this.CurrentFontSize + this.ParagraphSpacing))
//       .fontColor("rgba(0, 0, 0, 0.88)")
//       .width("100%")
//   }
// }

// todo: Canvas方案，按行拆分，行内按字拆分，chatgpt-4o的方案
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';

@Component
export struct TxtContentHandler {
  @Prop txtFile: chaptersItem[] = [];
  @Prop @Watch('CurrentChaptersChange') CurrentChapters: number = 0;
  @Prop @Watch('CurrentFontSizeChange') CurrentFontSize: number = 0;
  @Prop LineHeight: number = 1.8; // 百分比
  @Prop ParagraphSpacing: number = 0;
  @Prop ReaderPadding: number = 0;
  @State lines: string[] = [];
  @State currentPage: number = 0;
  @State ShowHeight: number = 0
  @State ShowWidth: number = 0
  @State linesPerPage: number = 0;
  @State isChangeTimer: number = 0;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  // 获取总页数
  GetTotalPages() {
    return Math.floor(this.lines.length / this.linesPerPage);
  }

  CurrentChaptersChange() {
    this.currentPage = 0
    this.prepareText()
    this.drawPage();
    console.log('currentPage:' + this.currentPage + '\ntotalPages:' + this.GetTotalPages())
  }

  CurrentFontSizeChange() {
    console.log('isCurrentFontSizeChangeTimer:' + this.isChangeTimer)
    this.drawPage();

    if (this.isChangeTimer) {
      // 防抖
      clearTimeout(this.isChangeTimer)
    }

    this.isChangeTimer = setTimeout(() => {
      this.prepareText()
      this.drawPage();
      console.log('currentPage:' + this.currentPage + '\ntotalPages:' + this.GetTotalPages())
    }, 1000)
  }

  prepareText() {
    this.context.font = `${vp2px(this.CurrentFontSize)}px`;
    this.lines = this.wrapText(this.context, this.ShowWidth);
    this.linesPerPage = Math.floor(this.ShowHeight / (this.CurrentFontSize * this.LineHeight));
  }

  drawPage() {
    if (this.context) {
      this.context.clearRect(0, 0, this.ShowWidth, this.ShowHeight);
      this.context.font = `${vp2px(this.CurrentFontSize)}px`;
      this.context.fillStyle = 'black';

      const start = this.currentPage * this.linesPerPage;
      const end = start + this.linesPerPage;
      const pageLines = this.lines.slice(start, end);
      console.log('当前页面渲染内容:' + JSON.stringify(pageLines)) // 当前页面需求渲染的内容
      pageLines.forEach((line, index) => {
        this.context.fillText(line, 0, (index + 1) * this.CurrentFontSize * Number(this.LineHeight));
      });
    }
  }

  // 当前章节内容按字分割
  // todo:当前一次性分割一整个章节的文字，需要大佬优化
  wrapText(context: CanvasRenderingContext2D, maxWidth: number = this.ShowWidth) {
    const paragraphs = this.txtFile[this.CurrentChapters]?.content.split('\n');
    const lines: string[] = [];
    console.log('paragraphs:' + JSON.stringify(paragraphs))

    paragraphs.forEach(paragraph => {
      const words = paragraph.split(''); // todo:这里性能缓慢，需要优化
      let currentLine = words[0];

      for (let i = 1; i < words.length; i++) {
        const word = words[i];
        const width = context.measureText(currentLine + ' ' + word).width;
        if (width < maxWidth) {
          currentLine += ' ' + word;
        } else {
          lines.push(currentLine);
          currentLine = word;
        }
      }
      lines.push(currentLine);
    });
    return lines;
  }

  nextPage() {
    if (this.currentPage < this.GetTotalPages()) {
      this.currentPage++;
      console.log('currentPage:' + this.currentPage + '\ntotalPages:' + this.GetTotalPages())
      this.drawPage();
    }
  }

  prevPage() {
    if (this.currentPage > 0) {
      this.currentPage--;
      console.log('prevPage:' + this.currentPage)
      this.drawPage();
    }
  }

  build() {
    Column() {
      Canvas(this.context)
        .width("100%")
        .layoutWeight(1)
        .borderWidth(1)
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          this.ShowHeight = Number(newValue.height)
          this.ShowWidth = Number(newValue.width)
          this.drawPage()

          if (this.isChangeTimer) {
            // 防抖
            clearTimeout(this.isChangeTimer)
          }
          this.isChangeTimer = setTimeout(() => {
            this.prepareText()
            this.drawPage();
            console.log('currentPage:' + this.currentPage + '\ntotalPages:' + this.GetTotalPages())
          }, 1000)

          console.log('ShowHeight:' + this.ShowHeight)
          console.log('ShowWidth:' + this.ShowWidth)
          console.log('currentPage:' + this.currentPage + '\ntotalPages:' + this.GetTotalPages())
        })
      Row() {
        Button('上一页')
          .onClick(() => {
            this.prevPage()
          })
          .backgroundColor(this.currentPage > 0 ? 'blue' : 'gray')

        Button('下一页')
          .onClick(() => {
            this.nextPage()
          })
          .backgroundColor(this.currentPage < this.GetTotalPages() ? 'blue' : 'gray')
      }
      .borderWidth(1)
      .margin({ top: 10 })
    }
  }
}