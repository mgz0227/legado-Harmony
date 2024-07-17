import web_webview from '@ohos.web.webview'
import { router } from '@kit.ArkUI';
import { showMessage } from '../../../componets/common/promptShow';

interface RouteParams {
  url: string,
}

@Entry
@Component
struct RssWebView {
  @State sourcesUrl:string = ''
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    this.sourcesUrl = params.url
    showMessage(this.sourcesUrl)
    console.log("url:" + this.sourcesUrl)
  }
  controller: web_webview.WebviewController = new web_webview.WebviewController()
  build() {
    Column(){
      Row({ space: 15 }) {
        Image($r('app.media.return_left'))
          .width(25)
          .height(25)
          .onClick(()=>{
            router.back()
          })
      }
      .height(30)
      .margin({left:5})
      .width("100%")
      Column(){
        Web({ src: this.sourcesUrl, controller: this.controller })
      }

    }
    .padding({top:this.topRectHeight, bottom:this.bottomRectHeight + 20})
  }
}