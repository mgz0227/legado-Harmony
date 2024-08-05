// /*
//  * Copyright (c) 2024 Huawei Device Co., Ltd.
//  * Licensed under the Apache License, Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *     http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  */
//
// import { window } from '@kit.ArkUI';
// import { Constants, FlipPageType, BGColorType, BGC_TITLE, BG_COLOR_ARRAY } from '../common/constants/Constants';
//
// @Extend(Button)
// function fontSizeButtonStyle() {
//   .width($r('app.float.font_size_button_width'))
//   .height($r('app.float.font_size_button_height'))
//   .fontSize($r('app.float.font_size_button_fs'))
//   .fontColor(Color.Black)
//   .fontWeight(Constants.FONT_WEIGHT_500)
//   .backgroundColor($r('app.color.font_size_button_bg_color'))
// }
//
// @Extend(Text)
// function titleStyle() {
//   .fontSize($r('app.float.title_font_size'))
//   .fontWeight(Constants.FONT_WEIGHT_500)
//   .lineHeight($r('app.float.title_line_height'))
//   .fontColor($r('sys.color.mask_secondary'))
// }
//
// @Extend(Text)
// function flipTextStyle() {
//   .fontSize($r('app.float.flip_text_fs'))
//   .fontWeight(Constants.FONT_WEIGHT_500)
//   .lineHeight($r('app.float.flip_text_line_height'))
// }
//
// @Extend(Text)
// function bgColorTextStyle() {
//   .lineHeight($r('app.float.bg_color_text_line_height'))
//   .fontSize($r('app.float.bg_color_text_fs'))
//   .fontWeight(Constants.FONT_WEIGHT_500)
// }
//
// @Component
// export struct SheetView {
//   @Consume('bgColor') bgColor: string;
//   @Consume('fontSize') fontSize: number;
//   @Consume('turnStyle') turnStyle: FlipPageType;
//   @Consume('light') light: number;
//   @Consume('isSystemLight') isSystemLight: boolean;
//   @Consume('bgColorIndex') bgColorIndex: BGColorType;
//
//   build() {
//     Column() {
//       Text(Constants.TITLE_LIGHT)
//         .titleStyle()
//         .margin({
//           top: $r('app.float.title_light_margin_top')
//         })
//       Column() {
//         Row() {
//           Image($r('app.media.Public_ic_public_brightness'))
//             .width($r('app.float.image_width'))
//             .aspectRatio(1)
//           Row() {
//             Slider({
//               value: this.light,
//               min: 0,
//               max: Constants.SLIDER_MAX,
//               step: Constants.SLIDER_STEP,
//               style: SliderStyle.InSet
//             })
//               .width(Constants.FULL_PERCENT)
//               .height(Constants.FULL_PERCENT)
//               .onChange((value) => {
//                 this.isSystemLight = false;
//                 this.light = Math.floor(value);
//                 window.getLastWindow(getContext(), (err, data) => {
//                   const errCode = err.code;
//                   if (errCode) {
//                     return;
//                   }
//                   data.setWindowBrightness(this.light / Constants.ONE_HUNDRED);
//                 })
//               })
//           }
//           .layoutWeight(1)
//           .padding({
//             left: $r('app.float.slider_padding_left'),
//             right: $r('app.float.slider_padding_left'),
//             top: $r('app.float.slider_padding_top'),
//             bottom: $r('app.float.slider_padding_top')
//           })
//
//           Image($r('app.media.Public_ic_public_brightness_filled'))
//             .width($r('app.float.image_width'))
//             .aspectRatio(1)
//         }
//         .margin({ top: $r("app.float.light_slider_area_margin_top") })
//         .alignItems(VerticalAlign.Center)
//         .height($r('app.float.light_slider_area_height'))
//
//         Row() {
//           Text(Constants.TITLE_FOLLOW_SYSTEM)
//             .fontSize($r('app.float.sub_title_fs'))
//             .fontWeight(Constants.FONT_WEIGHT_500)
//             .lineHeight($r('app.float.sub_title_line_height'))
//
//           Toggle({ type: ToggleType.Switch, isOn: $$this.isSystemLight })
//             .height($r('app.float.toggle_height'))
//             .width($r('app.float.toggle_width'))
//             .onChange((isOpen) => {
//               window.getLastWindow(getContext(), (err, data) => {
//                 const errCode = err.code;
//                 if (errCode) {
//                   return;
//                 }
//                 if (isOpen) {
//                   data.setWindowBrightness(-1);
//                 } else {
//                   data.setWindowBrightness(this.light / Constants.ONE_HUNDRED);
//                 }
//               })
//             })
//         }
//         .justifyContent(FlexAlign.SpaceBetween)
//         .margin({
//           top: $r('app.float.toggle_row_margin_top'),
//           bottom: $r('app.float.toggle_row_margin_top')
//         })
//         .width(Constants.FULL_PERCENT)
//       }
//       .borderRadius($r('app.float.light_area_br'))
//       .backgroundColor(Color.White)
//       .height($r('app.float.light_area_height'))
//       .margin({ top: $r('app.float.light_area_margin_top') })
//       .padding({
//         left: $r('app.float.light_area_padding_left'),
//         right: $r('app.float.light_area_padding_left')
//       })
//
//       Text(Constants.TITLE_FONT_SIZE)
//         .titleStyle()
//         .margin({ top: $r('app.float.title_fs_margin_top') })
//
//       Column() {
//         Row() {
//           Button(Constants.BUTTON_FONT_SIZE_SUBTRACT)
//             .fontSizeButtonStyle()
//             .onClick(() => {
//               if (this.fontSize > Constants.FONT_SIZE_MIN) {
//                 this.fontSize -= Constants.FONT_SIZE_STEP;
//               }
//             })
//           Text(`${this.fontSize}`)
//             .fontSize($r('app.float.sub_title_fs'))
//             .fontWeight(Constants.FONT_WEIGHT_500)
//             .lineHeight($r('app.float.sub_title_line_height'))
//           Button(Constants.BUTTON_FONT_SIZE_ADD)
//             .fontSizeButtonStyle()
//             .onClick(() => {
//               this.fontSize += Constants.FONT_SIZE_STEP;
//               if (this.fontSize >= Constants.FONT_SIZE_MAX) {
//                 this.fontSize = Constants.FONT_SIZE_MAX;
//               }
//             })
//         }
//         .justifyContent(FlexAlign.SpaceBetween)
//         .width(Constants.FULL_PERCENT)
//       }
//       .borderRadius($r('app.float.font_size_area_br'))
//       .backgroundColor(Color.White)
//       .margin({ top: $r('app.float.font_size_area_margin_top') })
//       .padding($r('app.float.font_size_area_padding'))
//       .width(Constants.FULL_PERCENT)
//
//       Text(Constants.TITLE_FLIP)
//         .titleStyle()
//         .margin({ top: $r('app.float.title_flip_margin_top') })
//
//       Row() {
//         Row() {
//           Text(Constants.SUBTITLE_COVER)
//             .flipTextStyle()
//             .fontColor(this.turnStyle === FlipPageType.COVER_FLIP_PAGE ? Color.Black :
//               $r('app.color.flip_type_unselected_color'))
//         }
//         .height($r('app.float.title_flip_height'))
//         .borderRadius(this.turnStyle === FlipPageType.COVER_FLIP_PAGE ? $r('app.float.title_flip_br') : 0)
//         .backgroundColor(this.turnStyle === FlipPageType.COVER_FLIP_PAGE ? Color.White : Color.Transparent)
//         .layoutWeight(1)
//         .justifyContent(FlexAlign.Center)
//         .onClick(() => {
//           this.turnStyle = FlipPageType.COVER_FLIP_PAGE;
//         })
//
//         Row() {
//           Text(Constants.SUBTITLE_SIMULATE)
//             .flipTextStyle()
//             .fontColor(this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE ? Color.Black :
//               $r('app.color.flip_type_unselected_color'))
//         }
//         .height($r('app.float.title_flip_height'))
//         .layoutWeight(1)
//         .borderRadius(this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE ? $r('app.float.title_flip_br') : 0)
//         .backgroundColor(this.turnStyle === FlipPageType.SIMULATE_FLIP_PAGE ? Color.White : Color.Transparent)
//         .justifyContent(FlexAlign.Center)
//         .onClick(() => {
//           this.turnStyle = FlipPageType.SIMULATE_FLIP_PAGE;
//         })
//
//         Row() {
//           Text(Constants.SUBTITLE_SLIDE)
//             .flipTextStyle()
//             .fontColor(this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE ? Color.Black :
//               $r('app.color.flip_type_unselected_color'))
//         }
//         .height($r('app.float.title_flip_height'))
//         .layoutWeight(1)
//         .borderRadius(this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE ? $r('app.float.title_flip_br') : 0)
//         .backgroundColor(this.turnStyle === FlipPageType.SLIDE_FLIP_PAGE ? Color.White : Color.Transparent)
//         .justifyContent(FlexAlign.Center)
//         .onClick(() => {
//           this.turnStyle = FlipPageType.SLIDE_FLIP_PAGE;
//         })
//
//         Row() {
//           Text(Constants.SUBTITLE_UP_DOWN)
//             .flipTextStyle()
//             .fontColor(this.turnStyle === FlipPageType.UP_DOWN_FLIP_PAGE ? Color.Black :
//               $r('app.color.flip_type_unselected_color'))
//         }
//         .height($r('app.float.title_flip_height'))
//         .layoutWeight(1)
//         .borderRadius(this.turnStyle === FlipPageType.UP_DOWN_FLIP_PAGE ? $r('app.float.title_flip_br') : 0)
//         .backgroundColor(this.turnStyle === FlipPageType.UP_DOWN_FLIP_PAGE ? Color.White : Color.Transparent)
//         .justifyContent(FlexAlign.Center)
//         .onClick(() => {
//           this.turnStyle = FlipPageType.UP_DOWN_FLIP_PAGE;
//         })
//       }
//       .backgroundColor($r('app.color.flip_type_bgc'))
//       .width(Constants.FULL_PERCENT)
//       .height($r('app.float.flip_area_height'))
//       .margin({ top: $r('app.float.flip_area_margin_top') })
//       .padding($r('app.float.flip_area_padding'))
//       .borderRadius($r('app.float.flip_area_br'))
//       .justifyContent(FlexAlign.SpaceBetween)
//
//       Text(Constants.TITLE_BGC)
//         .titleStyle()
//         .margin({ top: $r('app.float.title_bgc_margin_top') })
//
//       Row({ space: Constants.BGC_ROW_SPACE }) {
//         Row() {
//           Text(BGC_TITLE.WHITE)
//             .bgColorTextStyle()
//             .fontColor(this.bgColorIndex === BGColorType.WHITE ? $r('app.color.bgc_name_selected') :
//               $r('app.color.bgc_name_unselected'))
//         }
//         .layoutWeight(1)
//         .height(Constants.FULL_PERCENT)
//         .backgroundColor(Color.White)
//         .border({
//           width: this.bgColorIndex === BGColorType.WHITE ? $r('app.float.bgc_selected_br_width') : 0,
//           style: BorderStyle.Solid,
//           radius: $r('app.float.bgc_selected_br_radius'),
//           color: $r('app.color.bgc_name_selected')
//         })
//         .justifyContent(FlexAlign.Center)
//         .onClick(() => {
//           this.bgColorIndex = BGColorType.WHITE;
//           this.bgColor = BG_COLOR_ARRAY[BGColorType.WHITE];
//         })
//
//         Row() {
//           Text(BGC_TITLE.YELLOW)
//             .bgColorTextStyle()
//             .fontColor(this.bgColorIndex === BGColorType.YELLOW ? $r('app.color.bgc_name_selected') :
//               $r('app.color.bgc_name_unselected'))
//         }
//         .layoutWeight(1)
//         .height(Constants.FULL_PERCENT)
//         .backgroundColor(BG_COLOR_ARRAY[BGColorType.YELLOW])
//         .justifyContent(FlexAlign.Center)
//         .border({
//           width: this.bgColorIndex === BGColorType.YELLOW ? $r('app.float.bgc_selected_br_width') : 0,
//           style: BorderStyle.Solid,
//           radius: $r('app.float.bgc_selected_br_radius'),
//           color: $r('app.color.bgc_name_selected')
//         })
//         .onClick(() => {
//           this.bgColorIndex = BGColorType.YELLOW;
//           this.bgColor = BG_COLOR_ARRAY[BGColorType.YELLOW];
//         })
//
//         Row() {
//           Text(BGC_TITLE.GREEN)
//             .bgColorTextStyle()
//             .fontColor(this.bgColorIndex === BGColorType.GREEN ? $r('app.color.bgc_name_selected') :
//               $r('app.color.bgc_name_unselected'))
//         }
//         .layoutWeight(1)
//         .height(Constants.FULL_PERCENT)
//         .backgroundColor(BG_COLOR_ARRAY[BGColorType.GREEN])
//         .justifyContent(FlexAlign.Center)
//         .border({
//           width: this.bgColorIndex === BGColorType.GREEN ? $r('app.float.bgc_selected_br_width') : 0,
//           style: BorderStyle.Solid,
//           radius: $r('app.float.bgc_selected_br_radius'),
//           color: $r('app.color.bgc_name_selected')
//         })
//         .onClick(() => {
//           this.bgColorIndex = BGColorType.GREEN;
//           this.bgColor = BG_COLOR_ARRAY[BGColorType.GREEN];
//         })
//
//         Row() {
//           Text(BGC_TITLE.BLUE)
//             .bgColorTextStyle()
//             .fontColor(this.bgColorIndex === BGColorType.BLUE ? $r('app.color.bgc_name_selected') :
//               $r('app.color.bgc_name_unselected'))
//         }
//         .layoutWeight(1)
//         .height(Constants.FULL_PERCENT)
//         .backgroundColor(BG_COLOR_ARRAY[BGColorType.BLUE])
//         .justifyContent(FlexAlign.Center)
//         .border({
//           width: this.bgColorIndex === BGColorType.BLUE ? $r('app.float.bgc_selected_br_width') : 0,
//           style: BorderStyle.Solid,
//           radius: $r('app.float.bgc_selected_br_radius'),
//           color: $r('app.color.bgc_name_selected')
//         })
//         .onClick(() => {
//           this.bgColorIndex = BGColorType.BLUE;
//           this.bgColor =BG_COLOR_ARRAY[BGColorType.BLUE];
//         })
//       }
//       .width(Constants.FULL_PERCENT)
//       .height($r('app.float.bgc_area_height'))
//       .margin({ top: $r('app.float.bgc_area_margin_top') })
//       .justifyContent(FlexAlign.SpaceBetween)
//
//     }
//     .height(Constants.FULL_PERCENT)
//     .width(Constants.FULL_PERCENT)
//     .padding({
//       left: $r('app.float.sheet_padding_left'),
//       right: $r('app.float.sheet_padding_left')
//     })
//     .justifyContent(FlexAlign.Start)
//     .alignItems(HorizontalAlign.Start)
//   }
// }