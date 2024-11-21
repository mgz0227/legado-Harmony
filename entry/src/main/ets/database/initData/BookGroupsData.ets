/**
 * @author 2008
 * @datetime 2024/7/22 22:42
 * @className: BookGroup
 * 书籍分组
 */
@Observed
export class BookGroupsData {
  //分组Id
  groupId?:number;
  //分组名称
  groupName:string = "";
  //封面是否仅用当前分组
  coverOnly:boolean = false;
  //封面样式类型 0默认1自定义2全图
  coverType:number = 0;
  //分组封面
  coverUrl?:string;
  //分组描述
  groupDescribe?:string;
  //排序
  sort:number = 1;
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
  //书籍排序
  bookSort:number = -1;
  //更新提醒
  canUpdate:boolean = false
  //是否可删除
  canDelete:boolean = true

  constructor(bookGroupsData?:BookGroupsData) {
    if (!bookGroupsData) return;
    this.groupName = bookGroupsData.groupName;
    this.coverOnly = bookGroupsData.coverOnly;
    this.coverType = bookGroupsData.coverType;
    this.coverUrl = bookGroupsData.coverUrl;
    this.groupDescribe = bookGroupsData.groupDescribe;
    this.sort = bookGroupsData.sort;
    this.enableRefresh = bookGroupsData.enableRefresh;
    this.show = bookGroupsData.show;
    this.groupType = bookGroupsData.groupType;
    this.createTime = bookGroupsData.createTime;
    this.updateTime = bookGroupsData.updateTime;
    this.bookSort = bookGroupsData.bookSort;
    this.canUpdate = bookGroupsData.canUpdate;
    this.canDelete = bookGroupsData.canDelete;
  }
}