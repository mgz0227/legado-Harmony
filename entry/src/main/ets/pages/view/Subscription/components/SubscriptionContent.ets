/**
 * @author 2008
 * @datetime 2024/7/14 22:58
 * @className: SubscriptionContent
 * 订阅内容组件
 */
import CommonConstants from '../../../../common/constants/CommonConstants'
import FontConstants from '../../../../common/constants/FontConstants'
import ImageConstants from '../../../../common/constants/ImageConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import { rssSources } from '../../../../database/entities/rssSources'
import { IconTitleVo } from '../../../../componetsmodel/IconTitleVo'
import dialogTitleFuction from '../../../../componets/common/dialogTitleFuction'
import { showMessage } from '../../../../componets/common/promptShow'
import newSourcesNetWork from '../RssSources/newSourcesNetWork'
import newSources from '../RssSources/newSources'
import { router } from '@kit.ArkUI'

@Component
export default struct SubscriptionContent{
  @Prop subscriptionTitle: string
  @Prop contentList: rssSources[] = []

  @State contentIndex:number = 0
  // controller: web_webview.WebviewController = new web_webview.WebviewController()
  refresh: () => void = () => {

  }
  build() {
    Column(){
      Column({
        space:20
      }){
        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center,
          alignContent: FlexAlign.Center
        }) {
          Row({
            space:CommonConstants.SPACE_12
          }){
            Text(this.subscriptionTitle)
              .font({
                size:FontConstants.FONT_SIZE_16,
                weight:FontConstants.FONT_WEIGHT_500,
                family: CommonConstants.FAMILY_PingFANG
              })
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(24)
              .padding({
                top: PaddingConstants.PADDING_12,
              })
            Text('长按编辑')
              .font({
                size:12,
                weight:FontConstants.FONT_WEIGHT_400,
                family: CommonConstants.FAMILY_PingFANG
              })
              .fontColor($r('app.string.color_black_45'))
              .lineHeight(20)
              .padding({
                top: PaddingConstants.PADDING_12,

              })
          }.alignItems(VerticalAlign.Bottom)

          Image($r('app.media.more'))
            .fillColor($r('app.string.color_black_45'))
            .width(ImageConstants.IMG_WIDTH_24)
            .height(ImageConstants.IMG_HEIGHT_24)
            .bindMenu(
              this.rightDialogBuilder(this.Item_Right_Dialog_Data, async (index: number) => {
                switch (index) {
                  case 0:
                    showMessage('编辑')
                    break
                  case 1:
                    showMessage('置顶')
                    break
                  case 2:
                    showMessage('移动至')
                    break
                  case 3:
                    showMessage('删除')
                    break
                }
              }),
              {
                onDisappear: () => {

                }
              })
            .onClick(() => {

            })
        }

        GridRow({
          columns:2
        }){
          ForEach(this.contentList,(item:rssSources,index:number)=>{
            if (index < 2){
              GridCol({
                span:1
              }){
                Row(){
                  this.contentCoverBuilder(item)
                }
                .onClick(()=>{
                  router.pushUrl({
                    url: 'pages/view/Subscription/rssWebView',
                    params: {
                      url: item.sourceUrl
                    }
                  })
                })
                .gesture(
                  LongPressGesture({ repeat: true,duration:1000 })
                    .onAction((event: GestureEvent) => {
                      showMessage('编辑' + JSON.stringify(item.sourceType))
                      this.contentIndex = index
                      switch (item.sourceType){
                        case 0:
                          this.isShowNewSourcesNetwork = true
                          break
                        case 1:
                          this.isShowNewSources = true
                          break
                      }
                    }))
              }
            }
          })
        }

        GridRow({
          columns: 5
        }){
          ForEach(this.contentList,(item:rssSources,index:number)=>{
            if (index >= 2) {
              GridCol(){
                this.contentListBuilder(item)
              }
              .onClick(()=>{
                router.pushUrl({
                  url: 'pages/view/Subscription/rssWebView',
                  params: {
                    url: item.sourceUrl
                  }
                })
              })
              .gesture(
                LongPressGesture({ repeat: true,duration:500 })
                  .onAction((event: GestureEvent) => {
                    showMessage('编辑' + JSON.stringify(item.sourceType))
                    this.contentIndex = index
                    switch (item.sourceType){
                      case 0:
                        this.isShowNewSourcesNetwork = true
                        break
                      case 1:
                        this.isShowNewSources = true
                        break
                    }
                  }))
            }
          })
        }
        // Web({ src: this.contentList[0].sourceUrl, controller: this.controller })

      }
      .margin({top: PaddingConstants.PADDING_12})
      .borderRadius(12)
      .backgroundColor(Color.White)
      .padding(20)

