import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
/**
 * 漫画
 */
@Component
export default struct cartoonPage{
  @Prop searchValue:string
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number
  @State lastIndex:number = 9999
  @State cartoonList:BookList[] = [
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1')),
    new BookList('极主夫道','会说话的肘子','更新至·第340章 镇压',$r('app.media.cover_list1'))
  ]
  onIsClearChange() {
    if (this.currentIndex === 1 && this.isClear) {
      this.cartoonList = []
      this.isClear = false
    }
  }

  removeListByIndex(index:number){
    if (this.lastIndex === index) {
      return
    }
    this.lastIndex = index
    this.cartoonList.splice(index,1)
    //防止快速点击删除
    setTimeout(()=>{
      this.lastIndex = 9999
    },500)
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

        ForEach(this.cartoonList, (item: BookList,index: number) => {
          BookInfo({
            title: item.title,
            describe: item.describe,
            chapter: item.chapter,
            bookImage: item.bookImage,
            searchValue: this.searchValue,
            onDelete:(): void=>this.removeListByIndex(index)
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