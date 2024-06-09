/**
 * @author 2008
 * @datetime 2024/6/9 20:57
 * @className: chapterCommon
 * 章节选择弹窗
 */
import CommonConstants from '../../../common/constants/CommonConstants'

@Component
export default struct chapterCommon{
  @Link isShowChapter:boolean
  build() {
   Column(){
     Column(){
       Search({placeholder:'搜索章节'})
       Scroll(){
         Column({
           space:12
         }){
           this.chapterTitle(true)
           this.chapterTitle(false,true)
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
           this.chapterTitle()
         }
       }
       .padding({
         top:12
       })
       .align(Alignment.TopStart)
       .scrollBar(BarState.Off)
       .height('80%')
     }
     .padding(20)

     Divider()
     Row({space: 20}) {
       Button('取消')
         .padding({left: 32, right: 32, top: 8, bottom: 8})
         .width(150)
         .height(40)
         .borderRadius(200)
         .backgroundColor('#1fff6600')
         .fontColor($r('app.color.theme_color'))
         .onClick(()=>{
           this.isShowChapter = false
         })

       Button('确认')
         .padding({left: 32, right: 32, top: 8, bottom: 8})
         .width(150)
         .height(40)
         .borderRadius(200)
         .backgroundColor($r('app.color.theme_color'))
         .fontColor($r('sys.color.comp_background_list_card'))

     }
     .padding({top: 12, bottom: 12})
     .justifyContent(FlexAlign.Center)
     .width(CommonConstants.FULL_WIDTH)
     .height(64)
   }
  }

  @Builder chapterTitle(showRead:boolean = false,checkRead:boolean=false){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      alignItems:ItemAlign.Center
    }){
      Text(`${!showRead?'标题':'正在阅读'}: 第一章 牢狱之灾`).fontSize(14).fontWeight(400).fontColor(!showRead?$r('app.string.color_black_88'):$r('app.string.color_black_45'))
      if (!showRead){
        Radio({value:'第一章',group:'radioGroup'}).checked(checkRead)
          .radioStyle({
            checkedBackgroundColor: $r('app.color.theme_color')
          })
          .border({width:2,color:'rgba(255, 255, 255, 0.10)'})
          .width(24).height(24)
      } else {
        Text().height(24)
      }
    }
  }
}