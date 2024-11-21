
@Component
export default struct InsideCircleIcon{
  @Prop icon:Resource
  @Prop title:string
  build() {
    Column({
      space:8
    }){
      Column(){
        Image(this.icon)
          .width(24)
          .height(24)
          .margin(12)
      }
      .borderRadius(50)
      .border({width:0.5,color:'rgba(0, 0, 0, 0.15)'})

      Text(this.title)
        .fontColor($r('app.string.color_black_65'))
        .fontSize(12)
        .fontWeight(400)
        .lineHeight(20)
    }
    .alignItems(HorizontalAlign.Center)
    .padding({bottom:28})
  }
}