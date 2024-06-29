/**
 * @author 2008
 * @datetime 2024/6/28 22:43
 * @className: IconTitleVo
 * 图标标题
 */
export class IconTitleVo{
  icon:Resource;
  title:string;

  constructor(icon:Resource,title:string) {
    this.icon = icon
    this.title = title
  }
}