import { router } from '@kit.ArkUI'
import CommonConstants from '../../common/constants/CommonConstants'

@Component
export struct myCenterTitle{

  @Prop title:string

  build() {
    Column(){
      Row(){
        Row(){
          Image($r("app.media.return_left"))
            .size({width:CommonConstants.TITLE_IMG_SIZE,height:CommonConstants.TITLE_IMG_SIZE})
            .onClick(()=>{
              router.back()
            })
        }.width("33%")
        Row(){
          Text(this.title).fontSize(16).fontWeight(600).lineHeight(24)
        }.width("33%")
        .justifyContent(FlexAlign.Center)
        Row(){
          Text("  ").fontSize(16).fontWeight(600).lineHeight(24)
        }.width("33%")
      }.width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({top:12,bottom:12})

    }
  }
}