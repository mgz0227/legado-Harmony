import { router } from '@kit.ArkUI'

@Component
export struct cloudTitle{
  build() {
    Row(){
      Row(){
        Image($r("app.media.right"))
          .rotate({angle:180})
          .size({width:40,height:40})
          .onClick(()=>{
            router.back()
          })
      }.width("40%")
      Text("云备份").fontSize(20).fontWeight(600)
    }.width("100%").justifyContent(FlexAlign.Start)
  }
}