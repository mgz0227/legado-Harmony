import { common2D, drawing } from '@kit.ArkGraphics2D';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { Constants } from '../common/constants/Constants';
import { ReaderChapterItem } from '../common/entity/ReaderChaptersItem';
import { Reader, ReaderForCurlView, SimulateDrawManager } from './Reader';
import { image } from '@kit.ImageKit';
import { NovelChapterOperateHelper } from '../common/helper/NovelChapterOperateHelper';

const NODE_CONTAINER_ID = 'root'; // 组件NodeContainer的id

@Component
export struct SimulateCurlView {
  private context: DrawingRenderingContext = new DrawingRenderingContext()
  @State
  private isOnGesture: boolean = false;
  @State
  private isOnAnimation: boolean = false;
  private isReady = false
  controller: TextController = new TextController();
  private lastTime: number | null = null
  private animatorResult: AnimatorResult | undefined | null
  @Consume('screenW') screenW: number;
  @Link currentPageIndex: number;
  @Consume('chapterList') chapterList: ReaderChapterItem[];
  @Link currentChapterIndex: number;
  @Consume('fontSize') fontSize: number;
  @Consume('lineHeightRatio') lineHeightRatio: number;
  @Consume('bgColor') bgColor: string;
  @Provide('batteryPixelMap') @Watch('setBatteryPixelMap') batteryPixelMap: image.PixelMap | null = null;
  @Consume('displaySize') @Watch('onTextDisplaySizeChanged') displaySize: number[];
  drawManager: SimulateDrawManager | null = null;
  isTurnNext: boolean | null = null;
  animationEndValue: number | null = null;
  @State nextPageIndex: number[] | null = null;
  @State prePageIndex: number[] | null = null;

  calPageIndex() {
    this.nextPageIndex =
      NovelChapterOperateHelper.nextPageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);
    this.prePageIndex =
      NovelChapterOperateHelper.prePageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);
  }

  aboutToDisappear(): void {
    this.animatorResult = undefined;
  }

  aboutToAppear(): void {
    this.drawManager =
      new SimulateDrawManager(this.context, this.fontSize, this.fontSize * this.lineHeightRatio, this.chapterList,
        this.currentChapterIndex, this.currentPageIndex, this.bgColor);
    this.drawManager.setTextDisplaySize(this.displaySize)
    let options: AnimatorOptions = {
      duration: 300,
      easing: "linear",
      delay: 0,
      fill: "none",
      direction: "normal",
      iterations: 1,
      begin: 0.0,
      end: 1.0
    };
    this.animatorResult = animator.create(options)
    this.animatorResult.onFinish = () => {
      console.info(`animation: onFinish callback time is ${Date.now()}`)
      this.isOnAnimation = false;
      if (this.drawManager !== null) {
        this.drawManager.dispatchPointerUPEvent();
      }
      if (this.isTurnNext && this.animationEndValue === 1.0) {
        let nextPageIndex =
          NovelChapterOperateHelper.nextPageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);
        if (nextPageIndex != null) {
          this.currentChapterIndex = nextPageIndex![0];
          this.currentPageIndex = nextPageIndex![1];
          this.drawManager?.updatePageIndex(this.currentPageIndex, this.currentChapterIndex)
        }

      } else if (!this.isTurnNext && this.animationEndValue === -1.0) {
        let prePageIndex =
          NovelChapterOperateHelper.prePageIndex(this.chapterList, this.currentChapterIndex, this.currentPageIndex);
        if (prePageIndex != null) {
          this.currentChapterIndex = prePageIndex![0];
          this.currentPageIndex = prePageIndex![1];
          this.drawManager?.updatePageIndex(this.currentPageIndex, this.currentChapterIndex)
        }
      }
      this.isTurnNext = null;
      this.animationEndValue = null;
      this.calPageIndex();
    }
    this.animatorResult.onFrame = (progress) => {
      console.info(`animation: onFrame callback time is ${Date.now()} , progress : ${progress}}`)
      if (this.drawManager !== null) {
        this.drawManager.applyAnimationProgressToTouch(progress);
        this.drawManager.draw()
      }
    };
    this.calPageIndex();
  }

  setBatteryPixelMap() {
    if (this.drawManager !== null && this.batteryPixelMap !== null) {
      this.drawManager.setBatteryPixelMap(this.batteryPixelMap)
    }
  }

  onTextDisplaySizeChanged() {
    if (this.drawManager !== null) {
      this.drawManager.setTextDisplaySize(this.displaySize)
    }
  }

  startAnimation(isRecover: boolean, isTurnNext: boolean) {
    this.animationEndValue = (isTurnNext !== isRecover) ? 1.0 : -1.0;
    let options: AnimatorOptions = {
      duration: 300,
      easing: "linear",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: 1,
      begin: 0.0,
      end: this.animationEndValue
    };
    this.animatorResult?.cancel();
    this.animatorResult?.reset(options);
    this.animatorResult?.play();
    this.isOnAnimation = true;
  }

  build() {

    Stack() {

      if (this.chapterList[this.currentChapterIndex].chapterPageList.length === 0) {
        Reader({ content: '' })
      } else {
        Canvas(this.context)
          .width(Constants.FULL_PERCENT)
          .height(Constants.FULL_PERCENT)
          .id(NODE_CONTAINER_ID)
          .onReady(() => {
            console.info('canvas need draw')
            this.isReady = true;
            if (this.drawManager !== null) {
              if (!this.drawManager.canvasSize.isEmpty() && !this.drawManager.touch.offset.isEmpty()) {
                this.drawManager.draw()
              }
            }
          })

        ReaderForCurlView({
          content: this.chapterList[this.currentChapterIndex].chapterPageList[this.currentPageIndex].content
        })
          .width(Constants.FULL_PERCENT)
          .height(Constants.FULL_PERCENT)
          .visibility(this.isOnGesture || this.isOnAnimation ? Visibility.None : Visibility.Visible)
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
    .gesture(
      PanGesture()
        .onActionStart((event) => {
          console.info('PanGesture:start');

          if (this.drawManager !== null) {
            this.drawManager.dispatchPointerStart(event)
          }
        })
        .onActionUpdate((event) => {
          console.info(`绘制事件耗时:绘制事件发生,timeStamp:${Date.now()},间隔：${Date.now() - (this.lastTime ?? 0)}`)
          this.lastTime = Date.now();
          try {
            let startTime = Date.now();
            console.info('PanGesture:update');

            if (this.drawManager !== null) {
              this.isTurnNext = this.drawManager.dispatchPointerMoveEvent(event)
              if (this.isTurnNext != null) {
                this.isOnGesture = true;
              }
              if (this.isReady) {
                this.drawManager.draw();
              }
            }
            let endTime = Date.now();
            console.info(`绘制事件耗时：${endTime - startTime}`)
          } catch (e) {
            console.error(e)
          }
        })
        .onActionEnd((event) => {
          if (this.isTurnNext != null) {
            let velocity = event.velocityX;
            // this.drawManager.dispatchPointerUPEvent();
            this.isOnGesture = false;
            let isShowStartInertiaAnimation = this.isTurnNext ? velocity <= -30 : velocity >= -30;
            this.startAnimation(!isShowStartInertiaAnimation, this.isTurnNext);
            console.info(`animation: start time is ${Date.now()}`)
          }
        })
        .onActionCancel(() => {
          if (this.drawManager !== null) {
            this.drawManager.dispatchPointerUPEvent();
          }
          this.isOnGesture = false;
          this.isTurnNext = null;
        })
    )
  }
}
