/**
 * @author 2008
 * @datetime 2024/8/7 16:48
 * @className: WebSetupUA
 */
@CustomDialog
@Component
export default struct WebSetupUA {
  controller?: CustomDialogController
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  ua:string[] = ['Android', 'Phone', '电脑', '自定义']
  @State uaSet:string = 'Android'
  build() {
    Column(){
      Column(){
        Text('UA设置')
          .fontColor($r('app.string.color_black_88'))
          .textAlign(TextAlign.Center)
          .padding({top:12,bottom:12})
          .lineHeight(24)
          .fontWeight(500)
      }
      Column(){
        ForEach(this.ua,(title:string)=>{
         Flex({
           justifyContent:FlexAlign.SpaceBetween
         }){
           Text(title)
             .fontColor($r('app.string.color_black_88'))
             .textAlign(TextAlign.Center)
             .padding({top:12,bottom:12})
             .lineHeight(24)
             .fontWeight(500)
           Image(this.uaSet ===  title?$r('app.media.hook'):'').width(24).height(24)
         }
         .onClick(()=>{
           this.uaSet = title
           this.controller?.close()
         })
        })
      }
      .alignItems(HorizontalAlign.Start)
      .padding({left:20,right:20})

      Column(){
        Divider()
        Column(){
          Text('取消')
            .fontSize($r('app.string.color_black_88'))
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontWeight(400)
            .lineHeight(24)
        }
        .padding({left:32,right:32,top:16,bottom:16})
      }
      .onClick(()=>{
        this.controller?.close()
      })
    }
    .borderRadius({topLeft:20,topRight:20})
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
    .width('100%')
  }
}