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

/**
 * Common constants for all features.
 */
export default class MySetConstants {
  /**
   * 自动刷新
   */
  static readonly SET_REFRESH: string = 'setRefresh';

  /**
   * 自动跳转最近阅读
   */
  static readonly SET_JUMP: string = 'setJump';

  /**
   * 默认启用替换净化
   */
  static readonly SET_REPLACE: string = 'setReplace';

  /**
   *返回时提示放入书架
   */
  static readonly SET_TIP: string = 'setTip';

  /**
   *图片抗锯齿
   */
  static readonly SET_IMG_ANTI: string = 'setImgAnti';

  /**
   *Webservice唤醒锁
   */
  static readonly SET_AWAKEN: string = 'setAwaken';

  /**
   *全程响应耳机按键
   */
  static readonly SET_HEAD: string = 'setHead';

  /**
   *文字操作显示搜索
   */
  static readonly SET_SEARCH: string = 'setSearch';


  static readonly SET_BOOK_SAVE: string = 'setBookSave';

  static readonly SET_PRE_DOWNLOAD: string = 'setPreDownload';

  static readonly SET_IMG_CACHE: string = 'setImgCache';

  static readonly SET_WEB_PORT: string = 'setWebPort';

  static readonly SET_CLEAR_WEB: string = 'setClearWeb';

  static readonly SET_USER_AGENT: string = 'setUserAgent';

  static readonly SET_LANGUAGE: string = 'setLanguage';
}