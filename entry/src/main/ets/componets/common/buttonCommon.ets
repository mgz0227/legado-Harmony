/**
 * @author 2008
 * @datetime 2024/6/23 1:02
 * @className: buttonCommon
 * 通用确认取消按钮
 */
import CommonConstants from '../../common/constants/CommonConstants'
@Component
export default struct buttonCommon {
  @Prop sureTitle:string = '确定'
  @Prop cancelTitle:string = '取消'
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  build() {
    Flex(){
      Row({space: 20}) {
        Button(this.cancelTitle)
          .padding({left: 32, right: 32, top: 8, bottom: 8})
          .width(150)
          .height(40)
          .borderRadius(200)
          .backgroundColor('#1fff6600')
          .fontColor('#FF6600')
          .onClick(() => {
              this.cancel()
          })
        Button(this.sureTitle)
          .padding({left: 32, right: 32, top: 8, bottom: 8})
          .width(150)
          .height(40)
          .borderRadius(200)
          .backgroundColor('#FF6600')
          .fontColor('#FFFFFF')
          .onClick(()=>{
            this.confirm()
          })
      }
      .padding({top: 12, bottom: 12})
      .justifyContent(FlexAlign.Center)
      .width(CommonConstants.FULL_WIDTH)
      .height(64)
    }
  }
}