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
  @Prop isShowCheck:boolean
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number
  @State lastIndex:number = 9999
  @Prop @Watch('onIsEXHIBITChange') EXHIBIT:string
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

  removeListByIndex(index:number){
    if (this.lastIndex === index) {
      return
    }
    this.lastIndex = index
    this.cartoonList.splice(index,1)
    promptAction.showToast({
      message: '删除成功',
      duration: 1000,
    })
    //防止快速点击删除
    setTimeout(()=>{
      this.lastIndex = 9999
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
        if (this.EXHIBIT === '宫格') {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
            ForEach(this.cartoonList, (item: BookList,index:number) => {
              BookInfoGrid({
                title: item.title + this.EXHIBIT,
                describe: item.describe,
                chapter: item.chapter,
                bookImage: item.bookImage,
                isJoin:item.isJoin,
                searchValue: this.searchValue,
                isShowCheck:this.isShowCheck,
                onDelete:(): void=>this.removeListByIndex(index)
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
                isShowCheck:this.isShowCheck,
                onDelete:(): void=>this.removeListByIndex(index)
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