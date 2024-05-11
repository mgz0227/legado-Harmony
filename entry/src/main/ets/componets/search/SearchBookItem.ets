import { SearchBook } from '../dataList/SearchBook'

@Component
export struct SearchBookItem {
  @Prop SearchValue:string
  @Prop list:String[]=[]
  @Prop book:SearchBook
  @State fontColor:string="rgba(0, 0, 0, 0.45)"
  @Builder label(item:string){
    Text(item)
      .fontSize(10)
      .fontColor(this.fontColor)
      .padding({left:7,right:7,top:3,bottom:3})
      .backgroundColor("rgba(0, 0, 0, 0.06)")
      .borderRadius(5)
  }
  build() {
    Row({space:20}){
      Image($r('app.media.cover_list')).size({
        width:70,
        height:100
      })
      Column({space:5}){
        //书名
        Row(){
          ForEach(this.list,(item:string,index:number)=>{
            Text(item)
              .fontColor(index==1?"rgba(255, 102, 0, 1)":"#000000")
          })
        }
        //作者及书源数量
        Row({space:2}){
          Text(this.book.author)
            .fontSize(14)
            .fontColor(this.fontColor)
          Text("·")
            .fontSize(14)
            .fontColor(this.fontColor)
          Text("共"+this.book.sourceNumber.toString()+"个源")
            .fontSize(14)
            .fontColor(this.fontColor)
        }

        //书籍描述
        Text(this.book.describe)
          .size({width:200,height:40})
          .fontSize(14)
          .maxLines(2)
          .fontColor(this.fontColor)
          .textOverflow({overflow:TextOverflow.Ellipsis})
        Row({space:5}){
          ForEach(this.book.label,(item:string)=>{
            this.label(item)
          })
          this.label(this.book.status?"完本":"连载中")
          this.label(this.wordStatistics())
        }.width("100%").height(20)
      }.alignItems(HorizontalAlign.Start)
    }.size({
      width:"100%",
      height:120
    }).margin({left:20,right:20})
  }
  wordStatistics(){
    let wordCount=this.book.wordCount.toString()
    let wordCountLength=wordCount.length
    if(wordCountLength>4){
      return wordCount.substring(0,wordCountLength-4)+"万字"
    }else{
      return wordCount+"字"
    }
  }
}