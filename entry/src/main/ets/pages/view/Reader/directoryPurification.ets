/**
 * @author 2008
 * @datetime 2024/6/23 22:51
 * @className: newAddRule
 * 目录净化弹窗
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import buttonCommon from '../../../componets/common/buttonCommon'
import { showMessage } from '../../../componets/common/promptShow'

@Component
@Preview
export default struct directoryPurification{
  @Prop isEdit:boolean = false
  cancel: () => void = () => {
  }
  build() {
    Flex({
      direction:FlexDirection.Column,
      justifyContent:FlexAlign.SpaceBetween
    }){
      Column(){
        Flex({
          justifyContent:FlexAlign.SpaceBetween
        }){
          Text(this.isEdit?$r('app.string.edit_directory_purification'):$r('app.string.new_directory_purification'))
            .font({
              size:18,
              weight:500,
              family:CommonConstants.FAMILY_PingFANG
            })
          Row({
            space:20
          }){

            this.titleRule($r('app.media.ic_public_copy'),$r('app.string.copy'))
            this.titleRule($r('app.media.icon_rule_paste'),$r('app.string.paste'))
          }
        }.padding({
          top:28,
          left:20,
          right:20,
          bottom:12
        })
        Column(){
          //名称
          Column({
            space:8
          }){
            Row(){
              Text($r('app.string.appellation')).textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
                size:16,
                weight:500,
                family:CommonConstants.FAMILY_PingFANG
              })
                .lineHeight(24)
              Text('*').fontColor($r('app.color.theme_color')).font({
                size:16,
                weight:500,
                family:CommonConstants.FAMILY_PingFANG
              })
                .lineHeight(24)
            }
            TextInput({
              placeholder:$r('app.string.please_enter_name')
            }).borderRadius(0)
          }
          .padding({top:12,bottom:12})
          .alignItems(HorizontalAlign.Start)

          //正则表达式
          Column({
            space:8
          }){
            Flex({
              justifyContent:FlexAlign.SpaceBetween,
            }){
              Row(){
                Text($r('app.string.regular_expressions')).textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
                  size:16,
                  weight:500,
                  family:CommonConstants.FAMILY_PingFANG
                })
                  .lineHeight(24)
                Text('*').fontColor($r('app.color.theme_color')).font({
                  size:16,
                  weight:500,
                  family:CommonConstants.FAMILY_PingFANG
                })
                  .lineHeight(24)
              }
            }
            TextArea({
              placeholder: $r('app.string.please_enter_regular_expression')
            }).borderRadius(0)
          }
          .padding({top:12,bottom:12})
          .alignItems(HorizontalAlign.Start)

          //示例
          Column({
            space:8
          }){
            Row(){
              Text($r('app.string.example')).textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
                size:16,
                weight:500,
                family:CommonConstants.FAMILY_PingFANG
              })
                .lineHeight(24)
            }
            TextArea({
              placeholder: $r('app.string.please_enter_example')
            }).borderRadius(0)
          }
          .padding({top:12,bottom:12})
          .alignItems(HorizontalAlign.Start)
        }
        .margin({left:20,right:20})
      }
      Column(){
        Divider()
        buttonCommon({
          cancel: ()=>{
            this.cancel()
          },
          confirm: ()=>{
            showMessage('newAddRule')
          }
        })
      }.padding({bottom:12})
    }
    .height('100%')
  }
  @Builder titleRule(img:Resource, title:Resource){
    Row({
      space:4
    }){
      Image(img).width(20).height(20)
      Text(title).font({
        size:14,
        weight:400
      })
    }
  }
}