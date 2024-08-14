import { promptAction } from '@kit.ArkUI';
import { Constants } from '../common/constants/Constants';
import { ReaderChapterItem } from '../common/entity/ReaderChaptersItem';
import { Reader } from './Reader';

@Component
export struct SlideFlipView {
  @Consume('offsetX') offsetX: number;
  @Consume('sumRow') sumRow: number;
  @Consume('rowWord') rowWord: number;
  @Consume('screenW') screenW: number;
  @Consume('chapterList') chapterList: ReaderChapterItem[];
  @Link currentPageNum: number;
  @Link currentChapterNum: number;
  private isFirst: boolean = false;

  build() {
    Stack() {
      if (this.currentPageNum + 1 < this.chapterList[this.currentChapterNum].chapterPageList.length) {
        Reader({ content: this.chapterList[this.currentChapterNum].chapterPageList[this.currentPageNum+1].content })
      }

      Reader({ content: this.chapterList[this.currentChapterNum].chapterPageList[this.currentPageNum].content })
        .translate({ x: this.offsetX, y: 0, z: 0 })
        .width(this.screenW)

      if (this.currentPageNum > 1) {
        Reader({ content: this.chapterList[this.currentChapterNum].chapterPageList[this.currentPageNum-1].content })
          .translate({ x: this.offsetX >= 0 ? -this.screenW + this.offsetX : -this.screenW, y: 0, z: 0 })

      }

    }
    .gesture(
      PanGesture()
        .onActionUpdate((event?: GestureEvent) => {
          if (!event) {
            return;
          }
          if (this.currentPageNum <= 1 && event.offsetX > 0) {
            this.isFirst = true;
            return;
          }

          this.offsetX = event.offsetX;
        })
        .onActionEnd(() => {
          animateTo({
            duration: Constants.FLIP_DURATION,
            curve: Curve.EaseOut,
            onFinish: () => {
              if (this.offsetX > 0) {
                this.currentPageNum -= 1;
                // if (this.currentStartIndex !== 0) {
                //   this.currentStartIndex -= this.sumRow * this.rowWord;
                // }
              }
              if (this.offsetX < 0) {
                this.currentPageNum += 1;
                // this.currentStartIndex += this.sumRow * this.rowWord;
              }
              if (this.isFirst) {
                promptAction.showToast({
                  message: Constants.MSG_FLIP_OVER,
                  duration: Constants.PROMPT_DURATION
                });
                this.isFirst = false;
              }
              this.offsetX = 0;
            }
          }, () => {
            if (this.offsetX > 0) {
              this.offsetX = this.screenW;
            }
            if (this.offsetX < 0) {
              this.offsetX = -this.screenW;
            }
          })
        })
    )
  }
}