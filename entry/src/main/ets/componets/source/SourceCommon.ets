/**
 * @author 2008
 * @datetime 2024/6/28 23:57
 * @className: SourceCommon
 * 通用书源页
 */
import ImageConstants from '../../common/constants/ImageConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'
import noSourceFind from '../common/noSourceFind'
import { dataItem } from '../dataList/dataItem'
import { sourceTabs } from './sourceTabs'

@Component
@Preview
export default struct SourceCommon{
  @State sourceList:dataItem[]=[
    new dataItem("默认显示",12),
    new dataItem("隐藏书源",12)
  ]
  sourceController: TabsController = new TabsController();

  @State @Watch('changeSourceIndex')readIndex:number = 0
  changeSourceIndex(){
    this.sourceController.changeIndex(this.readIndex)
  }
  build() {
    Column(){
      Column(){
        Row({
          space:12
        }){
          Search({
            placeholder:'搜索书源'
          })
            .width('90%')
          Image($r('app.media.more_vertical')).width(ImageConstants.IMG_WIDTH_24).height(ImageConstants.IMG_WIDTH_24)
            .layoutWeight(1)
        }

        sourceTabs({
          sourceList:this.sourceList,
          read_index:this.readIndex
        })

        Tabs({
          barPosition: BarPosition.Start,
          controller: this.sourceController
        }){
          TabContent(){
            this.sourceBuilder()
          }
          .align(Alignment.Top)
          TabContent(){
            Text('222')
          }
          .align(Alignment.Top)
        }
        .barWidth(0)
        .barHeight(0)
        .scrollable(false)

      }
      .padding({left:PaddingConstants.PADDING_20,right:PaddingConstants.PADDING_20})
      .justifyContent(FlexAlign.Center)
    }
  }

  @Builder
  sourceBuilder(){
    Flex({
      justifyContent:FlexAlign.Center
    }){
      noSourceFind({
        isShowButton:true,
        title:'暂无书源'
      })
    }
  }
}