import CommonConstants from '../common/constants/CommonConstants'
import { BookList } from '../componets/dataList/bookList'
import { shelfList } from '../componets/dataList/shelfList'

let SHELF_LIST_KEY = 'SHELF_LIST_DATA'

const SHELF_LIST_DATA:shelfList[] = [
    new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
      new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
    ]),
  new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
    new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ]),
  new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
    new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
  ,
  new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
    new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
  ])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
  , new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
  new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')
])
]

export const shelfInitAppData = ()=>{
  AppStorage.setOrCreate(CommonConstants.SHELF_LIST_DATA,SHELF_LIST_DATA)
}