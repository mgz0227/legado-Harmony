import { router } from '@kit.ArkUI'

@Component
export struct cloudTitle{

  @Prop title:string

  build() {
    Row(){
      Row(){
        Image($r("app.media.right"))
          .rotate({angle:180})
          .size({width:24,height:24})
          .onClick(()=>{
            router.back()
          })
      }.width("40%")
      Text(this.title).fontSize(16).fontWeight(600).lineHeight(24)
    }.width(320).justifyContent(FlexAlign.Start).padding({top:12,bottom:12})
  }
}