import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
/**
 * 漫画
 */
@Component
export default struct soundPage{

  cartoonList:BookList[] = [
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'))
  ]

  @State TypeSearch:number = 0
  build() {
    Column(
      {space:10}
    ){
      ForEach(this.cartoonList,(item:BookList) => {
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