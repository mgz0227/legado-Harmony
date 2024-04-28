import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
/**
 * 漫画
 */
@Component
export default struct cartoonPage{
  @Prop searchValue:string
  cartoonList:BookList[] = [
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1'))
  ]

  @State TypeSearch:number = 0
  build() {
    Column(
      {space:10}
    ){
      ForEach(this.cartoonList,(item:BookList) => {
        BookInfo({title:item.title,describe:item.describe,chapter:item.chapter,bookImage:item.bookImage,searchValue:this.searchValue})
      })
      Divider().vertical(false)
      Row(){
        Text('END').fontColor('rgba(84, 84, 84, 0.30)').fontWeight(500)
      }
    }
    .backgroundColor('rgba(255,250,247,0.8)')
  }
}