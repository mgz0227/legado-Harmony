/**
 * @author 2008
 * @datetime 2024/7/19 21:15
 * @className: DialogCancelButton
 * 弹窗底部取消按钮
 */
import FontConstants from '../../common/constants/FontConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'

@Component
export default struct DialogCancelButton{
  btnClick: Function = () => {

  }
  isShowDivider: boolean = true
  @Prop title: string = '取消'
  build() {
    Column(){
      if (this.isShowDivider){
        Divider()
      }
      Text(this.title).fontSize(FontConstants.FONT_SIZE_16)
        .fontWeight(FontConstants.FONT_WEIGHT_400)
        .lineHeight(24)
        .padding({
          top:PaddingConstants.PADDING_16,
          bottom:PaddingConstants.PADDING_16
        })
        .onClick(()=>{
          this.btnClick()
        })
    }
  }
}