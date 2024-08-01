// import { BusinessError } from '@kit.BasicServicesKit'
// import { display, promptAction, window } from '@kit.ArkUI';
// import { BGColorType, Constants, FlipPageType, BG_COLOR_ARRAY } from '../common/constants/Constants';
// import { CoverFlipView } from '../view/CoverFlipView';
// import { SimulateCurlPage } from '../view/SimulateCurlView';
// import { SlideFlipView } from '../view/SlideFlipView';
// import { UpDownFlipView } from '../view/UpDownFlipView';
// import { NovelContentParseHelper } from '../common/helper/NovelContentParseHelper';
//
//
// @Component
// export struct NovelPage {
//   @Provide('fontSize') @Watch('onFontSizeChange') fontSize: number = Constants.INIT_FONT_SIZE;
//   @Provide('bgColorIndex') @Watch('onBgColorChanged') bgColorIndex: BGColorType = BGColorType.WHITE;
//   @Provide('bgColor') bgColor: string = BG_COLOR_ARRAY[BGColorType.WHITE];
//   @Provide('offsetX') offsetX: number = 0
//   @Provide('offsetY') offsetY: number = 0;
//   @Provide('screenH') screenH: number = 0;
//   @Provide('screenW') screenW: number = 0;
//   @Provide('sumRow') sumRow: number = 0;
//   @Provide('rowWord') rowWord: number = 0;
//   @Provide('rotateAngleOne') rotateAngleOne: number = Constants.INIT_ROTATE_ANGLE_ONE;
//   @Provide('rotateAngleTwo') rotateAngleTwo: number = 0.0;
//   @Provide('curPosition') curPosition: number = 0;
//   @Provide('turnStyle') turnStyle: FlipPageType = FlipPageType.COVER_FLIP_PAGE;
//   @Provide('currentPageNum') @Watch('onFlush') currentPageNum: number = 1;
//   @Provide('pageWordSum') pageWordSum: number = 0;
//   @Provide('light') light: number = Constants.INIT_SCREEN_LIGHT;
//   @Provide('isSystemLight') isSystemLight: boolean = false;
//   @Provide('rowGap') rowGap: number = Constants.INIT_ROW_GAP;
//   @State currentStartIndex: number = 0;
//   @State isFontChanged: boolean = false;
//   @Provide('pageList') pageList: string[] = [];
//
//   aboutToAppear(): void {
//     this.screenW = px2vp(display.getDefaultDisplaySync().width);
//     this.screenH = px2vp(display.getDefaultDisplaySync().height - (AppStorage.get('avoidHeight') as number));
//     this.sumRow = Math.floor((this.screenH) / (this.fontSize + this.rowGap));
//     this.rowWord = Math.floor((this.screenW - Constants.SCREEN_MARGIN_LEFT * 2) / this.fontSize);
//     this.simulatePageContent();
//     this.changeSystemBarStatue();
//   }
//
//   onSizeChange(event: SizeChangeCallback): CommonAttribute {
//     let size = super.onSizeChange(event);
//     let sizeValue = JSON.stringify(size)
//     return size;
//   }
//
//   onFontSizeChange() {
//     this.sumRow = Math.floor((this.screenH) / (this.fontSize + this.rowGap));
//     this.rowWord = Math.floor((this.screenW - Constants.SCREEN_MARGIN_LEFT * 2) / this.fontSize);
//     let pageWordSum = this.sumRow * this.rowWord;
//
//     if (this.currentStartIndex > pageWordSum) {
//       this.currentPageNum = Math.floor(this.currentStartIndex / (pageWordSum)) +
//         (this.currentStartIndex > 1 && this.currentStartIndex % pageWordSum > 0 ? 2 : 1);
//     } else if (this.currentStartIndex > 0) {
//       this.currentPageNum = 2;
//     } else {
//       console.info('currentStartIndex = ' + this.currentStartIndex);
//     }
//     this.isFontChanged = true;
//     this.simulatePageContent();
//   }
//
//   changeSystemBarStatue(): void {
//     window.getLastWindow(getContext(this), (err, data) => {
//       const errCode = err.code;
//       if (errCode) {
//         return;
//       }
//       let SystemBarProperties: window.SystemBarProperties = {
//         statusBarColor: BG_COLOR_ARRAY[this.bgColorIndex],
//         navigationBarColor: BG_COLOR_ARRAY[this.bgColorIndex],
//         navigationBarContentColor: Constants.TRANSPARENT
//       };
//       try {
//         data.setWindowSystemBarProperties(SystemBarProperties, (err: BusinessError) => {
//           const errCode: number = err.code;
//           if (errCode) {
//             console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
//             return;
//           }
//           data.setWindowBackgroundColor(BG_COLOR_ARRAY[this.bgColorIndex]);
//         });
//       } catch (exception) {
//         console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(exception));
//       }
//     });
//   }
//
//   onBgColorChanged() {
//     this.changeSystemBarStatue();
//   }
//
//   onFlush() {
//     console.info('currentPageNum=' + this.currentPageNum + ', isFontChanged=' + this.isFontChanged);
//     if (this.isFontChanged && this.currentPageNum === 1) {
//       this.isFontChanged = false;
//       this.currentStartIndex = 0;
//     }
//   }
//
//   simulatePageContent() {
//     this.offsetY = 0;
//     this.rotateAngleTwo = 0.0;
//     this.rotateAngleOne = Constants.INIT_ROTATE_ANGLE_ONE;
//   }
//
//   private clickAnimateTo(isLeft: Boolean) {
//     if (this.turnStyle === FlipPageType.COVER_FLIP_PAGE) {
//       animateTo({
//         duration: Constants.COVER_DURATION,
//         curve: Curve.EaseOut,
//         onFinish: () => {
//           if (this.offsetX > 0) {
//             this.currentPageNum > 0 ? this.currentPageNum - 1 : this.currentPageNum;
//             this.currentStartIndex -= this.sumRow * this.rowWord;
//           } else if (this.offsetX < 0) {
//             this.currentPageNum += 1;
//             this.currentStartIndex += this.sumRow * this.rowWord;
//           }
//           this.offsetX = 0;
//           this.simulatePageContent();
//         }
//       }, () => {
//         if (isLeft) {
//           this.offsetX = this.screenW;
//         } else {
//           this.offsetX = -this.screenW;
//         }
//       });
//     } else if (this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE) {
//       animateTo({
//         duration: Constants.SIMULATE_DURATION,
//         curve: Curve.EaseOut,
//         onFinish: () => {
//           this.simulatePageContent();
//           if (isLeft) {
//             this.currentStartIndex -= this.sumRow * this.rowWord;
//           } else {
//             this.currentStartIndex += this.sumRow * this.rowWord;
//           }
//         }
//       }, () => {
//         if (isLeft) {
//           this.rotateAngleOne = 0;
//           this.currentPageNum > 0 ? this.currentPageNum - 1 : this.currentPageNum;
//         } else {
//           this.rotateAngleTwo = Constants.INIT_ROTATE_ANGLE_ONE;
//           this.currentPageNum += 1;
//         }
//       })
//     } else if (this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE) {
//       animateTo({
//         duration: Constants.SLIDE_DURATION,
//         curve: Curve.EaseOut,
//         onFinish: () => {
//           if (this.offsetX > 0) {
//             this.currentPageNum > 0 ? this.currentPageNum - 1 : this.currentPageNum;
//             this.currentStartIndex -= this.sumRow * this.rowWord;
//           }
//           if (this.offsetX < 0) {
//             this.currentPageNum += 1;
//             this.currentStartIndex += this.sumRow * this.rowWord;
//           }
//           console.info(this.currentStartIndex.toString());
//           this.offsetX = 0;
//           this.simulatePageContent();
//         }
//       }, () => {
//         if (isLeft) {
//           this.offsetX = this.screenW;
//         } else {
//           this.offsetX = -this.screenW;
//         }
//       })
//     }
//   }
//
//   build() {
//     Row() {
//       if (this.turnStyle === FlipPageType.COVER_FLIP_PAGE) {
//         CoverFlipView({
//           currentStartIndex: this.currentStartIndex,
//         })
//       }
//       if (this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE) {
//         SimulateCurlPage({
//           currentStartIndex: this.currentStartIndex
//         })
//       }
//       if (this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE) {
//         SlideFlipView({
//           currentStartIndex: this.currentStartIndex
//         })
//       }
//       if (this.turnStyle === FlipPageType.UP_DOWN_FLIP_PAGE) {
//         UpDownFlipView({
//           currentStartIndex: this.currentStartIndex
//         })
//       }
//     }
//     .onClick((event?: ClickEvent) => {
//       if (event) {
//         if (event.x > this.screenW / 3 * 2) {
//           if (this.turnStyle != FlipPageType.UP_DOWN_FLIP_PAGE) {
//             promptAction.showToast({
//               message: Constants.MSG_FLIP_RIGHT,
//               duration: Constants.PROMPT_DURATION
//             });
//             this.clickAnimateTo(false);
//           }
//         } else if (event.x < this.screenW / 3) {
//           if (this.turnStyle != FlipPageType.UP_DOWN_FLIP_PAGE) {
//             if (this.currentPageNum <= 1) {
//               promptAction.showToast({
//                 message: Constants.MSG_FLIP_OVER,
//                 duration: Constants.PROMPT_DURATION
//               })
//             } else {
//               promptAction.showToast({
//                 message: Constants.MSG_FLIP_LEFT,
//                 duration: Constants.PROMPT_DURATION
//               });
//               this.clickAnimateTo(true);
//             }
//           }
//         }
//       }
//     })
//     .width(Constants.FULL_PERCENT)
//     .height(Constants.FULL_PERCENT)
//     // .bindSheet(
//     //   $$this.isShow,
//     //   this.myBuilder(),
//     //   {
//     //     height: SheetSize.FIT_CONTENT,
//     //     detents: [Constants.SHEET_HEIGHT, Constants.SHEET_HEIGHT + 1],
//     //     showClose: true,
//     //     dragBar: true,
//     //     title: { title: Constants.SHEET_TITLE },
//     //     backgroundColor: Constants.SHEET_BACKGROUND_COLOR
//     //   }
//     // )
//     .backgroundColor(this.bgColor)
//   }
//
//   // @Builder
//   // myBuilder() {
//   //   Column() {
//   //     SheetView()
//   //   }
//   //   .height(Constants.FULL_PERCENT)
//   //   .width(Constants.FULL_PERCENT)
//   // }
// }