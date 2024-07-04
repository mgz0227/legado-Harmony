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

// todo: Canvas方案，按字拆分,taskpool多线程处理
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { taskpool } from '@kit.ArkTS';

@Component
export struct TxtContentHandler {
  @Prop @Watch('HandleTaskPool') txtFile: chaptersItem[] = [];
  @Prop @Watch('CurrentChaptersChange') CurrentChapters: number = 0;
  @Prop @Watch('CurrentFontSizeChange') CurrentFontSize: number = 0;
  @Prop LineHeight: number = 1.8; // 百分比
  @Prop ParagraphSpacing: number = 0;
  @Prop ReaderPadding: number = 0;
  @State AllChaptersContent: Array<string>[] = [];
  @State lines: string[] = [];
  @State currentPage: number = 0;
  @State @Watch('HandleTaskPool') ShowHeight: number = 0
  @State ShowWidth: number = 0
  @State linesPerPage: number = 0;
  @State isChangeTimer: number = 0;
  @State isTaskPool: boolean = false;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  // 获取总页数
  GetTotalPages() {
    return Math.floor(this.AllChaptersContent[this.CurrentChapters]?.length / this.linesPerPage);
  }

  // 多线程处理
  HandleTaskPool() {
    setTimeout(() => {
      if (this.txtFile.length > 0 && this.ShowWidth > 0 && this.isTaskPool == false) { //需要txt文件加载和showWidth同时准备好
        this.isTaskPool = true
        let taskGroup: taskpool.TaskGroup = new taskpool.TaskGroup();
        for (let i = 0; i < this.txtFile.length; i++) {
          let dataArray: Array<string> = [
            this.txtFile[i].content,
            this.CurrentFontSize.toString(),
            this.ShowWidth.toString(),
            i.toString(),
          ]

          let task: taskpool.Task = new taskpool.Task(HandleAllChaptersContentTaskPool, dataArray);
          taskGroup.addTask(task);
        }
        taskpool.execute(taskGroup, taskpool.Priority.HIGH).then((res): void | Promise<void> => {
          // 结果数据处理
          for (let i = 0; i < this.txtFile.length; i++) {
            this.AllChaptersContent.push(((res[i]) as Array<string>[])[i] as Array<string>)
            console.log('taskpool finish:' + JSON.stringify(((res[i]) as Array<string>)[i]))
          }
        }).catch((error: Error) => {
          console.error(`taskpool excute error: ${error}`);
        })
      }
    }, 30)
  }

  CurrentChaptersChange() {
    this.currentPage = 0
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
      if (this.currentPage > this.GetTotalPages()) {
        this.currentPage = this.GetTotalPages()
      }
      this.drawPage();
      console.log('currentPage:' + this.currentPage + '\ntotalPages:' + this.GetTotalPages())
    }, 1000)
  }

  drawPage() {
    this.context.font = `${vp2px(this.CurrentFontSize)}px`;
    this.linesPerPage = Math.floor((this.ShowHeight) / (this.CurrentFontSize * this.LineHeight));
    if (this.context && this.AllChaptersContent[this.CurrentChapters]) {
      this.context.font = `${vp2px(this.CurrentFontSize)}px`;
      this.context.fillStyle = 'black';
      const start = this.currentPage * this.linesPerPage;
      const end = start + this.linesPerPage;
      const pageLines = this.AllChaptersContent[this.CurrentChapters].slice(start, end);
      console.log('当前页面渲染内容:' + JSON.stringify(pageLines)) // 当前页面需求渲染的内容
      this.context.clearRect(0, 0, this.ShowWidth, this.ShowHeight);
      pageLines.forEach((line, index) => {
        this.context.fillText(line, 0, (index + 1) * this.CurrentFontSize * Number(this.LineHeight));
      });
    }
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
        .layoutWeight(1)
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          this.ShowHeight = Number(newValue.height)
          this.ShowWidth = Number(newValue.width)
          this.drawPage()

          if (this.isChangeTimer) {
            // 防抖
            clearTimeout(this.isChangeTimer)
          }
          this.isChangeTimer = setTimeout(() => {
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

@Concurrent
function HandleAllChaptersContentTaskPool(dataArray: Array<string>) {
  let CurrentFontSize = Number(dataArray[1])
  let ShowWidth = Number(dataArray[2])
  let index = Number(dataArray[3])
  // console.log('CurrentFontSize:' + CurrentFontSize)
  // console.log('ShowWidth:' + ShowWidth)
  let content: string = dataArray[0]
  let AllChaptersContent: Array<string>[] = []
  let chaptersItemLines: string[] = []
  let currentLine: string = ''
  let pattern = /\n/
  let i = 1
  while (i < content.length) {
    let temp = content[i] + content[i+1]
    if (!pattern.test(temp)) {
      if (Number(currentLine.length + 1) * CurrentFontSize < Number((ShowWidth - 10).toFixed(0))) {
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
  // console.log('chaptersItemLines:' + JSON.stringify(chaptersItemLines[chaptersItemLines.length-1]))
  AllChaptersContent[index] = chaptersItemLines
  return AllChaptersContent

}