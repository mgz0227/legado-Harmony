/**
 * @author 2008
 * @datetime 2024/8/7 16:02
 * @className: WebSetup
 */
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import InsideCircleIcon from '../../../../componets/common/InsideCircleIcon'
import { IconTitleVo } from '../../../../componetsmodel/IconTitleVo'
import WebSetupUA from './WebSetupUA'

@Component
@CustomDialog
export default struct WebSetup {
  controller?: CustomDialogController
  refreshing:Function = ()=>{}
  copyUrl:Function = ()=>{}
  uaSetUp:Function = ()=>{}
  startBrowsable:Function = ()=>{}
  moreList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_web_refresh'), '刷新'),
    new IconTitleVo($r('app.media.ic_public_share'), '分享'),
    new IconTitleVo($r('app.media.browser'), '浏览器打开'),
    new IconTitleVo($r('app.media.phone'), 'UA设置'),
  ]
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  build() {
    Column(){
      GridRow({
        columns:4
      }){
        ForEach(this.moreList,(item:IconTitleVo,index:number)=>{
          GridCol(){
            InsideCircleIcon({
              icon:item.icon,
              title:item.title
            })
          }
          .onClick(()=>{
            this.webSetUp(index)
          })
        })
      }
      .padding({
        top:PaddingConstants.PADDING_12,
        bottom:PaddingConstants.PADDING_12
      })
      Column(){
        Text('取消')
          .onClick(()=>{
            this.controller?.close()
          })
      }
    }
    .padding({
      bottom:this.bottomRectHeight
    })
    .borderRadius({topLeft:20,topRight:20})
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
    .width('100%')
  }
  webSetUp(index:number){
    switch (index){
      case 0:
        this.refreshing()
        this.controller?.close()
        break
      case 1:
        this.copyUrl();this.controller?.close();break
      case 2:
        this.startBrowsable();this.controller?.close();break
      case 3:
        this.webSetupUADialog?.open();break;

    }
  }

  webSetupUADialog: CustomDialogController | null = new CustomDialogController({
    builder: WebSetupUA(),
    cancel: this.exitDialog,
    autoCancel: true,
    width:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true,
    backgroundColor: Color.White,
  })

  exitDialog(){
    this.webSetupUADialog?.close()
    this.controller?.close()
  }
}