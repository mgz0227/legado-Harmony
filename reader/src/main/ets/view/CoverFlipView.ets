import { Constants } from '../common/constants/Constants';
import { Reader } from './Reader';
import { promptAction } from '@kit.ArkUI';
import { ReaderChapterItem } from '../common/constants/ReaderChaptersItem';

@Component
export struct CoverFlipView {
  @State offsetX: number = 0
  @Consume('screenW') screenW: number;
  @Link currentPageNum: number;
  @Consume('chapterList') chapterList: ReaderChapterItem[];
  @Link currentChapterNum: number;
  private isFirst: boolean = false;

  build() {
    Stack() {
      if (this.chapterList[this.currentChapterNum].chapterPageList.length === 0) {
        Reader({ content: '' })
      } else {
        if (this.currentPageNum + 1 < this.chapterList[this.currentChapterNum].chapterPageList.length) {
          Reader({ content: this.chapterList[this.currentChapterNum].chapterPageList[this.currentPageNum+1].content })
        }

        Reader({ content: this.chapterList[this.currentChapterNum].chapterPageList[this.currentPageNum].content })
          .translate({ x: this.offsetX >= 0 ? 0 : this.offsetX, y: 0, z: 0 })
          .width(this.screenW)

        if (this.currentPageNum >= 1) {
          Reader({ content: this.chapterList[this.currentChapterNum].chapterPageList[this.currentPageNum-1].content })
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
          if (this.currentPageNum == 0 && event.offsetX > 0) {
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