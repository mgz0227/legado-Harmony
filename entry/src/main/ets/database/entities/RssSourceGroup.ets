/**
 * @author 2008
 * @datetime 2024/12/6 23:31
 * @className: rssSourceGroup
 * 订阅源分组
 */
@Observed
export class RssSourceGroup{
  rssGroupId?:number;
  //分组名称
  rssGroupName:string = "";
  //排序
  groupSort?:number;
  //是否置顶
  isTop:boolean = false;
  //是否允许删除
  isDelete:boolean = true;
}