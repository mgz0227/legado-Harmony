/**
 * Copyright (C), 2024-05-10
 * @author LinXun
 * @date 2024/5/10 13:24
 * @version 1.0
 * @description: 书籍详情页笔记内容
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import { NoteListVO } from '../../../componetsmodel/NoteListVO';
import { NoteVO } from '../../../componetsmodel/NoteVO';
import NoteListItem from './NoteListItem'

@Component
export default struct NoteIndex {
   @State noteList: NoteListVO[] = [
    new NoteListVO(1, '第一章 牢狱之灾', [
      new NoteVO(1, '许七安幽幽醒来，嗅到了空气中潮湿的腐臭味，令人轻微的不适，胃酸翻涌', '2020-03-14 12:34', '备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息'),
      new NoteVO(2, '2许七安幽幽醒来，嗅到了空气中潮湿的腐臭味，令人轻微的不适，胃酸翻涌', '2020-03-14 12:34')
    ]),
    new NoteListVO(2, '第二章 妖物作祟', [
      new NoteVO(3, '3许七安幽幽醒来，嗅到了空气中潮湿的腐臭味，令人轻微的不适，胃酸翻涌', '2020-03-14 12:34', '备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息'),
      new NoteVO(4, '4许七安幽幽醒来，嗅到了空气中潮湿的腐臭味，令人轻微的不适，胃酸翻涌', '2020-03-14 12:34', '备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息备注信息')
    ]),
  ];
  // 表头
  @Builder
  itemHead(text: string) {
    Row() {
      Text(text)
        .fontSize(14)
        .fontWeight(500)
        .lineHeight(22)
        .fontColor('#e0000000')
      Blank()
    }
    .width(CommonConstants.FULL_WIDTH)
    .padding({bottom: 12})
  }
  build() {
    /*if (true) {
      Column() {
        Image($r('app.media.ic_public_none'))
          .width(200)
          .height(168)
        Text('暂无笔记')
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(22)
          .fontColor('#73000000')
      }
    }*/
    if (this.noteList === undefined || this.noteList.length === 0) {
      Column() {
        Image($r('app.media.ic_public_none'))
          .width(200)
          .height(168)
        Text('暂无笔记')
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(22)
          .fontColor('#73000000')
      }
    } else {
      Column() {
        List({ space: 12 }) {
          ForEach(this.noteList, (list: NoteListVO) => {
            ListItemGroup({ space: 12, header: this.itemHead(list.chapterName) }) {
              ForEach(list.noteList, (item: NoteVO) => {
                ListItem() {
                  NoteListItem({noteVO: item, saveChange: (val: string) => {
                     item.note = val;
                    }
                  })
                }
              })
            }
          })
        }
        .scrollBar(BarState.Off)
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
    }
  }
}