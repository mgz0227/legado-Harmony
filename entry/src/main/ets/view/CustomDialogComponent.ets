/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import Logger from '../common/utils/Logger';
import CommonConstants from '../common/constants/CommonConstants';
import { GlobalContext } from '../common/utils/GlobalContext';

/**
 * Custom pop-up window.
 */
@CustomDialog
export default struct CustomDialogComponent {
  controller: CustomDialogController = new CustomDialogController({'builder': ''});
  cancel: Function = () => {};
  confirm: Function = () => {};

  build() {
    Column() {
      Text($r('app.string.dialog_text_title'))
        .width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT)
        .fontColor($r('app.color.dialog_text_color'))
        .fontSize($r('app.float.dialog_text_privacy_size'))
        .textAlign(TextAlign.Center)
        .fontWeight(CommonConstants.DIALOG_TITLE_FONT_WEIGHT)
        .margin({
          top: $r('app.float.dialog_text_privacy_top'),
          bottom: $r('app.float.dialog_text_privacy_bottom')
        })
      Text($r('app.string.dialog_text_privacy_content'))
        .fontSize($r('app.float.dialog_common_text_size'))
        .width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT)
      Text($r('app.string.dialog_text_privacy_statement'))
        .width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT)
        .fontColor($r('app.color.dialog_text_statement_color'))
        .fontSize($r('app.float.dialog_common_text_size'))
        .onClick(() => {
          // globalThis.isJumpPrivacy = true;
          GlobalContext.getContext().setObject('isJumpPrivacy', true);
          router.pushUrl({
            url: CommonConstants.PRIVACY_PAGE_URL
          }).catch((error: Error) => {
            Logger.error(CommonConstants.CUSTOM_DIALOG_TAG, 'CustomDialog pushUrl error ' + JSON.stringify(error));
          });
        })
      Text($r('app.string.dialog_text_declaration_prompt'))
        .width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT)
        .fontColor($r('app.color.dialog_text_color'))
        .fontSize($r('app.float.dialog_common_text_size'))
        .opacity($r('app.float.dialog_text_opacity'))
        .margin({ bottom: $r('app.float.dialog_text_declaration_bottom') })
      Row() {
        Text($r('app.string.dialog_button_disagree'))
          .fancy()
          .onClick(() => {
            this.controller.close();
            this.cancel();
          })
        Blank()
          .backgroundColor($r('app.color.dialog_blank_background_color'))
          .width($r('app.float.dialog_blank_width'))
          .height($r('app.float.dialog_blank_height'))
        Text($r('app.string.dialog_button_agree'))
          .fancy()
          .onClick(() => {
            this.controller.close();
            this.confirm();
          })
      }
      .margin({ bottom: CommonConstants.DIALOG_ROW_MARGIN_BOTTOM })
    }
    .width(CommonConstants.DIALOG_WIDTH_PERCENT)
    .borderRadius(CommonConstants.DIALOG_BORDER_RADIUS)
    .backgroundColor(Color.White)
  }
}

// Common text styles.
@Extend(Text) function fancy () {
  .fontColor($r("app.color.dialog_fancy_text_color"))
  .fontSize($r("app.float.dialog_fancy_text_size"))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .layoutWeight(CommonConstants.COMMON_LAYOUT_WEIGHT)
}