/**
 * @author 2008
 * @datetime 2024/5/23 22:35
 * @className: InsideCircleIcon
 */
import { buttonList } from '../dataList/buttonList'

@Component
export default struct operateIcon{
  @Prop item:buttonList
  build() {
    Column({
      space:4
    }){
      Image(this.item.icon)
        .width(24).height(24)
        .fillColor($r('app.string.color_black_88'))
      Text(this.item.title).fontColor($r('app.string.color_black_88')).fontSize(12).fontWeight(400).lineHeight(20)
    }
    .alignItems(HorizontalAlign.Center)
    .padding({top:12,bottom:12})
  }
}