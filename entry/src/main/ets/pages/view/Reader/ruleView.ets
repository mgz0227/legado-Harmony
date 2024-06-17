/**
 * @author 2008
 * @datetime 2024/6/15 20:00
 * @className: ruleView
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import RuleGroupType from './RuleGroupType'

@Preview
@CustomDialog
@Component
export default struct ruleView{
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State ruleTitle:Array<string> = ['替换净化','净化标题']
  @State ruleType:string = '替换净化'
  @State coverShow:boolean = false
  @State ruleArray:Array<string> =
    ['一个目录 (标题)','书名净化标题 (标题)','JS标题(标题)','章节名称规整 (标题)','序号加括号 (标题)',
      '章节名重复① (标题)','章节名重复② (标题)','章节符号净化 (标题)','第XXX章 XXX(规范章节)(标题)',
    '中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)',
      '中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)']
  controller?: CustomDialogController
  tabsController: TabsController = new TabsController();
  build() {
    Column(){
      Flex({
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.SpaceBetween
      }){
        Image($r('app.media.return_left'))
          .width(24)
          .height(24)
          .fillColor('rgba(0, 0, 0, 0.88)')
          .onClick(()=>{
            this.controller?.close()
          })
        Row({
          space:16
        }){
          ForEach(this.ruleTitle,(item:string,index:number)=>{
            Column(){
              Text(item).font({
                size:16,
                weight:this.ruleType === item?500:400
              })
                .textAlign(TextAlign.Center)
                .lineHeight(24)
                .fontColor(this.ruleType === item?$r('app.color.theme_color'):$r('app.string.color_black_45'))
              Row().width(10).height(3).backgroundColor($r('app.color.theme_color')).borderRadius(8).offset({y:5})
                .visibility(this.ruleType === item?Visibility.Visible:Visibility.None)
                .opacity(this.ruleType === item?1:0)
                .scale({
                  centerX: "50%",
                  centerY: "50%",
                  x: this.ruleType === item ? 1 : 0,
                  y: this.ruleType === item ? 1 : 0,
                })
                .animation({
                  duration: 600,
                  curve: CommonConstants.UniCurve
                })
            }.onClick(()=>{
              this.ruleType = item
              this.tabsController.changeIndex(index)
            })
          })
        }
        Image($r('app.media.addSubscription')).width(24).bindMenu(this.MenuBuilder)
          // .bindMenu(this.MenuBuilder)
      }.margin({
        top:6,bottom:6,right:20,left:20
      })
      Search({
        placeholder:'搜索'
      }).margin({
        top:8,bottom:8,
        right:20,left:20
      })
      Stack(){
        if (this.ruleType === '替换净化'){
          RuleGroupType({
            coverShow:this.coverShow
          }).zIndex(9999).backgroundColor(!this.coverShow?Color.White:'')
        }

        Tabs({
          barPosition: BarPosition.Start,
          controller: this.tabsController
        }){
          TabContent(){
            this.ruleBuilder()
          }
          TabContent(){
            this.ruleBuilder()
          }
        }
        .barWidth(0)
        .barHeight(0)
        .onChange((index) => {
          this.tabsController.changeIndex(index)
          this.ruleType = index === 0 ? '替换净化' : '净化标题'
        })

      }
      .alignContent(Alignment.Top)
    }
    .backgroundColor(Color.White)
    .padding({
      top:this.topRectHeight
    })
  }

  @Builder ruleBuilder(){
    Scroll(){
      Column({
        space:12
      }){
        ForEach(this.ruleArray,(item:string)=>{
          if (this.ruleType === '替换净化'){
            this.ruleReplaceTitle(item)
          } else {
            this.ruleDirectoryTitle(item)
          }
        })
      }
      .padding({top:12,left:20,right:20,bottom:35})
    }
    .padding({top:this.ruleType === '替换净化'?30:0})
    .align(Alignment.TopStart)
    .scrollBar(BarState.Off)
  }

  @State isRule:boolean = false
  @Builder ruleReplaceTitle(title:string){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      alignItems:ItemAlign.Center
    }){
      Text(`${title}`).fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
      Row({
        space:6
      }){
        Toggle({ type: ToggleType.Switch, isOn: $$this.isRule})
          .selectedColor("#F60").hoverEffect(HoverEffect.None)
          .onChange(()=>{
            // updateAppData(this.APP_INDEX_SCROLLABLE)
            // showMessage(this.APP_INDEX_SCROLLABLE?'标签栏锁已开启':'标签栏已解锁')
          })
        Image($r('app.media.more_translate')).width(24).height(24)
      }
    }
    .padding({left:16,right:16,top:12,bottom:12})
    //阴影
    .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.20)' })
    // .border({width:1,color:Color.Gray})
    .borderRadius(8)
    .backgroundColor(Color.White)
  }

  @Builder ruleDirectoryTitle(title:string){
    Column({
      space:5
    }){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }){
        Text(`${title}`).fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
        Row({
          space:6
        }){
          Toggle({ type: ToggleType.Switch, isOn: $$this.isRule})
            .selectedColor("#F60").hoverEffect(HoverEffect.None)
            .onChange(()=>{
              // updateAppData(this.APP_INDEX_SCROLLABLE)
              // showMessage(this.APP_INDEX_SCROLLABLE?'标签栏锁已开启':'标签栏已解锁')
            })
          Image($r('app.media.more_translate')).width(24).height(24)
        }
      }
      Text(`${title}`).fontSize(12).fontWeight(400).fontColor($r('app.string.color_black_45'))
    }
    .alignItems(HorizontalAlign.Start)
    .padding({left:16,right:16,top:12,bottom:12})
    //阴影
    .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.20)' })
    // .border({width:1,color:Color.Gray})
    .borderRadius(8)
    .backgroundColor(Color.White)
  }

  MoreList: string[] = ['新建替换', '粘贴导入', '本地导入','批量管理','帮助']
  moreIcon: Resource[] = [$r('app.media.add_shelf'),$r('app.media.Paste'),$r('app.media.export'),$r('app.media.batch_svg'),$r('app.media.my_center_help_icon')]
  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column}) {
      ForEach(this.MoreList, (item: String, index) => {
        Column() {
          Row() {
            Image(this.moreIcon[index])
              .width(24)
              .height(24)
              .margin({
                right: 5
              })
              .fillColor(Color.Black)
            Text(`${item}`).fontSize(14)
          }
          .height(40)
          .onClick(() => {
            // this.MenuOnclick(index)
          })

          Divider()
        }
        .alignItems(HorizontalAlign.Start)
        .padding(5)
        .height(40)
        .margin({ bottom: 20 })
      })
    }
    .width(100)
  }
}