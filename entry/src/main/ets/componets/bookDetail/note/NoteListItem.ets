/**
 * Copyright (C), 2024-05-13
 * @author LinXun
 * @date 2024/5/13 15:20
 * @version 1.0
 * @description: 笔记列表组件
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import { NoteVO } from '../../../componetsmodel/NoteVO';

@Component
export default struct NoteListItem {
  private noteVO: NoteVO = new NoteVO(1, '许七安幽幽醒来，嗅到了空气中潮湿的腐臭味，令人轻微的不适，胃酸翻涌', '2020-03-14 12:34');
  build() {
    Column({space: 12}) {
      Row() {
        Text(this.noteVO.createTime)
          .fontSize(12)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor('#73000000')
        Blank()
        Image($r('app.media.more'))
          .width(16)
          .height(16)
          .fillColor('#73000000')
      }
      .height(20)
      .width(CommonConstants.FULL_WIDTH)
      Text() {
        ImageSpan($r('app.media.ic_public_note_quote'))
          .width(20)
          .height(20)
        Span(this.noteVO.noteContent)
          .fontSize(12)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor('#e0000000')
      }
      if (this.noteVO.note === undefined) {
        Divider()
          .color('#0f000000')
          .width(1)
        }
      Text(this.noteVO.note)
        .fontSize(12)
        .fontWeight(400)
        .lineHeight(20)
        .fontColor('#73000000')
    }
    .width(CommonConstants.FULL_WIDTH)
    .height('auto')
    .borderRadius(8)
    .padding({left: 16, right: 16, top: 12, bottom: this.noteVO.note === undefined ? 0 : 12})
    .backgroundColor('#0a000000')
  }
}