import { common2D, drawing } from '@kit.ArkGraphics2D';
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { Constants } from '../common/constants/Constants';
import { ReaderChapterItem } from '../common/constants/ReaderChaptersItem';
import { Reader, ReaderForCurlView, SimulateDrawManager } from './Reader';
import { image } from '@kit.ImageKit';

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
  @Link currentPageNum: number;
  @Consume('chapterList') chapterList: ReaderChapterItem[];
  @Link currentChapterNum: number;
  @Consume('fontSize') fontSize: number;
  @Consume('lineHeightRatio') lineHeightRatio: number;
  @Consume('bgColor') bgColor: string;
  @Provide('batteryPixelMap') @Watch('setBatteryPixelMap') batteryPixelMap: image.PixelMap | null = null;
  @Consume('displaySize') @Watch('onTextDisplaySizeChanged') displaySize: number[];
  drawManager: SimulateDrawManager | null = null;
  isTurnNext: boolean | null = null;
  animationEndValue: number | null = null;

  aboutToDisappear(): void {
    this.animatorResult = undefined;
  }

  aboutToAppear(): void {
    this.drawManager =
      new SimulateDrawManager(this.context, this.fontSize, this.fontSize * this.lineHeightRatio, this.chapterList,
        this.currentChapterNum, this.currentPageNum, this.bgColor);
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
        this.currentPageNum++;
        this.drawManager?.updatePageIndex(this.currentPageNum)
      } else if (!this.isTurnNext && this.animationEndValue === -1.0) {
        this.currentPageNum--;
        this.drawManager?.updatePageIndex(this.currentPageNum)
      }
      this.isTurnNext = null;
      this.animationEndValue = null;
    }
    this.animatorResult.onFrame = (progress) => {
      console.info(`animation: onFrame callback time is ${Date.now()} , progress : ${progress}}`)
      if (this.drawManager !== null) {
        this.drawManager.applyAnimationProgressToTouch(progress);
        this.drawManager.draw()
      }
    };
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

      if (this.chapterList[this.currentChapterNum].chapterPageList.length === 0) {
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
          content: this.chapterList[this.currentChapterNum].chapterPageList[this.currentPageNum].content
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

// class SimulateDrawHelper {
//   mTouch: Offset = Offset.zero();
//   currentSize: Size = Size.zero();
//   mBezierStart1 = Offset.zero(); // 贝塞尔曲线起始点
//   mBezierControl1 = Offset.zero(); // 贝塞尔曲线控制点
//   mBezierVertex1 = Offset.zero(); // 贝塞尔曲线顶点
//   mBezierEnd1 = Offset.zero(); // 贝塞尔曲线结束点
//   mBezierStart2 = Offset.zero(); // 另一条贝塞尔曲线
//   mBezierControl2 = Offset.zero();
//   mBezierVertex2 = Offset.zero();
//   mBezierEnd2 = Offset.zero();
//   mCornerX = 1; // 拖拽点对应的页脚
//   mCornerY = 1;
//   mMiddleX = 0.0;
//   mMiddleY = 0.0;
//   mDegrees = 0.0;
//   mTouchToCornerDis = 0.0;
//   // Path mTopPagePath = Path();
//   mBottomPagePath = new drawing.Path();
//   mTopBackAreaPagePath = new drawing.Path();
//   // Path mShadowPath = Path();
//
//   isNeedCalCorner = true;
//   isTurnNext = false;
//   lastTouchPointOffset = Offset.zero();
//   preImage: image.PixelMap | null = null;
//
//   // 计算贝塞尔曲线的各个关键点坐标
//   calBezierPoint() {
//     this.mMiddleX = (this.mTouch.dx + this.mCornerX) / 2;
//     this.mMiddleY = (this.mTouch.dy + this.mCornerY) / 2;
//
//     this.mBezierControl1 = new Offset(
//       this.mMiddleX -
//         (this.mCornerY - this.mMiddleY) *
//           (this.mCornerY - this.mMiddleY) /
//           (this.mCornerX - this.mMiddleX),
//       this.mCornerY);
//
//     let f4 = this.mCornerY - this.mMiddleY;
//     if (f4 === 0) {
//       this.mBezierControl2 = new Offset(this.mCornerX,
//         this.mMiddleY - (this.mCornerX - this.mMiddleX) * (this.mCornerX - this.mMiddleX) / 0.1);
//     } else {
//       this.mBezierControl2 = new Offset(
//         this.mCornerX,
//         this.mMiddleY -
//           (this.mCornerX - this.mMiddleX) *
//             (this.mCornerX - this.mMiddleX) /
//             (this.mCornerY - this.mMiddleY));
//     }
//
//     this.mBezierStart1 = new Offset(
//       this.mBezierControl1.dx - (this.mCornerX - this.mBezierControl1.dx) / 2,
//       this.mCornerY);
//
//     // 当mBezierStart1.x < 0或者mBezierStart1.x > 480时
//     // 如果继续翻页，会出现BUG故在此限制
//     if (this.mTouch.dx > 0 && this.mTouch.dx < this.currentSize.width) {
//       if (this.mBezierStart1.dx < 0 || this.mBezierStart1.dx > this.currentSize.width) {
//         if (this.mBezierStart1.dx < 0) {
//           this.mBezierStart1 =
//             new Offset(this.currentSize.width - this.mBezierStart1.dx, this.mBezierStart1.dy);
//         }
//
//         let f1 = Math.abs(this.mCornerX - this.mTouch.dx);
//         let f2 = this.currentSize.width * f1 / this.mBezierStart1.dx;
//         this.mTouch = new Offset(Math.abs(this.mCornerX - f2), this.mTouch.dy);
//
//         let f3 =
//           Math.abs(this.mCornerX - this.mTouch.dx) * Math.floor(this.mCornerY - this.mTouch.dy) / f1;
//         this.mTouch = new Offset(Math.abs(this.mCornerX - f2), Math.abs(this.mCornerY - f3));
//
//         this.mMiddleX = (this.mTouch.dx + this.mCornerX) / 2;
//         this.mMiddleY = (this.mTouch.dy + this.mCornerY) / 2;
//
//         this.mBezierControl1 = new Offset(
//           this.mMiddleX -
//             (this.mCornerY - this.mMiddleY) *
//               (this.mCornerY - this.mMiddleY) /
//               (this.mCornerX - this.mMiddleX),
//           this.mCornerY);
//
//         let f5 = this.mCornerY - this.mMiddleY;
//         if (f5 === 0) {
//           this.mBezierControl2 = new Offset(this.mCornerX,
//             this.mMiddleY - (this.mCornerX - this.mMiddleX) * (this.mCornerX - this.mMiddleX) / 0.1);
//         } else {
//           this.mBezierControl2 = new Offset(
//             this.mCornerX,
//             this.mMiddleY -
//               (this.mCornerX - this.mMiddleX) *
//                 (this.mCornerX - this.mMiddleX) /
//                 (this.mCornerY - this.mMiddleY));
//         }
//
//         this.mBezierStart1 = new Offset(
//           this.mBezierControl1.dx - (this.mCornerX - this.mBezierControl1.dx) / 2,
//           this.mBezierStart1.dy);
//       }
//     }
//
//     this.mBezierStart2 = new Offset(this.mCornerX,
//       this.mBezierControl2.dy - (this.mCornerY - this.mBezierControl2.dy) / 2);
//
//     this.mTouchToCornerDis =
//       Math.sqrt(Math.pow((this.mTouch.dx - this.mCornerX), 2) + Math.pow((this.mTouch.dy - this.mCornerY), 2));
//
//     this.mBezierEnd1 =
//       this.getCrossByPoint(this.mTouch, this.mBezierControl1, this.mBezierStart1, this.mBezierStart2);
//     this.mBezierEnd2 =
//       this.getCrossByPoint(this.mTouch, this.mBezierControl2, this.mBezierStart1, this.mBezierStart2);
//
//     this.mBezierVertex1 = new Offset(
//       (this.mBezierStart1.dx + 2 * this.mBezierControl1.dx + this.mBezierEnd1.dx) / 4,
//       (2 * this.mBezierControl1.dy + this.mBezierStart1.dy + this.mBezierEnd1.dy) / 4);
//
//     this.mBezierVertex2 = new Offset(
//       (this.mBezierStart2.dx + 2 * this.mBezierControl2.dx + this.mBezierEnd2.dx) / 4,
//       (2 * this.mBezierControl2.dy + this.mBezierStart2.dy + this.mBezierEnd2.dy) / 4);
//   }
//
//   // 获取交点(根据四点) //
//   getCrossByPoint(p1: Offset, p2: Offset, p3: Offset, p4: Offset): Offset {
//     let line1Info = this.getLineInfo(p1, p2);
//     let line2Info = this.getLineInfo(p3, p4);
//
//     return this.getCrossByLine(
//       line1Info.dx, line1Info.dy, line2Info.dx, line2Info.dy);
//   }
//
//   // 根据两点获取直线的k、b；
//   // return : dx = k，dy = b
//   getLineInfo(p1: Offset, p2: Offset): Offset {
//     let k1 = (p2.dy - p1.dy) / (p2.dx - p1.dx);
//     let b1 = ((p1.dx * p2.dy) - (p2.dx * p1.dy)) / (p1.dx - p2.dx);
//     return new Offset(k1, b1);
//   }
//
//   // 根据k和b
//   getCrossByLine(k1: number, b1: number, k2: number, b2: number): Offset {
//     return new Offset((b2 - b1) / (k1 - k2), k1 * ((b2 - b1) / (k1 - k2)) + b1);
//   }
//
//   calPath() {
//     if (canIUse('SystemCapability.Graphics.Drawing')) {
//
//       this.mBottomPagePath.reset();
//       this.mBottomPagePath.moveTo(this.mCornerX, this.mCornerY);
//       this.mBottomPagePath.lineTo(this.mBezierStart1.dx, this.mBezierStart1.dy);
//       this.mBottomPagePath.quadTo(this.mBezierControl1.x, this.mBezierControl1.y, this.mBezierEnd1.x,
//         this.mBezierEnd1.y)
//
//       this.mBottomPagePath.lineTo(this.mTouch.dx, this.mTouch.dy);
//       this.mBottomPagePath.lineTo(this.mBezierEnd2.dx, this.mBezierEnd2.dy);
//       this.mBottomPagePath.quadTo(this.mBezierControl2.x, this.mBezierControl2.y, this.mBezierStart2.x,
//         this.mBezierStart2.y)
//
//       this.mBottomPagePath.close();
//
//       // this.mTopBackAreaPagePath = new Path2D();
//       // this.mTopBackAreaPagePath.moveTo(this.mTouch.dx, this.mTouch.dy);
//       // this.mTopBackAreaPagePath.lineTo(this.mBezierVertex1.dx, this.mBezierVertex1.dy);
//       // this.mTopBackAreaPagePath.lineTo(this.mBezierVertex2.dx, this.mBezierVertex2.dy);
//       // this.mTopBackAreaPagePath.closePath();
//
//       // if (this.mTopBackAreaPagePath..hasNaN ||
//       // this.mTopBackAreaPagePath.getBounds().isEmpty) {
//       //   return;
//       // }
//
//       // try {
//       //   this.mTopBackAreaPagePath =
//       //   this.mTopBackAreaPagePath = Path.combine(
//       //     PathOperation.intersect, mTopBackAreaPagePath, mBottomPagePath);
//       // } on StateError {
//       //   print(
//       //     'path combine failed , current backpackArea is ${mTopBackAreaPagePath.getBounds()} , current bottomArea is ${mBottomPagePath.getBounds()}');
//       // }
//     }
//   }
//
//   dispatchPointerStart(pointerEvent: GestureEvent) {
//     this.lastTouchPointOffset =
//       new Offset(vp2px(pointerEvent.fingerList[0].localX), vp2px(pointerEvent.fingerList[0].localY))
//
//     this.mTouch = new Offset(vp2px(pointerEvent.fingerList[0].localX), vp2px(pointerEvent.fingerList[0].localY))
//   }
//
//   dispatchPointerMoveEvent(
//     pointerEvent: GestureEvent, canvasSize: Size, itemMainAxisDelta: number) {
//     let touchPoint = new Offset(
//       itemMainAxisDelta === 0
//         ? canvasSize.width
//         : canvasSize.width + itemMainAxisDelta,
//       vp2px(pointerEvent.fingerList[0].localY));
//
//     this.lastTouchPointOffset =
//       new Offset(vp2px(pointerEvent.fingerList[0].localX), vp2px(pointerEvent.fingerList[0].localY))
//
//     if (this.isNeedCalCorner) {
//       this.calcCornerXY(touchPoint.dy);
//       this.isNeedCalCorner = false;
//       this.isTurnNext = pointerEvent.velocityX <= 0;
//     }
//
//     this.mTouch = new Offset(vp2px(pointerEvent.fingerList[0].localX), vp2px(pointerEvent.fingerList[0].localY))
//     this.calBezierPoint();
//   }
//
//   dispatchPointerUPEvent() {
//     this.isNeedCalCorner = true;
//     // this.mTouch = Offset.zero();
//   }
//
//   /// 计算拖拽点对应的拖拽脚 ///
//   calcCornerXY(y: number) {
//     this.mCornerX = this.currentSize.width;
//     if (y <= this.currentSize.height / 2) {
//       this.mCornerY = 0;
//     } else {
//       this.mCornerY = this.currentSize.height;
//     }
//   }
//
//   applyAnimation(process: number) {
//
//     let isRecover = process <= 0
//     this.mTouch =
//       new Offset(Math.min(this.lastTouchPointOffset.x +
//         ((isRecover ? this.mCornerX : -this.mCornerX) - this.lastTouchPointOffset.x) * Math.abs(process),
//         this.mCornerX),
//         this.lastTouchPointOffset.y + this.mCornerY - this.lastTouchPointOffset.y * Math.abs(process))
//
//     console.info(`animation: mTouch is x:${this.mTouch.x},y:${this.mTouch.y}, process is ${process}`)
//
//     this.calBezierPoint();
//   }
//
//   draw(canvas: drawing.Canvas): void {
//
//     let startTime = Date.now();
//
//     if (canIUse('SystemCapability.Graphics.Drawing')) {
//
//       try {
//         this.calPath();
//
//         console.info('draw called')
//         this.drawCurrentPageArea(canvas);
//         this.drawNextPage(canvas);
//         this.drawCurrentTurningPage(canvas)
//
//         let endTime = Date.now();
//
//         let shadowBrush = new drawing.Brush();
//         let maskFilter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.OUTER, 50);
//
//         shadowBrush.setMaskFilter(maskFilter)
//         canvas.attachBrush(shadowBrush)
//         canvas.drawPath(this.mBottomPagePath);
//         canvas.detachBrush()
//
//         console.log(`绘制耗时：${endTime - startTime}`)
//
//       } catch (e) {
//         console.error(`绘制出错：${e}`)
//       }
//     }
//   }
//
//   private drawCurrentPageArea(canvas: drawing.Canvas): void {
//     this.drawCurrentPage(canvas)
//     this.drawCurrentPageShadow(canvas)
//   }
//
//   private drawCurrentPageShadow(canvas: drawing.Canvas): void {
//
//   }
//
//   private drawCurrentTurningPage(canvas: drawing.Canvas): void {
//     if (canIUse('SystemCapability.Graphics.Drawing')) {
//
//       canvas.save()
//       canvas.clipPath(this.mBottomPagePath, drawing.ClipOp.INTERSECT)
//       let backAreaPath = new drawing.Path()
//       backAreaPath.moveTo(this.mTouch.x, this.mTouch.y)
//       backAreaPath.lineTo(this.mBezierVertex1.x, this.mBezierVertex1.y)
//       backAreaPath.lineTo(this.mBezierVertex2.x, this.mBezierVertex2.y)
//       backAreaPath.close()
//       canvas.clipPath(backAreaPath, drawing.ClipOp.INTERSECT)
//       canvas.save();
//
//       let angle =
//         2 * (Math.PI / 2 - Math.atan2(this.mCornerY - this.mTouch.dy, this.mCornerX - this.mTouch.dx));
//
//       if (this.mCornerY === 0) {
//         canvas.translate(this.currentSize.width, 0)
//         canvas.scale(-1.0, 1.0)
//         canvas.translate(-this.mTouch.x, this.mTouch.y)
//         canvas.rotate(180 * ((angle) / Math.PI) - 180, this.mCornerX, this.mCornerY)
//         this.drawCurrentPage(canvas,)
//       } else {
//         canvas.translate(0, this.currentSize.height,)
//         canvas.scale(1.0, -1.0)
//         canvas.translate(this.mTouch.x - this.currentSize.width, -this.mTouch.y)
//         canvas.rotate(angle / Math.PI * 180, this.currentSize.width, this.currentSize.height,)
//         this.drawCurrentPage(canvas,)
//       }
//
//
//       // canvas.drawColor(preBackColor)
//       canvas.restore();
//
//       // const backMaskFilter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.INNER, 50);
//       const maskBrush = new drawing.Brush();
//       // maskBrush.setMaskFilter(backMaskFilter)
//       maskBrush.setColor({
//         alpha: 125,
//         red: 255,
//         green: 255,
//         blue: 255
//       });
//
//       canvas.attachBrush(maskBrush);
//       canvas.drawPath(backAreaPath);
//       canvas.detachBrush();
//
//       const pen = new drawing.Pen();
//       pen.setStrokeWidth(150);
//       pen.setColor({
//         alpha: 255,
//         red: 0,
//         green: 0,
//         blue: 0
//       });
//       let maskFilter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.NORMAL, 70);
//       pen.setMaskFilter(maskFilter);
//       canvas.attachPen(pen);
//       canvas.drawLine(this.mBezierVertex1.x, this.mBezierVertex1.y, this.mBezierVertex2.x, this.mBezierVertex2.y);
//       canvas.detachPen();
//
//
//       canvas.restore()
//     }
//
//   }
//
//   private drawCurrentPage(canvas: drawing.Canvas,): void {
//     let preColor: common2D.Color = {
//       alpha: 255,
//       red: 255,
//       green: 0,
//       blue: 0
//     }
//
//     let textColor: common2D.Color = {
//       alpha: 255,
//       red: 255,
//       green: 255,
//       blue: 255
//     }
//     if (canIUse('SystemCapability.Graphics.Drawing')) {
//
//
//       // const canvas = context.canvas;
//       canvas.drawColor(preColor)
//       const preBrush = new drawing.Brush();
//       preBrush.setColor({
//         alpha: 255,
//         red: 255,
//         green: 255,
//         blue: 255
//       });
//       const preFont = new drawing.Font();
//
//       preFont.setSize(fp2px(20));
//       canvas.attachBrush(preBrush);
//       let fontMetrics = preFont.getMetrics();
//       // 36是lineHeight，20是字号
//       let lineHeight = Math.round(fp2px(20) * (36 / 20))
//       let startY = Math.round(lineHeight * (Math.abs(fontMetrics.ascent) / (fontMetrics.descent - fontMetrics.ascent)))
//
//       let pen = new drawing.Pen();
//       pen.setColor(textColor)
//       // if(maskFilter!=null){
//       //   pen.setMaskFilter(maskFilter)
//       // }
//       canvas.attachPen(pen)
//       for (let index = 0; index < 20; index++) {
//         const textBlob = drawing.TextBlob.makeFromString("第一页，第一页，第一页，第一页", preFont,
//           drawing.TextEncoding.TEXT_ENCODING_UTF8);
//         canvas.drawTextBlob(textBlob, vp2px(20), startY + (lineHeight * index));
//       }
//       canvas.detachPen();
//
//       canvas.detachBrush();
//     }
//   }
//
//   private drawNextPage(canvas: drawing.Canvas): void {
//     if (canIUse('SystemCapability.Graphics.Drawing')) {
//
//       canvas.save()
//       canvas.clipPath(this.mBottomPagePath, drawing.ClipOp.INTERSECT, true)
//       let curColor: common2D.Color = {
//         alpha: 255,
//         red: 240,
//         green: 240,
//         blue: 40
//       }
//       canvas.drawColor(curColor)
//       const curBrush = new drawing.Brush();
//       curBrush.setColor({
//         alpha: 255,
//         red: 0,
//         green: 0,
//         blue: 0
//       });
//       const curFont = new drawing.Font();
//       curFont.setSize(fp2px(20));
//       canvas.attachBrush(curBrush);
//       let fontMetrics = curFont.getMetrics();
//       // 36是lineHeight，20是字号
//       let lineHeight = Math.round(fp2px(20) * (36 / 20))
//       let startY = Math.round(lineHeight * (Math.abs(fontMetrics.ascent) / (fontMetrics.descent - fontMetrics.ascent)))
//
//       for (let index = 0; index <= 5; index++) {
//         const textBlob = drawing.TextBlob.makeFromString("第二页，第二页，第二页，第二页", curFont,
//           drawing.TextEncoding.TEXT_ENCODING_UTF8);
//         canvas.drawTextBlob(textBlob, vp2px(20), startY + (lineHeight * index));
//       }
//
//       canvas.detachBrush();
//
//       let k1 = (this.mBezierVertex1.y - this.mBezierVertex2.y) / (this.mBezierVertex1.x - this.mBezierVertex2.x);
//       let b1 = this.mBezierVertex1.y - this.mBezierVertex1.x * k1;
//
//       let shadowWidth =
//         (Math.abs(k1 * this.mBezierStart1.x - this.mBezierStart1.y + b1)) / (Math.sqrt(Math.pow(k1, 2) + 1)) * 4
//       let shadowMaskFilter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.NORMAL, shadowWidth)
//
//       const shadowPen = new drawing.Pen();
//       shadowPen.setStrokeWidth(shadowWidth)
//       shadowPen.setMaskFilter(shadowMaskFilter)
//
//       canvas.attachPen(shadowPen)
//       canvas.drawLine(this.mBezierStart1.x, this.mBezierStart1.y, this.mBezierStart2.x, this.mBezierStart2.y)
//       canvas.detachPen()
//
//       canvas.restore()
//     }
//   }
// }

