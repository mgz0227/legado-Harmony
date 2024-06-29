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
import { curves } from '@kit.ArkUI';
import { relationalStore } from '@kit.ArkData';

/**
 * Common constants for all features.
 */
export default class CommonConstants {
  /**
   * The main ability tag.
   */
  static readonly ENTRY_ABILITY_TAG: string = 'EntryAbility';

  /**
   * The launcher page tag.
   */
  static readonly LAUNCHER_PAGE_TAG: string = 'LauncherPage';

  /**
   * The Advertising page tag.
   */
  static readonly ADVERTISING_PAGE_TAG: string = 'AdvertisingPage';

  /**
   * The custom dialog component tag.
   */
  static readonly CUSTOM_DIALOG_TAG: string = 'CustomDialogComponent';

  /**
   * Preference saved key.
   */
  static readonly PREFERENCES_KEY_PRIVACY: string = 'isPrivacy';

  /**
   * Preference saved file name.
   */
  static readonly PREFERENCES_FILE_NAME: string = 'myStore';

  /**
   * Launcher page count down.
   */
  static readonly LAUNCHER_DELAY_TIME: number = 3000;

  /**
   * Image logo top margin.
   */
  static readonly LAUNCHER_IMAGE_MARGIN_TOP: string = '16.2%';

  /**
   * Healthy living text spacing.
   */
  static readonly LAUNCHER_LIFE_TEXT_SPACING: number = 0.1;

  /**
   * Healthy living title text top margin.
   */
  static readonly LAUNCHER_TEXT_TITLE_MARGIN_TOP: string = '0.5%';

  /**
   * Content control height.
   */
  static readonly LAUNCHER_TEXT_INTRODUCE_HEIGHT: string = '2.7%';

  /**
   * Healthy living instructions.
   */
  static readonly LAUNCHER_TEXT_INTRODUCE_SPACING: number = 3.4;

  /**
   * Healthy living content top margin.
   */
  static readonly LAUNCHER_TEXT_INTRODUCE_MARGIN_TOP: string = '1.3%';

  /**
   * Interval execution time.
   */
  static readonly ADVERTISING_INTERVAL_TIME: number = 1000;

  /**
   * Advertising page url.
   */
  static readonly ADVERTISING_PAGE_URL: string = 'pages/AdvertisingPage';

  /**
   * Display countdown seconds.
   */
  static readonly ADVERTISING_COUNT_DOWN_SECONDS: number = 2;

  /**
   * Count down text spacing.
   */
  static readonly ADVERTISING_TITLE_TEXT_LETTER_SPACING: number = 0.05;

  /**
   * Advertising page healthy text spacing.
   */
  static readonly ADVERTISING_HEALTHY_LIFE_TEXT_SPACING: number = 0.1;

  /**
   * Advertising page health description text spacing.
   */
  static readonly ADVERTISING_TEXT_INTRODUCE_LETTER_SPACING: number = 3.4;

  /**
   * Advertising page health description text top margin.
   */
  static readonly ADVERTISING_TEXT_INTRODUCE_MARGIN_TOP: string = '0.4%';

  /**
   * Column container left margin.
   */
  static readonly ADVERTISING_COLUMN_MARGIN_LEFT: string = '3.1%';

  /**
   * Row container bottom margin.
   */
  static readonly ADVERTISING_ROW_MARGIN_BOTTOM: string = '3.1%';

  /**
   * Dialog component width the percentage of the 90.
   */
  static readonly DIALOG_COMPONENT_WIDTH_PERCENT: string = '90%';

  /**
   * Dialog title text weight.
   */
  static readonly DIALOG_TITLE_FONT_WEIGHT: number = 600;

  /**
   * Dialog width the percentage of the 93.3.
   */
  static readonly DIALOG_WIDTH_PERCENT: string = '93.3%';

  /**
   * Dialog border radius.
   */
  static readonly DIALOG_BORDER_RADIUS: number = 24;

  /**
   * Dialog component bottom margin,
   */
  static readonly DIALOG_ROW_MARGIN_BOTTOM: string = '3.1%';

  /**
   * Dialog y-axis offset distance.
   */
  static readonly DIALOG_CONTROLLER_DY_OFFSET: number = -24;

  /**
   * Width the percentage of the 100.
   */
  static readonly FULL_WIDTH: string = '100%';

  /**
   * Height the percentage of the 100.
   */
  static readonly FULL_HEIGHT: string = '100%';

  /**
   * Privacy page url.
   */
  static readonly PRIVACY_PAGE_URL: string = 'pages/PrivacyPage';

  /**
   * App home page url.
   */
  static readonly APP_HOME_PAGE_URL: string = 'pages/AppHomePage';

  /**
   * Common layout weight.
   */
  static readonly COMMON_LAYOUT_WEIGHT: number = 1;
  /**
   * 标题栏图标大小
   */
  static readonly TITLE_IMG_SIZE: number = 24;
  /**
   * 小说封面大小
   */
  static readonly NOVEL_IMG_WIDTH: number = 76;
  static readonly NOVEL_IMG_HEIGHT: number = 102;
  /**
   * 小说详情封面高度
   */
  static readonly NOVEL_DETAIL_IMG_HEIGHT: number = 128;
  /**
   * 小说详情页作者图标大小
   */
  static readonly NOVEL_DETAIL_AUTHOR_IMG_SIZE: number = 16;
  /**
   * 小说详情页字体大小
   */
  static readonly FONT_NOVEL_DETAIL_TITLE_SIZE: number = 20;
  static readonly FONT_NOVEL_DETAIL_AUTHOR_SIZE: number = 12;
  static readonly FONT_NOVEL_DETAIL_TAG_SIZE: number = 10;
  static readonly FONT_NOVEL_DETAIL_INFO_SIZE: number = 14;
  /**
   * 百分比
   */
  static readonly PERCENT_94: string = '94%';
  static readonly PERCENT_90: string = '90%';
  /**
   * space间距
   */
  static readonly SPACE_10: number = 10;
  static readonly SPACE_20: number = 20;

  /**
   * 小说AppStorage存储key
   */
  static readonly PREFERENCES_BOOK_INIT_KEY:string = 'PREFERENCES_BOOK_INIT_KEY'
  static readonly PREFERENCES_BOOK_DATA_KEY:string = 'PREFERENCES_BOOK_DATA_KEY'
  static readonly KEY_NOVEL_BOOK_DATA:string = 'KEY_NOVEL_BOOK_DATA'
  static readonly KEY_SOUND_BOOK_DATA:string = 'KEY_SOUND_BOOK_DATA'
  static readonly KEY_CARTOON_BOOK_DATA:string = 'KEY_CARTOON_BOOK_DATA'
  static readonly GROUP_LIST_DATA:string = 'GROUP_LIST_DATA'
  static readonly SHELF_LIST_DATA:string = 'SHELF_LIST_DATA'
  /**
   * 数据库日志标签
   */
  static readonly RDB_TAG: string = 'RdbTag';
  /**
   * 数据库配置
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: "novel.db",
    securityLevel: relationalStore.SecurityLevel.S1
  }
  /**
   * Default curve value.
   */
  static readonly UniCurve: ICurve = curves.springCurve(0, 0.5, 128, 12)
  /**
   * 字体样式
   */
  static readonly FAMILY_PingFANG: string = 'PingFang SC'
}