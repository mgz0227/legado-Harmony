// Canvas方案，按行拆分，行内按字拆分
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';

@Component
export struct TxtContentHandler {
  @Prop txtFile: chaptersItem[] = [];
  @Prop @Watch('CurrentChaptersChange') CurrentChapters: number = 0;
  @Prop @Watch('CurrentFontSizeChange') CurrentFontSize: number = 0;
  @Prop LineHeight: number = 1.8;
  @Prop ParagraphSpacing: number = 0;
  @State currentPage: number = 0;
  @State ShowHeight: number = 0
  @State ShowWidth: number = 0
  @State linesPerPage: number = 0;
  @State timer: number = 0;
  @State offsetX: number = 0;
  @State CurrentChaptersContent: Array<string> = []; // 当前章节内容
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right })

  // 获取总页数
  GetTotalPages() {
    return Math.floor(this.CurrentChaptersContent.length / this.linesPerPage);
  }

  CurrentChaptersChange() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.currentPage = 0
      this.wrapText(this.context, this.ShowWidth);
      console.log('CurrentChapters:' + this.CurrentChapters)
      console.log('currentPage:' + this.currentPage)
      console.log('totalPages:' + this.GetTotalPages())
    }, 200)
  }

  CurrentFontSizeChange() {
    this.drawPage()
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.wrapText(this.context, this.ShowWidth);
      if (this.currentPage > this.GetTotalPages()) {
        console.log('currentPage:' + this.currentPage)
        this.currentPage = this.GetTotalPages()
        this.drawPage()
      }
      console.log('CurrentFontSize:' + this.CurrentFontSize)
      console.log('totalPages:' + this.GetTotalPages())
    }, 200)
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
      const CurrentPageLines = this.CurrentChaptersContent.slice(start, end);

      // 上一页和下一页的内容
      const PreStart = start - this.linesPerPage;
      const NextEnd = start + this.linesPerPage * 2;
      const PrePageLines = this.CurrentChaptersContent.slice(PreStart, start);
      const NextPageLines = this.CurrentChaptersContent.slice(end, NextEnd);
      CurrentPageLines.forEach((line, index) => {
        this.context.fillText(line, 0 + this.offsetX, (index + 1) * this.CurrentFontSize * Number(this.LineHeight));
      });

      // 下一页内容
      PrePageLines.forEach((line, index) => {
        this.context.fillText(line, 0 - this.ShowWidth + this.offsetX,
          (index + 1) * this.CurrentFontSize * Number(this.LineHeight));
      });

      // 下一页内容
      NextPageLines.forEach((line, index) => {
        this.context.fillText(line, this.ShowWidth + this.offsetX,
          (index + 1) * this.CurrentFontSize * Number(this.LineHeight));
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

  build() {
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
      .gesture(
        PanGesture(this.panOption)
          .onActionUpdate((event?: GestureEvent) => {
            if (!event) {
              return;
            }
            this.offsetX = event.offsetX;
            this.drawPage();
          })
          .onActionEnd((event: GestureEvent) => {
            console.log('currentPage:' + this.currentPage)
            if (event.offsetX > 200 && this.currentPage > 0) {
              this.currentPage--;
              console.log('prevPage')
              this.offsetX = 0
              this.drawPage();
            } else if (event.offsetX < -200 && this.currentPage < this.GetTotalPages()) {
              this.currentPage++;
              console.log('nextPage')
              this.offsetX = 0
              this.drawPage();
            } else {
              this.offsetX = 0
              this.drawPage();
            }
          })
      )
  }
}