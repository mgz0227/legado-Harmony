export class NavItem {
  /**
   * 选中图片
   */
  selectImg:Resource

  /**
   * 未选样式
   */
  unselected:Resource

  /**
   * 是否选择
   */
  isSelect:boolean = false

  /**
   * 标题
   */

  title:string

  /**
   * Index
   */
  index:number



  constructor(index = 0 ,selectImg:Resource,unselected:Resource ,title = '') {
    this.selectImg = selectImg
    this.unselected = unselected
    this.title = title
    this.index = index
  }
}

export class MainScrollBar {
  //是否滚动
  isStop:boolean
  //滚动位置
  yOffsetTop:number = 0
  //Scroll
  isScroll:Scroller

  constructor(isStop:boolean,isScroll:Scroller,yOffsetTop:number = 0) {
    this.isStop = isStop
    this.yOffsetTop = yOffsetTop
    this.isScroll = isScroll
  }

}
