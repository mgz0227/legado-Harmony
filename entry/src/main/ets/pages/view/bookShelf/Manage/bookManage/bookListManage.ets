import BookInfoManage from './BookInfoManage'
import BookInfoGridManage from './BookInfoGridManage'
import { Books } from '../../../../../database/entities/Books'

@Component
export default struct bookListManage{
  @Prop EXHIBIT:string
  @Prop bookList:Books[]
  @Prop isManage:boolean = true
  @Link checkGroup:Record<number, boolean>
  @State delCache:boolean = false
  onSelect:Function = () => {}
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
                 isManage:this.isManage,
                 checkGroup:this.checkGroup,
                 onSelect: ()=>{
                   this.onSelect()
                 }
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
                isManage:this.isManage,
                checkGroup:this.checkGroup,
                onSelect: ()=>{
                  this.onSelect()
                }
              })
            })
          }
        }
      }

    }
  }
}