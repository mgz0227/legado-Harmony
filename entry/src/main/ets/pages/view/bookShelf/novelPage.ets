import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'

@Component
export default struct novelPage{
  bookList:BookList[] = [
      new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过','更新至·第340章 镇压',$r('app.media.cover_list'))
  ]
  @State TypeSearch:number = 0
  build() {
    Column(
      {space:10}
    ){
      ForEach(this.bookList,(item:BookList) => {
        BookInfo({title:item.title,describe:item.describe,chapter:item.chapter,bookImage:item.bookImage})
      })

      Divider().vertical(false)
      Row(){
        Text('END').fontColor('rgba(84, 84, 84, 0.30)').fontWeight(500)
      }
    }
    .backgroundColor('rgba(255,250,247,0.8)')
  }
}