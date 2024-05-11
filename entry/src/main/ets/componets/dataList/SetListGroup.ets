

export class SetGroupList {

  groupValue: string


  setList: SetList[]

  constructor(groupValue: string, setList: SetList[]) {
    this.groupValue = groupValue;
    this.setList = setList;
  }
}

@Observed
export class SetList{

  /**
   * 是否显示箭头
   */
  showArrow: boolean

  /**
   *
   */
  value: string

  /**
   * 右边按钮状态
   */
  toggleStatus?: boolean

  /**
   * 右边文字
   */
  rightText?: string

  /**
   * 下面文字
   */
  bottomText?: string


  storageName: string



  constructor(
    showArrow: boolean,
    value: string,
    toggleStatus?: boolean,
    rightText?: string,
    bottomText?: string,
    storageName?: string
  ) {
    this.showArrow = showArrow;
    this.value = value;
    this.toggleStatus = toggleStatus || false; // 如果未传入toggleStatus，则默认为false
    this.rightText = rightText || ''; // 如果未传入rightText，则默认为空字符串
    this.bottomText = bottomText || ''; // 如果未传入bottomText，则默认为空字符串
    this.storageName = storageName || '';
  }

}