import { BookList } from '../dataList/bookList'
import { promptAction } from '@kit.ArkUI'
import BookInfoManage from './BookInfoManage'
import BookInfoGridManage from './BookInfoGridManage'
import delDialogExample from '../common/delDialog'

@Component
export default struct bookListManage{
  @Link @Watch('onIsClearChange') isClear:boolean
  @Link allCheck:boolean
  @Prop @Watch('onIsEXHIBITChange') EXHIBIT:string
  @State @Watch('isChangeBookList')checkBookList:BookList[] = []
  @Link showBookList:BookList[]
  @Link checkNumber:number


  //监听isClear变化
  onIsClearChange() {
    if (this.checkBookList === null || this.checkBookList.length === 0) {
      promptAction.showToast({
        message: '请选择要删除的内容',
        duration: 1000,
      })
      this.isClear = false
      return
    }
    if (this.isClear) {
      this.bookInfoDel?.open()
    }
  }

  deleteBook() {
    for (let index = 0; index < this.checkBookList.length; index++) {
     this.showBookList = this.showBookList.filter(book => book.bookId !== this.checkBookList[index].bookId);
    }
    console.log(JSON.stringify(this.showBookList))
    this.isClear = false
    this.allCheck = false
    this.checkBookList = []
    promptAction.showToast({
      message: '删除成功',
    })
  }

  isChangeBookList() {
    this.checkNumber = this.checkBookList.length
  }

  //监听EXHIBIT变化
  onIsEXHIBITChange() {
    console.log(this.EXHIBIT)
  }

  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: delDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() }
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  onCancel() {
    this.isClear = false
  }

  onAccept() {
    this.deleteBook()
  }

  exitApp() {
    this.isClear = false
  }

  build() {
    if (this.showBookList === null || this.showBookList.length === 0) {
      Column() {
        Image($r('app.media.no_record')).width(200).height(200)
        Text('暂无浏览记录').fontSize(12).fontColor('rgba(96, 96, 96, 0.6)').fontWeight(500).padding(5)
      }
      .margin({ top: 120 })

    } else {
      Column(
        {space:10}
      ){
        if (this.EXHIBIT === '宫格') {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
            ForEach(this.showBookList, (item: BookList,index:number) => {
              BookInfoGridManage({
                bookId:item.bookId,
                title: item.title + this.EXHIBIT,
                describe: item.describe,
                chapter: item.chapter,
                bookImage: item.bookImage,
                isJoin:item.isJoin,
                allCheck:this.allCheck,
                checkBookList:this.checkBookList
              }).width('33%')
            })
          }
        } else {
          Column(
            { space: 10 }
          ) {
            ForEach(this.showBookList, (item: BookList,index:number) => {
              BookInfoManage({
                bookId:item.bookId,
                title: item.title,
                describe: item.describe,
                chapter: item.chapter,
                bookImage: item.bookImage,
                isJoin:item.isJoin,
                allCheck:this.allCheck,
                checkBookList:this.checkBookList
              })
            })
          }
          .backgroundColor('rgba(255,250,247,0.8)')
        }
        // Divider().vertical(false)
        // Row() {
        //   Text('END').fontColor('rgba(84, 84, 84, 0.30)').fontWeight(500)
        // }
      }

    }
  }
}