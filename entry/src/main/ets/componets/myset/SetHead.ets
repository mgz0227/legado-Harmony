import router from '@ohos.router'

@Component
export struct SetHead{


  titleName: string ='标题'

  rightString?: string = ''


  build() {
    Flex({alignItems:ItemAlign.Center}){
      Image($r('app.media.return_left'))
        .height(15)
        .onClick(()=>{
          router.back();
        })

      Text(this.titleName).width('80%').textAlign(TextAlign.Center).fontWeight(600)

      Text(this.rightString).width('10%').textAlign(TextAlign.Center)
    }.padding(20)

  }
}