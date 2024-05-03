/**
 * Copyright (C), 2024-05-03
 * @author LinXun
 * @date 2024/5/3 15:40
 * @version 1.0
 * @description: 阅读记录
 */
@Component
export default struct ReadRecordItem {
  private count: number = 243;
  private unit: string = '小时';
  private placeText: string = '阅读时长';
  build() {
    Column() {
      Text() {
        Span(this.count.toString())
          .fontSize(20)
          .fontWeight(400)
          .lineHeight(24)
        Span(this.unit)
          .fontSize(12)
          .fontWeight(400)
          .lineHeight(20)
      }
      .fontColor('#FFFFFF')
      .height(24)
      Text(this.placeText)
        .fontSize(12)
        .fontWeight(400)
        .lineHeight(20)
        .fontColor('#73ffffff')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height(44)
    .width(106)
  }
}