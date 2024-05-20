import { router } from '@kit.ArkUI'
import CommonConstants from '../../common/constants/CommonConstants'

@Component
export struct myCenterTitle{

  @Prop title:string

  build() {
    Column(){
      Blank(40)
      Row(){
        Row(){
          Image($r("app.media.return_left"))
            .size({width:CommonConstants.TITLE_IMG_SIZE,height:CommonConstants.TITLE_IMG_SIZE})
            .onClick(()=>{
              router.back()
            })
        }.width("40%")
        Text(this.title).fontSize(16).fontWeight(600).lineHeight(24)
      }.width(320).justifyContent(FlexAlign.Start).padding({top:12,bottom:12})
    }
  }
}