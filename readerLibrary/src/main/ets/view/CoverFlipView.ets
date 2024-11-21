import { Constants } from '../common/constants/Constants';
import { Reader } from './Reader';
import { promptAction } from '@kit.ArkUI';
import { ReaderChapterItem } from '../common/entity/ReaderChaptersItem';
import { NovelChapterOperateHelper } from '../common/helper/NovelChapterOperateHelper';

@Component
export struct CoverFlipView {
  @State offsetX: number = 0
  @Consume('screenW') screenW: number;
  @Link currentPageIndex: number;
  @Consume('chapterList') @Watch('calPageIndex') chapterList: ReaderChapterItem[];
  @Link currentChapterIndex: number;
  private isFirst: boolean = false;

  @State nextPageIndex: number[] | null = null;
  @State prePageIndex: number[] | null = null;

  aboutToAppear(): void {
    this.calPageIndex();
  }

  calPageIndex() {
    this.nextPageIndex =
      NovelChapterOperateHelper.nextPageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);
    this.prePageIndex =
      NovelChapterOperateHelper.prePageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);
  }

  build() {
    Stack() {
      if (this.chapterList.length === 0 || this.chapterList[this.currentChapterIndex].chapterPageList.length === 0) {
        Reader({ content: '' })
      } else {
        if (this.nextPageIndex !== null) {
          Reader({
            content: this.chapterList[this.nextPageIndex[0]].chapterPageList[this.nextPageIndex[1]].content
          })
        }

        Reader({ content: this.chapterList[this.currentChapterIndex].chapterPageList[this.currentPageIndex].content })
          .translate({ x: this.offsetX >= 0 ? 0 : this.offsetX, y: 0, z: 0 })
          .width(this.screenW)

        if (this.prePageIndex != null) {
          Reader({
            content: this.chapterList[this.prePageIndex[0]].chapterPageList[this.prePageIndex[1]].content
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
          let prePageIndex =
            NovelChapterOperateHelper.prePageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);
          let nextPageIndex =
            NovelChapterOperateHelper.nextPageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);

          if (!event) {
            return;
          }
          if (prePageIndex === null && event.offsetX > 0) {
            this.isFirst = true;
            return;
          }

          if (nextPageIndex === null && event.offsetX < 0) {
            return;
          }
          this.offsetX = event.offsetX;
        })
        .onActionEnd(() => {
          animateTo({
            duration: Constants.FLIP_DURATION,
            curve: Curve.EaseOut,
            onFinish: () => {
              this.calPageIndex();
              if (this.offsetX > 0) {
                this.currentChapterIndex = (this.prePageIndex as number[])[0]
                this.currentPageIndex = (this.prePageIndex as number[])[1]
              }
              if (this.offsetX < 0) {
                this.currentChapterIndex = (this.nextPageIndex as number[])[0]
                this.currentPageIndex = (this.nextPageIndex as number[])[1]
              }
              if (this.isFirst) {
                promptAction.showToast({
                  message: Constants.MSG_FLIP_OVER,
                  duration: Constants.PROMPT_DURATION
                });
                this.isFirst = false;
              }
              this.offsetX = 0;
              this.calPageIndex();
            }
          }, () => {
            if (this.offsetX > 0) {
              this.offsetX = this.screenW;
            }
            if (this.offsetX < 0) {
              this.offsetX = -this.screenW;
            }
            this.calPageIndex();
          })
        })
    )

  }
}