/**
 * @author 2008
 * @datetime 2024/7/16 16:16
 * @className: dialogNewSources
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import ImageConstants from '../../../../common/constants/ImageConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import { IconTitleVo } from '../../../../componetsmodel/IconTitleVo'
import newSources from './newSources'
import newSourcesNetWork from './newSourcesNetWork'

@Component
@Preview
export default struct dialogNewSources{
  btnClick: Function = () => {
  }
  @State isShowNewSourcesNetwork: boolean = false
  @State isShowNewSources: boolean = false
  @State
  newSources: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_dialog_new_sources_network'), '常规网站'),
    new IconTitleVo($r('app.media.icon_dialog_new_sources'), '订阅源')
  ]
  build() {
    Column(){
      this.contentListBuilder()
      Divider()

      Text('取消').fontSize(16).fontWeight(400)
        .lineHeight(24).padding({
        top:PaddingConstants.PADDING_16
      , bottom:PaddingConstants.PADDING_16
      })
        .onClick(()=>{
          this.btnClick()
        })
      Flex()
        .bindSheet($$this.isShowNewSourcesNetwork,this.newSourcesNetworkBuilder(),{
          height: '95%',
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowNewSourcesNetwork = false
          }
        })

      Flex()
        .bindSheet($$this.isShowNewSources,this.newSourcesBuilder(),{
          height: '95%',
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowNewSources = false
          }
        })
    }.padding({ top: 16})
  }

  @Builder
  newSourcesNetworkBuilder(){
    Flex(){
      newSourcesNetWork({
        isEdit:false,
        hideNewWork:()=>{
          this.btnClick()
          this.isShowNewSourcesNetwork = false
        }
      })
    }
  }

  @Builder
  newSourcesBuilder(){
    Column(){
      newSources({
        isEdit:false,
        hideNewSources:()=>{
          this.btnClick()
          this.isShowNewSources = false
        },
      })
    }
  }


  @Builder
  contentListBuilder(){
    GridRow({
      columns: 5
    }){
      ForEach(this.newSources,(item:IconTitleVo,index:number)=>{
        GridCol(){
          Column({
            space: CommonConstants.SPACE_6
          }){
            Column(){
              Image(item.icon)
                .width(ImageConstants.IMG_WIDTH_24)
                .height(ImageConstants.IMG_HEIGHT_24)
                .borderRadius(8)
            }
            .backgroundColor(Color.White)
            .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.20)' })
            .borderRadius(50)
            .border({width:1,color:$r('app.string.color_black_15')})
            .padding(PaddingConstants.PADDING_12)

            Text(`${item.title}`).fontSize(12)
              .fontColor($r('app.string.color_black_65'))
              .lineHeight(18)
              .textAlign(TextAlign.Center)
              .fontFamily(CommonConstants.FAMILY_PingFANG)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
          }
          .onClick(()=>{
            this.onClickShowNewSources(index)
          })
          .margin({bottom:20})
        }
      })
    }
  }



  onClickShowNewSources(index:number){
    switch (index){
      case 0:
        this.isShowNewSourcesNetwork = true
        break;
      case 1:
        this.isShowNewSources = true
        break;
      default:
        break;
    }
    // this.btnClick()
  }
}