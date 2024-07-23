@Observed
export class Bookmark {
  //书单Id
  markId:number = 0;
  //书单名称
  markName:string = "";
  //书单描述
  markDescribe:string = "";
  //备注
  markRemark:string = "";
  //书单添加的书籍Id分割请用,
  markBooks?:string;
  //推荐理由
  markRecommend:string = "";
  //创建时间
  createTime:number = 0;
}