/**
 * @author 2008
 * @datetime 2024/6/25 22:11
 * @className: exportRuleDialog
 */
import CommonConstants from '../../common/constants/CommonConstants'

@CustomDialog
@Preview
export default struct exportRuleDialog{
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  build() {
      Stack(){
      Column(){
        Flex({
          justifyContent:FlexAlign.Center
        }){
          Column({
            space:12
          }){
            Text('导出').font({
              size:18,
              weight:500,
              family: CommonConstants.FAMILY_PingFANG
            })

            Row({
              space:8
            }){
              Row({
                space:8
              }){
                Radio({value:'default',group:'exportGroup'})
                  .radioStyle({
                    checkedBackgroundColor: $r('app.color.theme_color')
                  })
                  .checked(true)
                  .onChange(()=>{

                  })
                  .width(20).height(20)
                Text('2天有效果').font({
                  size:14,
                  weight:400,
                  family:CommonConstants.FAMILY_PingFANG
                })
                  .fontColor($r('app.string.color_black_45'))
              }

              Row({
                space:8
              }){
                Radio({value:'default',group:'exportGroup'})
                  .radioStyle({
                    checkedBackgroundColor: $r('app.color.theme_color')
                  })
                  .onChange(()=>{

                  })
                  .width(20).height(20)
                Text('永久有效').font({
                  size:14,
                  weight:400,
                  family:CommonConstants.FAMILY_PingFANG
                })
                  .fontColor($r('app.string.color_black_45'))
              }
            }
            Column(){
              Text('复制链接').font({
                size:14,
                weight:500,
                family:CommonConstants.FAMILY_PingFANG
              })
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
                .width(172)
                .lineHeight(22)
            }
            .margin({top:12})
            .borderRadius(200)
            .padding({
              left:32,right:32,
              top:8,bottom:8
            })
            .backgroundColor($r('app.color.theme_color'))

            Column(){
              Text('导出本地').font({
                size:14,
                weight:500,
                family:CommonConstants.FAMILY_PingFANG
              })
                .fontColor($r('app.string.color_black_45'))
                .textAlign(TextAlign.Center)
                .width(172)
                .lineHeight(22)
            }
            .borderRadius(200)
          }
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
        .padding(24)

        Column(){
          Image($r('app.media.close')).width(24).height(24).fillColor(Color.White)
        }
        .onClick(()=>{
          this.controller?.close()
        })
        .margin({
          top:16
        })
        .borderRadius(50)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.string.color_black_45'))
        .width(48).height(48)
      }
      }
  }
}