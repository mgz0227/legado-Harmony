/**
 * @author 2008
 * @datetime 2024/6/23 22:51
 * @className: newAddRule
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import buttonCommon from '../../../componets/common/buttonCommon'
import { showMessage } from '../../../componets/common/promptShow'

@Component
@Preview
export default struct newAddRule{
  @State changeRule:boolean = false
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
          Text($r('app.string.new_replacement_rule'))
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
          //未分组
          Column({
            space:8
          }){
            Row(){
              Text('分组').textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
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
              placeholder:'未分组'
            }).borderRadius(0)
          }
          .padding({top:12,bottom:12})
          .alignItems(HorizontalAlign.Start)

          //替换对象
          Column({
            space:8
          }){
            Flex({
              justifyContent:FlexAlign.SpaceBetween,
              alignItems:ItemAlign.End
            }){
              Row(){
                Text('替换对象').textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
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
              Row({
                space:8
              }){
                Image($r('app.media.help')).width(16).height(16)
                Text('使用正则表达式').font({
                  size:14,
                  weight:400,
                  family:CommonConstants.FAMILY_PingFANG
                })
                  .fontColor($r('app.string.color_black_45'))
                Toggle({ type: ToggleType.Switch, isOn: $$this.changeRule})
                  .selectedColor("#F60").hoverEffect(HoverEffect.None)
                  .onChange(()=>{
                    // updateAppData(this.APP_INDEX_SCROLLABLE)
                    // showMessage(this.APP_INDEX_SCROLLABLE?'标签栏锁已开启':'标签栏已解锁')
                  })

              }
            }
            TextInput({
              placeholder:'请输入替换对象或替换规则'
            }).borderRadius(0)
          }
          .padding({top:12,bottom:12})
          .alignItems(HorizontalAlign.Start)

          //替换为
          Column({
            space:8
          }){
            Flex({
              justifyContent:FlexAlign.SpaceBetween,
              alignItems:ItemAlign.End
            }){
              Row(){
                Text('替换为').textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
                  size:16,
                  weight:500,
                  family:CommonConstants.FAMILY_PingFANG
                })
                  .lineHeight(24)

              }
              Row({
                space:8
              }){
                Row({
                  space:8
                }){
                  Text('作用于标题').font({
                    size:14,
                    weight:400,
                    family:CommonConstants.FAMILY_PingFANG
                  })
                    .fontColor($r('app.string.color_black_45'))
                  Radio({value:'default',group:'radioGroup'})
                    .radioStyle({
                      checkedBackgroundColor: $r('app.color.theme_color')
                    })
                    .onChange(()=>{

                    })
                    .width(20).height(20)
                }

                Row({
                  space:8
                }){
                  Text('作用于正文').font({
                    size:14,
                    weight:400,
                    family:CommonConstants.FAMILY_PingFANG
                  })
                    .fontColor($r('app.string.color_black_45'))
                  Radio({value:'default',group:'radioGroup'})
                    .radioStyle({
                      checkedBackgroundColor: $r('app.color.theme_color')
                    })
                    .checked(true)
                    .onChange(()=>{

                    })
                    .width(20).height(20)
                }

              }
            }
            TextInput({
              placeholder:'请输入替换结果'
            }).borderRadius(0)
          }
          .padding({top:12,bottom:12})
          .alignItems(HorizontalAlign.Start)

          //替换范围
          Column({
            space:8
          }){
            Row(){
              Text('替换范围').textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
                size:16,
                weight:500,
                family:CommonConstants.FAMILY_PingFANG
              })
                .lineHeight(24)

            }
            TextInput({
              placeholder:'选填书名或书源URL'
            }).borderRadius(0)
          }
          .padding({top:12,bottom:12})
          .alignItems(HorizontalAlign.Start)

          //超时毫秒数
          Column({
            space:8
          }){
            Row(){
              Text('超时毫秒数').textAlign(TextAlign.Start).fontColor($r('app.string.color_black_88')).font({
                size:16,
                weight:500,
                family:CommonConstants.FAMILY_PingFANG
              })
                .lineHeight(24)
            }
            TextInput({
              placeholder:'请请入超时毫秒数'
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