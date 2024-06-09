/**
 * @author 2008
 * @datetime 2024/6/6 22:05
 * @className: sourceCommon
 */
import chapterCommon from './chapterCommon'

@Component
export default struct sourceCommon{
  @State rating: number = 3.5
  @Prop IsSelect:boolean = true
  @Prop sourceType:string
  @State isShowChapter:boolean = false

  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      alignItems:ItemAlign.Center
    }){
      Column(){
        Text('起点中文网')
          .fontSize(16)
          .fontWeight(500)
          .lineHeight(24)
          .fontColor($r('app.string.color_black_88'))
          .padding({
            bottom:8
          })
        Row(){
            Row(){
              Text('精品')
                .fontSize(9)
                .fontWeight(500)
                .textAlign(TextAlign.Center)
                .fontColor('#FFE5D4')
            }
            .borderRadius({topLeft:5,bottomLeft:5})
            .align(Alignment.Center)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#854D00')
            .padding({
              top:4,bottom:4,
              left:4,right:4
            })
          Row(){
            Text(this.rating.toFixed(1))
              .fontSize(9)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
              .fontColor('#854D00')
          }
          .borderRadius({topRight:5,bottomRight:5})
          .align(Alignment.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#FFE5D4')
          .padding({
            top:4,bottom:4,
            left:4,right:4
          })
          Rating({ rating: this.rating, indicator: false })
            .stars(5)
            .stepSize(0.5)
            .onChange((value: number) => {
              this.rating = value
            }).padding({left:8})
        }
        .padding({
          bottom:12
        })
        if (this.sourceType === '整本换源'){
          Row(){
            Text('最新 番外三 庆功宴')
              .fontSize(12)
              .fontWeight(400)
              .lineHeight(20)
              .fontColor($r('app.string.color_black_45'))
          }
        } else {
          Flex({
            justifyContent:FlexAlign.SpaceBetween,
            alignItems:ItemAlign.End
          }){
            Text('第一章 牢狱之灾')
              .fontSize(12)
              .fontWeight(400)
              .lineHeight(20)
              .fontColor($r('app.string.color_black_45'))
            if (!this.IsSelect) {
              Row(){
                Text('选择章节').fontSize(12).fontColor($r('app.string.color_black_45'))
                Image($r("app.media.icon_right"))
                  .fillColor($r('app.string.color_black_65'))
                  .size({width:16,height:16})
              }
              .bindSheet($$this.isShowChapter, this.chapterView(), {
                height: '95%',
                showClose: false,
                dragBar: false,
                maskColor: 'rgba(0,0,0,0.6)',
                onDisappear:()=>{
                  console.log('隐藏')
                }
              })
              .onClick(()=>{
                this.isShowChapter = true
              })
            }
          }.padding({right:16})
        }


      }
      .alignItems(HorizontalAlign.Start)
      .margin({
        left:16,top:12,bottom:12
      })
      if (this.IsSelect){
        Column({
          space:16
        }){
          Image($r('app.media.likes_icon')).width(24).height(24)
          Image($r('app.media.tread_icon')).width(24).height(24)
        }.margin({
          right:24
        })
      }
    }
    .border({width:this.IsSelect?1:0,color:$r('app.color.theme_color'),style:BorderStyle.Solid})
    .borderRadius(12)
    .backgroundColor(this.IsSelect?'rgba(255, 102, 0, 0.12)':'rgba(0, 0, 0, 0.06)')
  }
  @Builder
  chapterView(){
   Column(){
     Column() {
       Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
     }
     .padding({ top: 12 })
     chapterCommon({
       isShowChapter:this.isShowChapter
     })
   }
  }
}