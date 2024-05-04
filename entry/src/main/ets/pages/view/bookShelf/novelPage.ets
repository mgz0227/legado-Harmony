import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'

@Component
export default struct novelPage{
  @Prop searchValue:string
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number
  @State bookList:BookList[] = [
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
  //监听isClear变化
  onIsClearChange() {
    if (this.currentIndex === 0 && this.isClear) {
      this.bookList = []
      this.isClear = false
    }
  }

  build() {
    if (this.bookList === null || this.bookList.length === 0) {
      Column() {
        Image($r('app.media.no_record')).width(200).height(200)
        Text('暂无浏览记录').fontSize(12).fontColor('rgba(96, 96, 96, 0.6)').fontWeight(500).padding(5)
      }.margin({ top: 120 })
    } else {
      Column(
        { space: 10 }
      ) {

        ForEach(this.bookList, (item: BookList) => {
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