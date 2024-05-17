/**
 * Copyright (C), 2024-05-15
 * @author LinXun
 * @date 2024/5/15 13:03
 * @version 1.0
 * @description: 圆形通用按钮
 */
@Component
export default struct CircleGeneralButton {
  private icon: ResourceStr = $r('app.media.ic_public_edit');
  private text: string = '编辑';
  build() {
    Column({space: 8}) {
      Column() {
        Image(this.icon)
          .width(24)
          .height(24)
          .fillColor('#a6000000')
      }
      .backgroundColor('#FFFFFF')
      .padding({
        left: 12,
        right: 12,
        top: 12,
        bottom: 12
      })
      .border({
        width: 0.5,
        color: '#26000000'
      })
      .borderRadius(200)
      Text(this.text)
        .fontSize(12)
        .fontWeight(400)
        .lineHeight(20)
        .fontColor('#a6000000')
    }
    .padding({top: 16, bottom: 12})
    .height(118)
  }
}