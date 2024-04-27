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

  build() {

    Flex(
      {
        alignItems:ItemAlign.Stretch
      }
    ) {
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
        .width('50%')
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .padding({left:15})
    }
    .borderRadius(10)
    .backgroundColor('rgba(244,244,244,0.8)')

  }
}