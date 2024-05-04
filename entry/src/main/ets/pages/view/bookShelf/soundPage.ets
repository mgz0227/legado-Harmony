import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
/**
 * 漫画
 */
@Component
export default struct soundPage{
  @Prop searchValue:string
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number

  @State cartoonList:BookList[] = [
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
  //监听isClear变化
  onIsClearChange() {
    if (this.currentIndex === 2 && this.isClear) {
      this.cartoonList = []
      this.isClear = false
    }
  }

  build() {
    if (this.cartoonList === null || this.cartoonList.length === 0) {
      Column() {
        Image($r('app.media.no_record')).width(200).height(200)
        Text('暂无浏览记录').fontSize(12).fontColor('rgba(96, 96, 96, 0.8)').fontWeight(500)
      }.margin({ top: 120 })
    } else {
      Column(
        { space: 10 }
      ) {

        ForEach(this.cartoonList, (item: BookList) => {
          BookInfo({
            title: item.title,
            describe: item.describe,
            chapter: item.chapter,
            bookImage: item.bookImage,
            searchValue: this.searchValue
          })
        })
        Divider().vertical(false)
        Row() {
          Text('END').fontColor('rgba(84, 84, 84, 0.30)').fontWeight(500)
        }
      }
      .backgroundColor('rgba(255,250,247,0.8)')
    }
  }
}