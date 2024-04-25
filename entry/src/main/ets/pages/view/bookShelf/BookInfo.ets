@Component

export default struct BookInfo{
  build() {

    Flex(
      {
        alignItems:ItemAlign.Stretch
      }
    ) {
      Image($r('app.media.cover_list')).width(60).height(80)
      Column({
        space:24
      })
      {
        Text('仙人消失之后')
          .fontWeight(700)
        Column(){
          Text('会说话的肘子·未读过').fontSize(12).fontColor('rgb(174,174,174)')
            .margin({bottom:5})
          Text('更新至·第340章 镇压').fontSize(12).fontColor('rgb(174,174,174)')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .padding({left:15})
    }
    .borderRadius(10)
    .backgroundColor('rgba(244,244,244,0.8)')

  }
}