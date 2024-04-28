/**
 * 上次阅读弹窗
 */
@Component
export default struct ReadShow {
  @Link showReadShow:boolean
  build() {
    Column(){
      Flex(
        {
          alignItems:ItemAlign.Center,
          alignContent:FlexAlign.SpaceBetween
        }
      ) {
        Image($r('app.media.cover_list')).width(40).height(52)
        Column({
          space:24
        })
        {
          Text('仙人消失之后')
            .fontSize(12)
            .fontColor(Color.White)
          Column(){
            Text('上次读到340章').fontSize(12).fontColor(Color.White)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
        .padding({left:15})
        Column(){
          Text('继续阅读')
            .fontSize(12)
            .fontWeight(600)
            .padding(10)
            .borderRadius(20)
            .fontColor('#FF6600')
            .backgroundColor(Color.White)
        }
        .padding({left:55,right:30})
        Image($r('app.media.Outlined')).width(15).height(15)
          .onClick(() => {
            console.log('test')
            this.showReadShow = !this.showReadShow
            console.log(this.showReadShow + '')
          })
      }
      .borderRadius(10)
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius(10)
    .padding(10)
    .width('95%')
    .backgroundColor('rgb(182,134,102)')
  }
}