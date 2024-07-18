import { webview } from '@kit.ArkWeb';
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
  webviewController: webview.WebviewController = new webview.WebviewController();
  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    this.sourcesUrl = params.url
    showMessage(this.sourcesUrl)
  }

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
        Web({ src: this.sourcesUrl, controller: this.webviewController })
          .onPageBegin(()=>{
            showMessage(this.webviewController.getUserAgent())
          })
      }

    }
    .padding({top:this.topRectHeight, bottom:this.bottomRectHeight + 20})
  }
}