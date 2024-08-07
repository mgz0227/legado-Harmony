/**
 * @author 2008
 * @datetime 2024/7/19 22:02
 * @className: RssSourceGroup
 * 订阅源分组选择弹窗
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import buttonCommon from '../../../../componets/common/buttonCommon'
import { showMessage } from '../../../../componets/common/promptShow'
import programDataPreferences from '../../../../preferences/programDataPreferences'

@Component
export default struct RssSourceGroup {
  @State sourceGroupList:string[] = []
  confirm: Function = ()=>{

  }
  cancel:Function = () =>{

  }

  aboutToAppear() {
   this.getRssSourceList()
  }

  getRssSourceList() {
    this.sourceGroupList = programDataPreferences.getRssSourcesListData()
  }

  @Link moveGroup:string
  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }) {
      Row({
        space:5
      }){
        Text('移动至').fontSize(16).fontWeight(700).lineHeight(24)
        Text(`${this.moveGroup}`).fontSize(16).fontWeight(700).lineHeight(24).fontColor($r('app.color.theme_color'))
      }
      .padding({
        right:20,
        left:20,
        top:12,
        bottom:12
      })
      Divider()
      Scroll(){
        GridRow({
          columns:3
        }){
          ForEach(this.sourceGroupList, (item: string, index: number) => {
            GridCol(){
              this.titleBuilder(item)
            }
          })
        }
      }
      .padding(PaddingConstants.PADDING_20)
      .align(Alignment.Top)
      .height('60%')
      .scrollBar(BarState.Off)
      Column(){
        Divider().strokeWidth(0.5)
        buttonCommon({
          confirm:()=>{
            this.confirm()
          },
          cancel:()=>{
            this.cancel()
          }
        })
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder titleBuilder(title:string) {
    Column() {
      Text(title).fontSize(14).textOverflow({
        overflow:TextOverflow.Ellipsis
      }).ellipsisMode(EllipsisMode.END).maxLines(1)
    }
    .onClick(()=>{
      showMessage(title)
      this.moveGroup = title
    })
    .width(96)
    .margin({bottom:PaddingConstants.PADDING_16})
    .backgroundColor($r('app.string.color_black_6'))
    .padding({
      left:16,
      right:16,
      top:8,
      bottom:8
    })
  }
}