      Flex()
        .bindSheet($$this.isShowNewSourcesNetwork,this.newSourcesNetworkBuilder(),{
          height: '95%',
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowNewSourcesNetwork = false
          }
        })

      Flex()
        .bindSheet($$this.isShowNewSources,this.newSourcesBuilder(),{
          height: '95%',
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowNewSources = false
          }
        })
    }
  }
  @State isShowNewSourcesNetwork:boolean = false
  @State isShowNewSources:boolean = false
  @Builder
  newSourcesNetworkBuilder(){
    Flex(){
      newSourcesNetWork({
        isEdit:true,
        hideNewWork:()=>{
          this.isShowNewSourcesNetwork = false
          this.refresh()
        },
        formModel:this.contentList[this.contentIndex]
      })
    }
  }

  @Builder
  newSourcesBuilder(){
    Flex(){
      newSources({
        isEdit:true,
        hideNewSources:()=>{
          this.isShowNewSources = false
          this.refresh()
        },
        formModel:this.contentList[this.contentIndex]
      })
    }
  }

  Item_Right_Dialog_Data: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_operate_top'), '编辑'),
    new IconTitleVo($r('app.media.icon_operate_export'), '置顶'),
    new IconTitleVo($r('app.media.icon_operate_move'), '移动至'),
    new IconTitleVo($r('app.media.delete_svg'), '删除'),
  ]

  @Builder
  rightDialogBuilder(list: IconTitleVo[], dialogRightChange: (_index: number) => void) {
    Flex({
      justifyContent:FlexAlign.Start,
      direction:FlexDirection.Column
    }){
      ForEach(list, (item: IconTitleVo, index) => {
        dialogTitleFuction({
          title: item.title,
          icon: item.icon,
          isBorder: list.length !== index + 1
        })
          .onClick(() => {
            dialogRightChange(index)
          })
      })
    }

  }

  @Builder
  contentCoverBuilder(item:rssSources){
    Row({
      space:12
    }){
      // Image(icon?icon:$r('app.media.icon'))
      //   .width(ImageConstants.IMG_WIDTH_24)
      //   .height(ImageConstants.IMG_HEIGHT_24)
      //   .borderRadius(4)
      Image($r('app.media.icon'))
        .width(ImageConstants.IMG_WIDTH_40)
        .height(ImageConstants.IMG_HEIGHT_40)
        .borderRadius(4)
      Text(item.sourceName)
        .font({
          size:14,
          weight:FontConstants.FONT_WEIGHT_500,
          family: CommonConstants.FAMILY_PingFANG
        })
        .layoutWeight(1)
        .lineHeight(22)
        .fontColor($r('app.string.color_black_88'))
    }
    .margin({right:20,bottom:20})
    .borderRadius(12)
    .backgroundColor('#FFE5D4')
    .padding(PaddingConstants.PADDING_12)

  }

  @Builder
  contentListBuilder(item:rssSources){
    Column({
      space: CommonConstants.SPACE_6
    }){
      // Image(icon)
      //   .width(ImageConstants.IMG_WIDTH_40)
      //   .height(ImageConstants.IMG_HEIGHT_40)
      //   .borderRadius(8)
      Image($r('app.media.icon'))
        .width(ImageConstants.IMG_WIDTH_40)
        .height(ImageConstants.IMG_HEIGHT_40)
        .borderRadius(4)

      Text(`${item.sourceName}`).fontSize(10)
        .fontColor($r('app.string.color_black_88'))
        .lineHeight(18)
        .fontFamily(CommonConstants.FAMILY_PingFANG)
        .fontWeight(FontConstants.FONT_WEIGHT_400)
    }.margin({bottom:20})
  }
}