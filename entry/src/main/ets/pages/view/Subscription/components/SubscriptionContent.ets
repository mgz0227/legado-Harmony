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
import SubscriptionDao from '../../../../database/dao/SubscriptionDao'
import CircleIcon from '../../../../componets/common/CircleIcon'
import DialogCancelButton from '../../../../componets/common/DialogCancelButton'
import confirmDialogExample from '../../../../componets/common/confirmDialog'
import RssSourceGroup from './RssSourceGroup'
import PreviewEffectImage from './PreviewEffectImage'
import rssSourcesUtils from '../../../../common/utils/rssSourcesUtils'
import { ThemeItem } from '../../../../common/model/Theme'
import { ThemeStorageKey } from '../../../../common/constants/Theme'

@Component
export default struct SubscriptionContent{
  @Prop subscriptionTitle: string
  @Prop contentList: rssSources[] = []
  @State isButtonFunction: boolean = false
  @State contentIndex:number = 0
  @Prop batchEdit: boolean
  @Consume('batchAll') batchAll: boolean
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  @Consume('batchList') batchList: Record<number, boolean>
  // controller: web_webview.WebviewController = new web_webview.WebviewController()
  refresh: () => void = () => {

  }
  showAddDialog:() => void=() => {

  }
  build() {
    Column(){
      Column({
        space:16
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
                    showMessage('重命名')
                    break
                  case 1:
                    showMessage('置顶')
                    break
                  case 2:
                    this.isShowGroup = true
                    break
                  case 3:
                    SubscriptionDao.deleteRssSourcesList(this.contentList)
                    setTimeout(()=>{
                      this.refresh()
                    },200)
                    showMessage('删除成功')
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
        if (this.contentList.length === 0 && this.subscriptionTitle === '收藏'){
          Flex({
            justifyContent:FlexAlign.Start
          }){
            Column(){
              Image($r('app.media.icon_rule_add'))
                .fillColor($r('app.string.color_black_45'))
                .width(24)
                .height(24)
                .margin(10)
            }
            .align(Alignment.Start)
            .justifyContent(FlexAlign.Center)
            .borderRadius(10)
            .backgroundColor($r('app.string.color_black_6'))
          }
          .onClick(()=>{
              this.showAddDialog()
          })
        }

        GridRow({
          columns:2
        }){
          ForEach(this.contentList,(item:rssSources,index:number)=>{
            if (index < 2 && !this.batchEdit){
              GridCol({
                span:1
              }){
                Row(){
                  this.contentCoverBuilder(item)
                }
                .onClick(()=>{
                  SubscriptionDao.updateRecentIcon(item)
                  router.pushUrl({
                    url: 'pages/view/Subscription/rssWebView',
                    params: {
                      url: item.sourceUrl,
                      id:item.id
                    }
                  })
                  rssSourcesUtils.pushRssSourcesHistory(item)
                  this.refresh()
                })
                .gesture(
                  LongPressGesture({ repeat: true,duration:1000 })
                    .onAction((event: GestureEvent) => {
                      this.contentIndex = index
                      this.isButtonFunction = true
                    }))
              }
            }
          })
        }

        GridRow({
          columns: 5
        }){
          ForEach(this.contentList,(item:rssSources,index:number)=>{
            if (index >= 2 || this.batchEdit) {
              GridCol(){
                this.contentListBuilder(item)
              }
              .onClick(()=>{
                SubscriptionDao.updateRecentIcon(item)
                router.pushUrl({
                  url: 'pages/view/Subscription/rssWebView',
                  params: {
                    url: item.sourceUrl,
                    id: item.id
                  }
                })
                rssSourcesUtils.pushRssSourcesHistory(item)
                this.refresh()
              })
              .gesture(
                LongPressGesture({ repeat: true,duration:500 })
                  .onAction((event: GestureEvent) => {
                    this.contentIndex = index
                    this.isButtonFunction = true
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
      //常规网站编辑弹窗
      Flex()
        .bindSheet($$this.isShowNewSourcesNetwork,this.newSourcesNetworkBuilder(),{
          height: '95%',
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowNewSourcesNetwork = false
            this.isButtonFunction = false
          }
        })
      //订阅源编辑弹窗
      Flex()
        .bindSheet($$this.isShowNewSources,this.newSourcesBuilder(),{
          height: '95%',
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowNewSources = false
          }
        })
        //长按弹窗
        Flex()
          .bindSheet($$this.isButtonFunction,this.dialogTitleFuction(),{
            height: 200,
            dragBar: true,
            showClose:false,
            onDisappear:()=>{
              this.contentIndex = -1
            }
          })
      //分组
      Flex()
        .bindSheet($$this.isShowGroup,this.showCheckGroup(),{
          height: 300,
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.contentIndex = -1
            this.isShowGroup = false
          }
        })

    }
  }
  @State isShowNewSourcesNetwork:boolean = false
  @State isShowNewSources:boolean = false
  @State isShowGroup:boolean = false
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
    Column(){
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
  //移动分组
  @State moveGroup:string = ''
  @Builder
  showCheckGroup(){
    Flex(){
      RssSourceGroup({
        moveGroup:this.moveGroup,
        confirm:()=>{
          if (this.contentIndex === undefined){
            showMessage('数据丢失请重新选择')
            return
          }
          if (this.moveGroup) {
            this.contentList[this.contentIndex].sourceGroup = this.moveGroup
            SubscriptionDao.update(this.contentList[this.contentIndex]).then((val)=>{
              if (val) {
                setTimeout(()=>{
                  this.isButtonFunction = false
                  this.isShowGroup = false
                  this.moveGroup = ''
                  showMessage('移动成功')
                  this.refresh()
                },200)
              } else {
                showMessage('移动失败')
              }
            })

          } else {
            showMessage('请选择要移动的分组')
          }
        },
        cancel:()=>{
          this.isShowGroup = false
        }
      })
    }
  }

  Item_Right_Dialog_Data: IconTitleVo[] = [
    new IconTitleVo($r('app.media.ic_public_edit'), '重命名'),
    new IconTitleVo($r('app.media.icon_operate_top'), '置顶'),
    new IconTitleVo($r('app.media.icon_operate_move'), '移动至'),
    new IconTitleVo($r('app.media.delete_svg'), '删除'),
  ]

  Item_Dialog_Data: IconTitleVo[] = [
    new IconTitleVo($r('app.media.ic_public_edit'), '编辑'),
    new IconTitleVo($r('app.media.icon_operate_top'), '置顶'),
    new IconTitleVo($r('app.media.icon_operate_move'), '移动至'),
    new IconTitleVo($r('app.media.delete_svg'), '删除'),
  ]

  //长按弹窗
  @Builder
  dialogTitleFuction() {
    Column(){
      GridRow({
        columns:4
      }){
       ForEach(this.Item_Dialog_Data,(item:IconTitleVo,index:number)=>{
         GridCol(){
           CircleIcon({
             item:item
           })
         }
         .onClick(()=>{
           switch (index) {
             case 0 :
               switch (this.contentList[this.contentIndex].sourceType){
                 case 0:
                   this.isShowNewSourcesNetwork = true
                   break
                 case 1:
                   this.isShowNewSources = true
                   break
               }
               break
             case 1:
               this.isTopRssSources()
               break
             case 2:
               this.isShowGroup = true
               break
             case 3:
                this.rssSourcesDelDialog?.open()
               break
           }
         })
       })
      }
      .padding(PaddingConstants.PADDING_20)
      DialogCancelButton({
        btnClick:()=>{
          this.isButtonFunction = false
          this.contentIndex = -1
        }
      })
    }
    .width('100%')
  }
  @State delCache:boolean = false
  //删除确认弹窗
  rssSourcesDelDialog: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: ()=> { this.deleteRssSources() },
      delCache: this.delCache
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })





  deleteRssSources(){
    SubscriptionDao.deleteRssSources(this.contentList[this.contentIndex])
      .then((val:boolean)=>{
        val?showMessage('删除成功'):showMessage('删除失败')
        this.rssSourcesDelDialog?.close()
        this.isButtonFunction = false
        this.refresh()
      })
  }

  isTopRssSources(){
    SubscriptionDao.isTopRssSources(this.contentList[this.contentIndex])
      .then((val:boolean)=>{
        val?showMessage('置顶成功'):showMessage('置顶失败')
        this.rssSourcesDelDialog?.close()
        this.isButtonFunction = false
        this.refresh()
      })
  }


  @Builder
  rightDialogBuilder(list: IconTitleVo[], dialogRightChange: (_index: number) => void) {
    Flex({
      justifyContent:FlexAlign.Start,
      direction:FlexDirection.Column
    }){
      ForEach(list, (item: IconTitleVo, index) => {
        if (this.subscriptionTitle.indexOf('收藏') === -1){
          dialogTitleFuction({
            title: item.title,
            icon: item.icon,
            isBorder: list.length !== index + 1
          })
            .onClick(() => {
              dialogRightChange(index)
            })
        } else {
          if (item.title !== '重命名' && item.title !== '删除') {
            dialogTitleFuction({
              title: item.title,
              icon: item.icon,
              isBorder: list.length !== index + 1
            })
              .onClick(() => {
                dialogRightChange(index)
              })
          }
        }

      })
    }

  }
  colorCheck:string[] = ['#FFE5D4','#FFE3ED','#FCDFDF','#E2F4E4','#FFE5D4','#FFE3ED']
  @Builder
  contentCoverBuilder(item:rssSources){
    Row({
      space:12
    }){
      Stack(){
        PreviewEffectImage({
          sourceIcon:item.sourceIcon,
          customizeTitle:item.customizeTitle,
          PreviewWidth:ImageConstants.IMG_WIDTH_40,
          PreviewHeight:ImageConstants.IMG_HEIGHT_40,
          isShowTitle:false,
          sourceName:item.sourceName
        })
          .borderRadius(8)

        if (this.isShowRecentIcon(item.lastUpdateTime)  && item.showRecentIcon)
        Row().width(8).height(8)
          .borderRadius(8)
          .backgroundColor('#EF4444')
          .position({
            right: -2,
            top:-2
          })
      }.alignContent(Alignment.TopEnd)
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
    //从colorCheck取随机背景颜色
    .backgroundColor(this.colorCheck[Math.floor(Math.random() * this.colorCheck.length)])
    .padding(PaddingConstants.PADDING_12)

  }
  //刚导入的24小时内以红点进行标记，24小时后消失，或者手动点击该订阅查看后也会消失
  isShowRecentIcon(lastTime:number){
    return (new Date().getTime() - lastTime)/(1000 * 60 * 60) <= 24
  }

  @Builder
  contentListBuilder(item:rssSources){
    Stack(){
      Column({
        space: CommonConstants.SPACE_6
      }){
        Stack(){
          PreviewEffectImage({
            sourceIcon:item.sourceIcon,
            customizeTitle:item.customizeTitle,
            PreviewWidth:ImageConstants.IMG_WIDTH_40,
            PreviewHeight:ImageConstants.IMG_HEIGHT_40,
            isShowTitle:false,
            sourceName:item.sourceName
          })
            .borderRadius(8)
          Checkbox({
            group:'checkBatch',
            name:JSON.stringify(item.id)
          })
            .onChange((val)=>{
              if (item.id) {
                this.batchList[item.id] = val
              }
            })
            .select(item?.id?this.batchList[item.id]??false:false)
            .width(15)
            .selectedColor(this.theme.mainColor)
            .unselectedColor('rgba(0, 0, 0, 0.35)')
              .position({
                top:-10,
                right:-10
              })
          .visibility(this.batchEdit?Visibility.Visible:Visibility.None)
          .zIndex(2)
          if (this.isShowRecentIcon(item.lastUpdateTime) && item.showRecentIcon && !this.batchEdit){
            Row().width(8).height(8)
              .borderRadius(8)
              .backgroundColor('#EF4444')
              .position({
                right: -2,
                top:-2
              })
          }
        }
        .alignContent(Alignment.TopEnd)

        Text(`${item.sourceName}`)
          .minFontSize(8)
          .maxFontSize(12)
          .fontSize(10)
          .fontColor($r('app.string.color_black_88'))
          .lineHeight(18)
          .fontFamily(CommonConstants.FAMILY_PingFANG)
          .fontWeight(FontConstants.FONT_WEIGHT_400)
      }.margin({bottom:20})
    } .alignContent(Alignment.TopEnd)
  }
}