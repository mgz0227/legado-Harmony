export class Constants {
  /**
   * Full percent.
   */
  static readonly FULL_PERCENT: string = '100%';
  /**
   * Text.
   */
  static readonly TEXT: string = new Array(1000).fill('Text').join(' ');
  /**
   * Init font size.
   */
  static readonly INIT_FONT_SIZE: number = 20;
  /**
   * Init font size.
   */
  static readonly INIT_LINE_HEIGHT_RATIO: number = 1.8;
  /**
   * Init rotate angle one.
   */
  static readonly INIT_ROTATE_ANGLE_ONE: number = 90.0;
  /**
   * Init screen light.
   */
  static readonly INIT_SCREEN_LIGHT: number = 50;
  /**
   * Init row gap.
   */
  static readonly INIT_ROW_GAP: number = 5;
  /**
   * Screen margin left.
   */
  static readonly SCREEN_MARGIN_LEFT: number = 20;
  /**
   * Transparent.
   */
  static readonly TRANSPARENT: string = '#00000000';
  /**
   * Cover duration.
   */
  static readonly COVER_DURATION: number = 300;
  /**
   * Simulate duration.
   */
  static readonly SIMULATE_DURATION: number = 800;
  /**
   * Slide duration.
   */
  static readonly SLIDE_DURATION: number = 300;
  /**
   * Prompt duration.
   */
  static readonly PROMPT_DURATION: number = 300;
  /**
   * Message flip right.
   */
  static readonly MSG_FLIP_RIGHT: string = '向右翻页';
  /**
   * Message flip over.
   */
  static readonly MSG_FLIP_OVER: string = '翻到头了';
  /**
   * Message flip left.
   */
  static readonly MSG_FLIP_LEFT: string = '向左翻页';
  /**
   * Sheet height.
   */
  static readonly SHEET_HEIGHT: number = 552;
  /**
   * Sheet title.
   */
  static readonly SHEET_TITLE: string = '设置';
  /**
   * Sheet background color.
   */
  static readonly SHEET_BACKGROUND_COLOR: string = '#FCFCFC';
  /**
   * Canvas font set.
   */
  static readonly CANVAS_FONT_SET: string = 'px serif normal';
  /**
   * Zero percent.
   */
  static readonly ZERO_PERCENT: string = '0%';
  /**
   * One hundred.
   */
  static readonly ONE_HUNDRED: number = 100;
  /**
   * Flip duration.
   */
  static readonly FLIP_DURATION: number = 200;
  /**
   * Font weight 500.
   */
  static readonly FONT_WEIGHT_500: number = 500;
  /**
   * Title light.
   */
  static readonly TITLE_LIGHT: string = '亮度';
  /**
   * Slider max.
   */
  static readonly SLIDER_MAX: number = 100;
  /**
   * Slider step.
   */
  static readonly SLIDER_STEP: number = 10;
  /**
   * Title follow system.
   */
  static readonly TITLE_FOLLOW_SYSTEM: string = '跟随系统';
  /**
   * Title font size.
   */
  static readonly TITLE_FONT_SIZE: string = '字号';
  /**
   * Button font size subtract.
   */
  static readonly BUTTON_FONT_SIZE_SUBTRACT: string = 'A-';
  /**
   * Button font size add.
   */
  static readonly BUTTON_FONT_SIZE_ADD: string = 'A+';
  /**
   * Font size min.
   */
  static readonly FONT_SIZE_MIN: number = 10;
  /**
   * Font size step.
   */
  static readonly FONT_SIZE_STEP: number = 10;
  /**
   * Font size max.
   */
  static readonly FONT_SIZE_MAX: number = 50;
  /**
   * Title flip.
   */
  static readonly TITLE_FLIP: string = '翻页';
  /**
   * Subtitle cover.
   */
  static readonly SUBTITLE_COVER: string = '覆盖';
  /**
   * Subtitle simulate.
   */
  static readonly SUBTITLE_SIMULATE: string = '仿真';
  /**
   * Subtitle slide.
   */
  static readonly SUBTITLE_SLIDE: string = '滑动';
  /**
   * Subtitle up down.
   */
  static readonly SUBTITLE_UP_DOWN: string = '上下';
  /**
   * Title bgc.
   */
  static readonly TITLE_BGC: string = '背景';
  /**
   * Bgc row space.
   */
  static readonly BGC_ROW_SPACE: number = 12;
}

/**
 * Flip page type.
 */
export enum FlipPageType {
  COVER_FLIP_PAGE = 0,
  SIMULATE_FLIP_PAGE = 1,
  SLIDE_FLIP_PAGE = 2,
  UP_DOWN_FLIP_PAGE = 3
}

/**
 * Background color type.
 */
export enum BGColorType {
  WHITE = 0,
  YELLOW = 1,
  GREEN = 2,
  BLUE = 3
}

/**
 * Background color array.
 */
export const BG_COLOR_ARRAY: string[] = ['#FFFFFF', '#FDEAD3', '#DFF7E5', '#DFF1FA'];

/**
 * Background color title.
 */
export enum BGC_TITLE {
  WHITE = '精白',
  YELLOW = '赭黄',
  GREEN = '竹青',
  BLUE = '碧蓝'
}