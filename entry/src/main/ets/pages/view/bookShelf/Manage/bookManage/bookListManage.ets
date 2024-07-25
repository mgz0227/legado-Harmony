import BookInfoManage from './BookInfoManage'
import BookInfoGridManage from './BookInfoGridManage'
import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import { Books } from '../../../../../database/entities/Books'

@Component
export default struct bookListManage{
  @Prop EXHIBIT:string
  @Link checkList:string[]
  @Link bookList:Books[]
  @Prop shelfType:number
  @Prop isManage:boolean = true

  isTopChange(){

  }

  @State delCache:boolean = false
  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      delCache:this.delCache,
      isShowCache:true
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  onCancel() {

  }

  onAccept() {

  }

  exitApp() {

  }

  build() {
    if (this.bookList === null || this.bookList.length === 0) {
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
         GridRow({
           columns: 3
         }){
           ForEach(this.bookList, (item: Books,index:number) => {
             GridCol(){
               BookInfoGridManage({
                 bookData:item,
                 isManage:this.isManage
               })
             }
           })
         }
        } else {
          Column({
            space: 10
          }) {
            ForEach(this.bookList, (item: Books,index:number) => {
              BookInfoManage({
                bookData:item,
                isManage:this.isManage
              })
            })
          }
        }
      }

    }
  }
}