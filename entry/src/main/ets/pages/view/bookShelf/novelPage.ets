import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
import { promptAction } from '@kit.ArkUI'
import BookInfoGrid from './BookInfoGrid'

@Component
export default struct novelPage{
  @Prop searchValue:string
  @Prop isShowCheck:boolean
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number
  @State lastIndex:number = 9999
  @Prop allCheck:boolean = false
  // @Link @Watch('isChangeManageDelete') manageDelete:boolean
  @Prop @Watch('onIsEXHIBITChange') EXHIBIT:string
  @State checkBookList:BookList[] = []
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

  // isChangeManageDelete() {
  //   if (this.manageDelete) {
  //     if (this.checkBookList === null || this.checkBookList.length === 0) {
  //       promptAction.showToast({
  //         message: '请选择要删除的内容',
  //         duration: 1000,
  //       })
  //       this.manageDelete = false
  //       return
  //     }
  //     this.bookList = []
  //     console.log('删除')
  //     this.manageDelete = false
  //   }
  // }
  // isChangeBookList() {
  //   console.log(this.checkBookList + '')
  // }

  //监听EXHIBIT变化
  onIsEXHIBITChange() {
    console.log(this.EXHIBIT)
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
        {space:10}
      ){
        if (this.EXHIBIT === '宫格' && this.searchValue !== '浏览历史') {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
            ForEach(this.bookList, (item: BookList,index:number) => {
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
            ForEach(this.bookList, (item: BookList,index:number) => {
              BookInfo({
                title: item.title,
                describe: item.describe,
                chapter: item.chapter,
                bookImage: item.bookImage,
                isJoin:item.isJoin,
                searchValue: this.searchValue,
                isShowCheck:this.isShowCheck,
                allCheck:this.allCheck,
                checkBookList:this.checkBookList,
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