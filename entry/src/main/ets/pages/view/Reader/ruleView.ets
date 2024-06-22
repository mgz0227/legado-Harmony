/**
 * @author 2008
 * @datetime 2024/6/15 20:00
 * @className: ruleView
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import buttonCommon from '../../../componets/common/buttonCommon'
import { showMessage } from '../../../componets/common/promptShow'
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
    '中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)1','中文标题转数字(可选)(标题)2','中文标题转数字(可选)(标题)3',
      '中文标题转数字(可选)(标题)4','中文标题转数字(可选)(标题)5','中文标题转数字(可选)(标题)6','中文标题转数字(可选)(标题)7']
  controller?: CustomDialogController
  tabsController: TabsController = new TabsController();
  @State checkRule:boolean = false
  @State checkedRuleList:Array<string> = [] //选中的规则
  checkedRuleListPush(title:string,checkRule:boolean){
    //checkRule为false时候移除从checkedRuleList中移除title,当checkRule为true时将title添加到checkedRuleList同时要校验里面是否存在相同值不存在才push
    if (checkRule){
      if (this.checkedRuleList.includes(title)){
        return
      }
      this.checkedRuleList.push(title)
    }else{
      this.checkedRuleList = this.checkedRuleList.filter(item => item !== title)
    }
    this.ruleNumber = this.checkedRuleList.length
  }
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
    .bindSheet($$this.isRuleChange, this.menuBuilder(), {
      height: '95%',
      showClose: false,
      dragBar: true,
      backgroundColor:Color.White,
      onDisappear: () => {
        // this.clickBookType = ''
      }
    })
    .backgroundColor(Color.White)
    .padding({
      top:this.topRectHeight
    })
  }
  @State ruleNumber:number = 0
  @State ruleAll:number = this.ruleArray.length
  @Builder menuBuilder() {
    Column(){
      Column() {
        Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
      }
      .padding({ top: 12,bottom:12 })
      Column(){
        this.ruleBuilder(true)
      }
      .height('83%')
      Column(){
        Row(){
          Checkbox().selectedColor($r('app.color.theme_color')).margin({right:8}).select(this.checkRule)
            .onChange(()=>{
              this.checkRule = !this.checkRule
            })
          Text(this.ruleNumber!==this.ruleAll?$r('app.string.select_all'):$r('app.string.deselect_all')).fontColor($r('app.string.color_black_88')).font({
            size:16,
            weight:400
          })
            .lineHeight(24)
            .margin({right:8})
          Text('(')
            .fontColor($r('app.string.color_black_88')).font({
            size:16,
            weight:400
          })
            .lineHeight(24)
          Text(`${this.ruleNumber}`).fontColor($r('app.color.theme_color'))
            .font({
              size:16,
              weight:400
            })
            .lineHeight(24)
          Text(`/${this.ruleAll})`)
            .fontColor($r('app.string.color_black_88')).font({
            size:16,
            weight:400
          })
            .lineHeight(24)
        }
        .alignItems(VerticalAlign.Center)
        .padding({left:20})
        buttonCommon({
          cancel:()=>{
            this.isRuleChange = false
          },
          confirm:()=>{
            showMessage('test111')
          }
        })
          .padding({bottom:12})
      }.alignItems(HorizontalAlign.Start)
    }
  }


  @Builder ruleBuilder(isTop:boolean = false){
    Scroll(){
      Column({
        space:12
      }){
        ForEach(this.ruleArray,(item:string)=>{
          if (this.ruleType === '替换净化'){
            this.ruleReplaceTitle(item,isTop)
          } else {
            this.ruleDirectoryTitle(item,isTop)
          }
        })
      }
      .padding({top:12,left:20,right:20,bottom:isTop?20:35})
    }
    .padding({top:!isTop?this.ruleType === '替换净化'?30:0:0})
    .align(Alignment.TopStart)
    .scrollBar(BarState.Off)
  }

  @State isRule:boolean = false
  @Builder ruleReplaceTitle(title:string,isShowCheck:boolean = false){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      alignItems:ItemAlign.Center
    }){
      Text(`${title}`).fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
      Row({
        space:6
      }){
        if (!isShowCheck){
          Toggle({ type: ToggleType.Switch, isOn: $$this.isRule})
            .selectedColor("#F60").hoverEffect(HoverEffect.None)
            .onChange(()=>{
              // updateAppData(this.APP_INDEX_SCROLLABLE)
              // showMessage(this.APP_INDEX_SCROLLABLE?'标签栏锁已开启':'标签栏已解锁')
            })
          Image($r('app.media.more_translate')).width(24).height(24)
        } else {
          Checkbox({
            name: title
          })
            .selectedColor($r('app.color.theme_color'))
            .select(this.checkRule)
            .onChange((value:boolean)=>{
              this.checkedRuleListPush(title,value)
            })
        }
      }
    }
    .padding({left:16,right:16,top:12,bottom:12})
    //阴影
    .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.20)' })
    // .border({width:1,color:Color.Gray})
    .borderRadius(8)
    .backgroundColor(Color.White)
  }

  @Builder ruleDirectoryTitle(title:string,isShowCheck:boolean = false){
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
          if (!isShowCheck){
            Toggle({ type: ToggleType.Switch, isOn: $$this.isRule})
              .selectedColor("#F60").hoverEffect(HoverEffect.None)
            Image($r('app.media.more_translate')).width(24).height(24)
          } else {
            Checkbox({
              name: title
            })
              .select(this.checkRule)
              .onChange((value:boolean)=>{
                this.checkedRuleListPush(title,value)
              })
              .selectedColor($r('app.color.theme_color'))
          }
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
  moreIcon: Resource[] = [$r('app.media.icon_rule_add'),$r('app.media.icon_rule_paste'),$r('app.media.icon_rule_export'),$r('app.media.icon_rule_batch'),$r('app.media.icon_rule_help')]
  @State isRuleChange:boolean = false
  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column}) {
      ForEach(this.MoreList, (item: String, index) => {
        Column() {
          Row() {
            Image(this.moreIcon[index])
              .width(20)
              .height(20)
              .margin({
                right: 8
              })
              .fillColor($r('app.string.color_black_88'))
            Text(`${item}`).fontSize(14)
          }
          .height(40)
          .onClick(()=>{
            this.ruleDialog(index)
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

  ruleDialog(index:number){
    switch (index){
      case 0: this.isRuleChange = true;
    }
  }
}