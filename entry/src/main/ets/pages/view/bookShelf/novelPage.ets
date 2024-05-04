import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
import { ifaa } from '@kit.OnlineAuthenticationKit'
import { promptAction } from '@kit.ArkUI'

@Component
export default struct novelPage{
  @Prop searchValue:string
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number
  @State lastIndex:number = 9999
  @State bookList:BookList[] = [
      new BookList('仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),true)
    ,new BookList('仙人消失之后','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过3','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过4','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过5','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过6','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过7','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过8','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过9','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('仙人消失之后','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list'))
  ]
  //监听isClear变化
  onIsClearChange() {
    if (this.currentIndex === 0 && this.isClear) {
      this.bookList = []
      this.isClear = false
      promptAction.showToast({
        message: '清空成功',
        duration: 1000,
      })
    }
  }

  removeListByIndex(index:number){
    if (this.lastIndex === index) {
      return
    }
    this.lastIndex = index
    this.bookList.splice(index,1)
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
    if (this.bookList === null || this.bookList.length === 0) {
      Column() {
        Image($r('app.media.no_record')).width(200).height(200)
        Text('暂无浏览记录').fontSize(12).fontColor('rgba(96, 96, 96, 0.6)').fontWeight(500).padding(5)
      }.margin({ top: 120 })
    } else {
      Column(
        { space: 10 }
      ) {

        ForEach(this.bookList, (item: BookList,index:number) => {
          BookInfo({
            title: item.title,
            describe: item.describe,
            chapter: item.chapter,
            bookImage: item.bookImage,
            isJoin:item.isJoin,
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