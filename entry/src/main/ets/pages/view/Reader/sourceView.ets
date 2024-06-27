/**
 * @author 2008
 * @datetime 2024/6/7 19:48
 * @className: sourceView
 * 换源组件
 */
import sourceCommon from './sourceCommon'

@Component
@Preview
export default struct sourceView{
  @State sourceType:string = '整本换源'
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  build() {
    Column({
      space:16
    }){
      Stack(){
        Row({
          space:12
        }){
          Divider()
            .vertical(true)
            .height(15)
            .color('#989797')
            .opacity(0.5)
            .strokeWidth(1)

          Text('书源管理')
            .fontSize(14)
            .fontWeight(400)
            .fontColor($r('app.string.color_black_45'))
        }
        .margin({right:25})
        Search({placeholder:'搜索全文'})
      }
      .margin({left:20,right:20})
      .alignContent(Alignment.End)
      Flex() {
        Row(
          {
            space:24
          }
        ) {
          Column(){
            Text('整本换源').font({
              size:16,
              weight:500
            })
              .fontColor(this.sourceType === '整本换源'?$r('app.string.color_black_88'):$r('app.string.color_black_45'))
            if (this.sourceType === '整本换源'){
              Row().width(10).height(3).backgroundColor($r('app.color.theme_color')).borderRadius(8).offset({y:16})
            }
          }.onClick(()=>{
            this.sourceType ='整本换源'
          })
          Column(){
            Text('单章换源')
              .font({
                size:16,
                weight:500
              })
              .fontColor(this.sourceType !== '整本换源'?$r('app.string.color_black_88'):$r('app.string.color_black_45'))
            if (this.sourceType !== '整本换源'){
              Row().width(10).height(3).backgroundColor($r('app.color.theme_color')).borderRadius(8).offset({y:16})
            }
          }.onClick(()=>{
            this.sourceType ='单章换源'
          })
        }.padding({left:20,right:20})
      }
      Divider()
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }){
        Row(){
          Text('共搜索到24个书源，')
            .fontWeight(400)
            .fontSize(14)
            .fontColor($r('app.string.color_black_45'))
          Text('点击刷新')
            .fontWeight(400)
            .fontSize(14)
            .fontColor($r('app.color.theme_color'))
        }
        Row({
          space:4
        }
        ){
          Image($r('app.media.screen_icon')).width(16).height(16)
          Text('筛选')
            .fontWeight(400)
            .fontSize(14)
            .fontColor($r('app.string.color_black_45'))
        }
      }.margin({left:20,right:20})
      Scroll(){
        Column({
          space:20
        }){
          sourceCommon({
            IsSelect: true,
            rating: 5.0,
            sourceType:this.sourceType
          })
          sourceCommon({
            IsSelect: false,
            rating: 4.5,
            sourceType:this.sourceType
          })
          sourceCommon({
            IsSelect: false,
            rating: 4.5,
            sourceType:this.sourceType
          })
          sourceCommon({
            IsSelect: false,
            rating: 4.5,
            sourceType:this.sourceType
          })
          sourceCommon({
            IsSelect: false,
            rating: 4.5,
            sourceType:this.sourceType
          })
          sourceCommon({
            IsSelect: false,
            rating: 4.5,
            sourceType:this.sourceType
          })
        }
      }
      .padding({left:20,right:20,bottom:this.bottomRectHeight?this.bottomRectHeight+5:30})
      .layoutWeight(1)
      .align(Alignment.TopStart)
      .scrollBar(BarState.Off)

    }.padding({top:12})
  }
}
