/**
 * @author 2008
 * @datetime 2024/7/22 22:39
 * @className: BookGroup
 * 书籍分组
 */
@Observed
export class BookGroups {
  //分组Id
  groupId:number = 0;
  //分组名称
  groupName:string = "";
  //分组封面
  coverUrl?:string;
  //分组描述
  groupDescribe:string = "";
  //排序
  order:number = 0;
  //是否自动刷新
  enableRefresh:boolean = true;
  //是否显示
  show:boolean = true;
  //小说0/漫画1/有声2
  groupType:number = 0;
  //创建时间
  createTime:number = 0;
  //更新时间
  updateTime:number = 0;
}