/**
 * Copyright (C), 2024-05-13
 * @author LinXun
 * @date 2024/5/13 15:20
 * @version 1.0
 * @description: 笔记列表组件
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import { NoteVO } from '../../../componetsmodel/NoteVO';
import CircleGeneralButton from './CircleGeneralButton';

@Component
export default struct NoteListItem {
  private moreClick = () => {};
  private noteVO: NoteVO = new NoteVO(1, '许七安幽幽醒来，嗅到了空气中潮湿的腐臭味，令人轻微的不适，胃酸翻涌', '2020-03-14 12:34');
  @State newPanel: boolean = false;
  @Builder NewPanelDialog() {
    Column({space: 12}) {
      Grid() {
        GridItem() {
          CircleGeneralButton()
        }
        GridItem() {
          CircleGeneralButton({icon: $r('app.media.ic_public_copy'), text: '复制'})
        }
        GridItem() {
          CircleGeneralButton({icon: $r('app.media.ic_public_share'), text: '分享'})
        }
        GridItem() {
          CircleGeneralButton({icon: $r('app.media.ic_public_delete'), text: '删除'})
        }
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(118)
      .columnsTemplate('1fr 1fr 1fr 1fr')
      Divider()
      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .height(56)
      .onClick(() => {
        this.newPanel = false;
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 32,
        right: 32,
        top: 16,
        bottom: 16
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .padding({top: 12, bottom: 12})
    .backgroundColor('#0f000000')

    // .width(CommonConstants.FULL_WIDTH)
    // .height(CommonConstants.FULL_HEIGHT)
  }
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
          .onClick(() => {
            this.newPanel = true;
          })
          .bindSheet($$this.newPanel, this.NewPanelDialog(), {
            height: SheetSize.FIT_CONTENT,
            showClose: false,
            dragBar: false,
            blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
            maskColor: 'rgba(0,0,0,0.6)',
            onDisappear: () => {
              // this.clickBookType = ''
            }
          })
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
      Text(this.noteVO.note)
        .fontSize(12)
        .fontWeight(400)
        .lineHeight(20)
        .fontColor('#73000000')
        .padding({top: 12})
        .border({
          width: {top: 1},
          color: '#0f000000'
        })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height('auto')
    .borderRadius(8)
    .padding({left: 16, right: 16, top: 12, bottom: this.noteVO.note === undefined ? 0 : 12})
    .backgroundColor('#0a000000')
  }
}