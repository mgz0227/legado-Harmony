import router from '@ohos.router'

@Component
export struct SetHead{


  titleName: string ='标题'

  rightString?: string = ''


  build() {
    Flex({alignItems:ItemAlign.End}){
      Image($r('app.media.return_left'))
        .height(15)
        .onClick(()=>{
          router.back();
        })

      Text(this.titleName).width('80%').textAlign(TextAlign.Center)
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(600)

      Text(this.rightString).width('10%').textAlign(TextAlign.Center)
    }.padding({top:12,bottom:12})

  }
}