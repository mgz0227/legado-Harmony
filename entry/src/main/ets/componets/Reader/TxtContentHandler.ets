// Canvas方案，按行拆分，行内按字拆分
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';

@Component
export struct TxtContentHandler {
  @Prop txtFile: chaptersItem[] = [];
  @Prop @Watch('CurrentChaptersChange') CurrentChapters: number = 0;
  @Prop @Watch('CurrentFontSizeChange') CurrentFontSize: number = 0;
  @Prop LineHeight: number = 1.8;
  @Prop ParagraphSpacing: number = 0;
  @Prop ReaderPadding: number = 0;
  @State currentPage: number = 0;
  @State ShowHeight: number = 0
  @State ShowWidth: number = 0
  @State linesPerPage: number = 0;
  @State timer: number = 0;
  @State CurrentChaptersContent: Array<string> = []; // 存放需要显示在页面上，每个章节重排段落的字符串，一层数组索引为章节，二层数组索引为段落
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  // 获取总页数
  GetTotalPages() {
    return Math.floor(this.CurrentChaptersContent.length / this.linesPerPage);
  }

  CurrentChaptersChange() {
    this.currentPage = 0
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.wrapText(this.context, this.ShowWidth);
      console.log('CurrentChapters:' + this.CurrentChapters)
      console.log('currentPage:' + this.currentPage)
      console.log('totalPages:' + this.GetTotalPages())
    }, 100)
  }

  CurrentFontSizeChange() {
    this.drawPage()
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.wrapText(this.context, this.ShowWidth);
      console.log('CurrentFontSize:' + this.CurrentFontSize)
      console.log('totalPages:' + this.GetTotalPages())
    }, 100)
  }

  drawPage() {
    this.context.font = `${vp2px(this.CurrentFontSize)}px`;
    this.linesPerPage = Math.floor(this.ShowHeight / (this.CurrentFontSize * this.LineHeight));
    if (this.context) {
      this.context.clearRect(0, 0, this.ShowWidth, this.ShowHeight);
      this.context.font = `${vp2px(this.CurrentFontSize)}px`;
      this.context.fillStyle = 'black';

      const start = this.currentPage * this.linesPerPage;
      const end = start + this.linesPerPage;
      const pageLines = this.CurrentChaptersContent.slice(start, end);
      console.log('当前页面渲染内容:' + JSON.stringify(pageLines)) // 当前页面需求渲染的内容
      pageLines.forEach((line, index) => {
        this.context.fillText(line, 0, (index + 1) * this.CurrentFontSize * Number(this.LineHeight));
      });
    }
  }

  // 当前章节内容按字分割
  wrapText(context: CanvasRenderingContext2D, maxWidth: number = this.ShowWidth) {
    let content: string = this.txtFile[this.CurrentChapters].content
    let chaptersItemLines: string[] = []
    let currentLine: string = ''
    let pattern = /\n/
    let i = 1
    while (i < content.length) {
      let temp = content[i] + content[i+1]
      if (!pattern.test(temp)) {
        if (context.measureText(currentLine + ' ' + content[i]).width < Number((this.ShowWidth - 10).toFixed(0))) {
          currentLine += content[i];
        } else {
          chaptersItemLines.push(currentLine);
          currentLine = content[i];
        }
        i++
      } else {
        chaptersItemLines.push(currentLine);
        i = i + 2
        currentLine = content[i];
      }
    }
    if (pattern.test(chaptersItemLines[chaptersItemLines.length-1])) {
      chaptersItemLines.splice(chaptersItemLines.length - 1, 1)
    }
    this.CurrentChaptersContent = chaptersItemLines
    this.drawPage();
  }

  nextPage() {
    if (this.currentPage < this.GetTotalPages()) {
      this.currentPage++;
      console.log('currentPage:' + this.currentPage)
      console.log('totalPages:' + this.GetTotalPages())
      this.drawPage();
    }
  }

  prevPage() {
    if (this.currentPage > 0) {
      this.currentPage--;
      console.log('currentPage:' + this.currentPage)
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
          this.drawPage();
          clearTimeout(this.timer)
          this.timer = setTimeout(() => {
            this.wrapText(this.context, this.ShowWidth);
          }, 100)
          console.log('ShowHeight:' + this.ShowHeight)
          console.log('ShowWidth:' + this.ShowWidth)
          console.log('totalPages:' + this.GetTotalPages())
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