/**
 * Copyright (C), 2024-05-03
 * @author LinXun
 * @date 2024/5/3 13:55
 * @version 1.0
 * @description: 小说详情页标签组件
 */
import CommonConstants from '../../common/constants/CommonConstants'

@Component
export default struct TagIndex {
  private tag: string = '幻想修仙';
  build() {
    Column() {
      Text(this.tag)
        .fontSize(CommonConstants.FONT_NOVEL_DETAIL_TAG_SIZE)
        .fontColor('#73ffffff')
    }
    .justifyContent(FlexAlign.Center)
    .padding({left: 6, right: 6})
    .borderRadius(4)
    .backgroundColor('#14ffffff')
    .height(16)
  }
}