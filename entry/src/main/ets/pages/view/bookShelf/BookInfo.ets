@Component
/**
 * 书签
 */
export default struct BookInfo{
  //标题
  @Prop title:string
  //描述
  @Prop describe:string
  //章节
  @Prop chapter:string
  //图片
  @Prop bookImage:Resource

  @Prop searchValue:string

  @State isJoin:boolean = false

  build() {

    Flex(
      {
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.SpaceBetween
      }
    ) {
      Row({
        space:20
      }){
        Image(this.bookImage).width(60).height(80)
        Column({
          space:24
        })
        {
          Text(this.title)
            .fontWeight(700)
          Column(){
            Text(this.describe).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
            Text(this.chapter).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
          }
          .width('40%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
      }

      if (this.searchValue === '浏览历史'){
        Column({space:15}){
          Row(){
           Image($r('app.media.delete_svg')).width(17).fillColor('rgba(0, 0, 0, 0.6)')
          }
          .padding({right:5})
          Row(){
            Row({space:5}){
              Image(this.isJoin?$r("app.media.add_check"):$r("app.media.add_shelf")).width(this.isJoin?15:10).height(this.isJoin?15:10)
                .fillColor('rgba(0, 0, 0, 0.9)')
              Text('书架').fontSize(10).fontColor('rgba(0, 0, 0, 0.45)')
            } .padding({ left:15,right:15,bottom:5,top:5 })
          }
          .backgroundColor(this.isJoin?'rgba(174,174,174,0.2)':'')
          .borderColor('rgb(174,174,174)')
          .borderWidth(this.isJoin?0:1)
          .borderRadius(50)
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.End)
      }
    }
    .padding(10)
    .borderRadius(10)
    .backgroundColor('rgba(244,244,244,0.8)')

  }
}