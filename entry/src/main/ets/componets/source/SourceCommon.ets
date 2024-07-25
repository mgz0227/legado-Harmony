/**
 * @author 2008
 * @datetime 2024/6/28 23:57
 * @className: SourceCommon
 * 通用书源页
 */
import ImageConstants from '../../common/constants/ImageConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'
import { IconTitleVo } from '../../componetsmodel/IconTitleVo'
import dialogTitleFuction from '../common/dialogTitleFuction'
import { showMessage } from '../common/promptShow'
import { dataItem } from '../dataList/dataItem'
import { sourceTabs } from './sourceTabs'
import SourceView from './SourceView'
import { router } from '@kit.ArkUI'

@Component
@Preview
export default struct SourceCommon {
  @Prop currentIndex: number
  @State sourceList: dataItem[] = [
    new dataItem("默认显示", 12),
    new dataItem("隐藏书源", 12)
  ]
  @Link showDialog: boolean
  sourceController: TabsController = new TabsController();
  @State @Watch('changeSourceIndex') readIndex: number = 0
  @State showMoreDialog: boolean = false
  @State searchValue: string = ''
  @State isBatch: boolean = false
  @Link refreshCount: number

  changeSourceIndex() {
    this.sourceController.changeIndex(this.readIndex)
  }

  build() {
    Column() {
      Column() {
        Stack() {
          Column() {
            Row({
              space: 12
            }) {
              Search({
                value: this.searchValue,
                placeholder: '搜索书源'
              })
                .width('90%')
                .onChange((value: string) => {
                  this.searchValue = value
                })

              Image($r('app.media.more_vertical'))
                .width(ImageConstants.IMG_WIDTH_24)
                .height(ImageConstants.IMG_WIDTH_24)
                .layoutWeight(1)
                .bindMenu(
                  this.showMoreDialog,
                  this.rightDialogBuilder(this.More_Right_Dialog_Data, async (index: number) => {
                    switch (index) {
                      case 0:
                      case 1:
                        showMessage(this.More_Right_Dialog_Data[index].title);
                        break;
                      case 2:
                        this.showDialog = false
                        router.pushUrl({
                          url: 'pages/view/Find/BookSource/Index'
                        })
                        break;
                      case 3:
                        this.isBatch = true
                        break;
                    }
                  }),
                  {
                    onDisappear: () => {
                      this.showMoreDialog = false
                    }
                  })
                .onClick(() => {
                  this.showMoreDialog = true
                })
            }

            sourceTabs({
              sourceList: this.sourceList,
              read_index: this.readIndex
            })
          }
          .padding({
            left: PaddingConstants.PADDING_20,
            right: PaddingConstants.PADDING_20
          })
          .translate({ y: !this.isBatch ? 0 : -120 })
          .animation({
            duration: 500,
            delay: 0
          })
          .zIndex(1)

          Tabs({
            barPosition: BarPosition.Start,
            controller: this.sourceController
          }) {
            ForEach([0, 1], (item: number) => {
              TabContent() {
                SourceView({
                  searchValue: this.searchValue,
                  isBatch: this.isBatch,
                  type: this.currentIndex,
                  index: item,
                  refreshCount: this.refreshCount,
                  closeDialog: () => {
                    this.showDialog = false
                  }
                })
              }
              .height('100%')
              .align(Alignment.Top)
            })
          }
          .barWidth(0)
          .barHeight(0)
          .scrollable(false)
          .layoutWeight(1)
          .padding({ top: this.isBatch ? 0 : 120 })
        }
        .alignContent(Alignment.Top)
      }
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor('#f5f5f5')
  }

  More_Right_Dialog_Data: IconTitleVo[] = [
    new IconTitleVo($r('app.media.appointment_time'), '按时间排序'),
    new IconTitleVo($r('app.media.icon_no_source_find'), '按评分排序'),
    new IconTitleVo($r('app.media.add_book_shelf'), '书源管理'),
    new IconTitleVo($r('app.media.icon_rule_batch'), '批量管理'),
  ]

  @Builder
  rightDialogBuilder(list: IconTitleVo[], dialogRightChange: (_index: number) => void) {
    Column() {
      ForEach(list, (item: IconTitleVo, index) => {
        dialogTitleFuction({
          title: item.title,
          icon: item.icon,
          isBorder: list.length !== index + 1
        })
          .onClick(() => {
            dialogRightChange(index)
          })
      })
    }
  }
}