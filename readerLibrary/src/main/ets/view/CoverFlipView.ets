import { Constants } from '../common/constants/Constants';
import { Reader } from './Reader';
import { promptAction } from '@kit.ArkUI';
import { ReaderChapterItem } from '../common/entity/ReaderChaptersItem';

@Component
export struct CoverFlipView {
  @State offsetX: number = 0
  @Consume('screenW') screenW: number;
  @Link currentPageIndex: number;
  @Consume('chapterList') chapterList: ReaderChapterItem[];
  @Link currentChapterIndex: number;
  private isFirst: boolean = false;

  build() {
    Stack() {
      if (this.chapterList.length === 0 || this.chapterList[this.currentChapterIndex].chapterPageList.length === 0) {
        Reader({ content: '' })
      } else {
        if (this.currentPageIndex + 1 < this.chapterList[this.currentChapterIndex].chapterPageList.length) {
          Reader({
            content: this.chapterList[this.currentChapterIndex].chapterPageList[this.currentPageIndex+1].content
          })
        }

        Reader({ content: this.chapterList[this.currentChapterIndex].chapterPageList[this.currentPageIndex].content })
          .translate({ x: this.offsetX >= 0 ? 0 : this.offsetX, y: 0, z: 0 })
          .width(this.screenW)

        if (this.currentPageIndex >= 1) {
          Reader({
            content: this.chapterList[this.currentChapterIndex].chapterPageList[this.currentPageIndex-1].content
          })
            .translate({
              x: -this.screenW + this.offsetX
            })
        }
      }
    }
    .gesture(
      PanGesture()
        .onActionUpdate((event?: GestureEvent) => {
          if (!event) {
            return;
          }
          if (this.currentPageIndex == 0 && event.offsetX > 0) {
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
                this.currentPageIndex -= 1;
                // if (this.currentStartIndex !== 0) {
                //   this.currentStartIndex -= this.sumRow * this.rowWord;
                // }
              }
              if (this.offsetX < 0) {
                this.currentPageIndex += 1;
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