import { BookList } from '../../../componets/dataList/bookList'
import BookInfo from './BookInfo'
import { promptAction } from '@kit.ArkUI'
import BookInfoGrid from './BookInfoGrid'
import CommonConstants from '../../../common/constants/CommonConstants'
import { delBookListAll, delBookListByBookId, getBookData } from '../../../storage/bookListData'

/**
 * 有声书
 */
@Component
export default struct soundPage{
  @Prop searchValue:string
  @Link @Watch('onIsClearChange') isClear:boolean
  @Prop currentIndex:number
  @State lastIndex:string = '9999'
  @Prop @Watch('onIsEXHIBITChange') EXHIBIT:string

  soundList:BookList[] = []

  aboutToAppear(): void {
    this.soundList = getBookData(2) as BookList[] //初始化数据
  }
  //监听isClear变化
  onIsClearChange() {
    if (this.currentIndex === 2 && this.isClear) {
      delBookListAll(2)
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
    delBookListByBookId(2, bookId)
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
    if (this.soundList === null || this.soundList.length === 0) {
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
            ForEach(this.soundList, (item: BookList,index:number) => {
              BookInfoGrid({
                bookData:item,
                onDelete:(): void=>this.removeListByIndex(item.bookId)
              }).width('33%')
            })
          }
        } else {
          Column(
            { space: 10 }
          ) {
            ForEach(this.soundList, (item: BookList,index:number) => {
              BookInfo({
                bookData:item,
                currentIndex:this.currentIndex,
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