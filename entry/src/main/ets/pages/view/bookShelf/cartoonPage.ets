import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
import { promptAction } from '@kit.ArkUI'
import BookInfoGrid from './BookInfoGrid'

/**
 * 漫画
 */
@Component
export default struct cartoonPage{
  @Prop searchValue:string
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number
  @State lastIndex:string = '9999'
  @Prop @Watch('onIsEXHIBITChange') EXHIBIT:string
  @State cartoonList:BookList[] = [
    new BookList('1','极主夫道','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list1'),true)
    ,new BookList('2','极主夫道','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('3','极主夫道','会说话的肘子·未读过3','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('4','极主夫道','会说话的肘子·未读过4','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('5','极主夫道','会说话的肘子·未读过5','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('6','极主夫道','会说话的肘子·未读过6','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('7','极主夫道','会说话的肘子·未读过7','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('8','极主夫道','会说话的肘子·未读过8','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('9','极主夫道','会说话的肘子·未读过9','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('10','极主夫道','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list1'))
  ]
  onIsClearChange() {
    if (this.currentIndex === 1 && this.isClear) {
      this.cartoonList = []
      this.isClear = false
      promptAction.showToast({
        message: '清空成功',
        duration: 1000,
      })
    }
  }

  //监听EXHIBIT变化
  onIsEXHIBITChange() {
    console.log(this.EXHIBIT)
  }

  removeListByIndex(bookId:string){
    if (this.lastIndex === bookId) {
      return
    }
    this.lastIndex = bookId
    this.cartoonList = this.cartoonList.filter(book => book.bookId !== bookId);
    promptAction.showToast({
      message: '删除成功',
      duration: 1000,
    })
    //防止快速点击删除
    setTimeout(()=>{
      this.lastIndex = '9999'
    },500)
  }

  build() {
    if (this.cartoonList === null || this.cartoonList.length === 0) {
      Column() {
        Image($r('app.media.no_record')).width(200).height(200)
        Text('暂无浏览记录').fontSize(12).fontColor('rgba(96, 96, 96, 0.6)').fontWeight(500).padding(5)
      }.margin({ top: 120 })
    } else {
      Column(
        {space:10}
      ){
        if (this.EXHIBIT === '宫格' && this.searchValue !== '浏览历史') {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
            ForEach(this.cartoonList, (item: BookList,index:number) => {
              BookInfoGrid({
                title: item.title + this.EXHIBIT,
                describe: item.describe,
                chapter: item.chapter,
                bookImage: item.bookImage,
                isJoin:item.isJoin,
                searchValue: this.searchValue,
                onDelete:(): void=>this.removeListByIndex(item.bookId)
              }).width('33%')
            })
          }
        } else {
          Column(
            { space: 10 }
          ) {
            ForEach(this.cartoonList, (item: BookList,index:number) => {
              BookInfo({
                title: item.title,
                describe: item.describe,
                chapter: item.chapter,
                bookImage: item.bookImage,
                isJoin:item.isJoin,
                searchValue: this.searchValue,
                onDelete:(): void=>this.removeListByIndex(item.bookId)
              })
            })
          }
          .backgroundColor('rgba(255,250,247,0.8)')
        }
        Divider().vertical(false)
        Row() {
          Text('END').fontColor('rgba(84, 84, 84, 0.30)').fontWeight(500)
        }
      }

    }
  }
}