import { promptAction } from '@kit.ArkUI';
import { BG_COLOR_ARRAY, Constants } from '../common/constants/Constants';
import { ReaderChapterItem } from '../common/entity/ReaderChaptersItem';
import { Reader } from './Reader';

@Component
export struct UpDownFlipView {
  @State @Watch('onChangeY') translateY2: number = 0;
  @Link currentChapterNum: number;
  @Consume('offsetY') offsetY: number;
  @Consume('sumRow') sumRow: number;
  @Consume('rowWord') rowWord: number;
  @Consume('screenW') screenW: number;
  @Consume('screenH') screenH: number;
  @Link currentPageNum: number;
  @Consume('bgColorIndex') bgColorIndex: number;
  @Consume('chapterList') chapterList: ReaderChapterItem[];
  private isFirst: boolean = false;

  aboutToDisappear(): void {
    this.offsetY = 0;
  }

  onChangeY() {
    if (this.translateY2 <= -this.screenH) {
      // this.currentStartIndex += (this.sumRow * this.rowWord);
      this.translateY2 = this.translateY2 + this.screenH;
      this.currentPageNum += 1;
      this.offsetY = 0;
      return;
    }
    if (this.translateY2 >= this.screenH) {
      // this.currentStartIndex -= (this.sumRow * this.rowWord);
      this.translateY2 = this.translateY2 - this.screenH;
      this.currentPageNum -= 1;
      this.offsetY = 0;
      return;
    }
  }

  build() {
    Row()

    // Stack() {
    //   Reader({ startIndex: this.currentStartIndex + 2 * this.sumRow * this.rowWord })
    //     .translate({ x: 0, y: this.translateY2 + 2 * this.screenH + this.offsetY, z: 0 })
    //
    //   Reader({ startIndex: this.currentStartIndex + this.sumRow * this.rowWord })
    //     .translate({ x: 0, y: this.translateY2 + this.screenH + this.offsetY, z: 0 })
    //
    //   Reader({ startIndex: this.currentStartIndex })
    //     .translate({ x: 0, y: this.translateY2 + this.offsetY, z: 0 })
    //     .width(this.screenW)
    //
    //   if (this.currentPageNum > 1) {
    //     Reader({ startIndex: this.currentStartIndex - this.sumRow * this.rowWord })
    //       .translate({ x: 0, y: this.translateY2 - this.screenH + this.offsetY, z: 0 })
    //   }
    //
    //   if (this.currentPageNum > 2) {
    //     Reader({ startIndex: this.currentStartIndex - 2 * this.sumRow * this.rowWord })
    //       .translate({ x: 0, y: this.translateY2 - 2 * this.screenH + this.offsetY, z: 0 })
    //   }
    //
    //   Row()
    //     .backgroundColor(BG_COLOR_ARRAY[this.bgColorIndex])
    //     .width(Constants.FULL_PERCENT)
    //     .height(AppStorage.get('stateHeight') as number)
    //     .translate({
    //       x: 0,
    //       y: -(AppStorage.get('stateHeight') as number),
    //       z: 0
    //     })
    // }
    // .gesture(
    //   PanGesture()
    //     .onActionUpdate((event?: GestureEvent) => {
    //       if (!event) {
    //         return;
    //       }
    //
    //       // The first page slides down, and the prompt slides to the top.
    //       if (this.currentPageNum === 1 && this.translateY2 === 0 && event.offsetY > 0 && this.offsetY === 0) {
    //         this.isFirst = true;
    //         return;
    //       }
    //
    //       // The first page has been overwritten,
    //       // and the underwriting distance is limited when the next page is overwritten.
    //       if (this.currentPageNum === 1 && this.translateY2 + event.offsetY > 0 && event.offsetY > 0) {
    //         this.offsetY = -this.translateY2;
    //         return;
    //       }
    //
    //       // Part of the second page has been underlined.
    //       // When underlining again, the underlining distance shall be limited.
    //       if (this.currentPageNum === 2 && this.translateY2 + event.offsetY >= this.screenH) {
    //         this.offsetY = this.screenH - this.translateY2;
    //         return;
    //       }
    //
    //       this.offsetY = event.offsetY;
    //     })
    //     .onActionEnd(() => {
    //       if (this.isFirst) {
    //         promptAction.showToast({
    //           message: Constants.MSG_FLIP_OVER,
    //           duration: Constants.PROMPT_DURATION
    //         });
    //         this.isFirst = false;
    //       }
    //       if (this.currentPageNum === 1 && this.translateY2 === 0 && this.offsetY > 0) {
    //         return;
    //       }
    //       this.translateY2 += this.offsetY;
    //       this.offsetY = 0;
    //     })
    // )
    // .alignContent(Alignment.TopStart)
  }
}