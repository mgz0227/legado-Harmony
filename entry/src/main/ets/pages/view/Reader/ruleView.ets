/**
 * @author 2008
 * @datetime 2024/6/15 20:00
 * @className: ruleView
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import buttonCommon from '../../../componets/common/buttonCommon'
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import operateIcon from '../../../componets/common/operateIcon'
import { showMessage } from '../../../componets/common/promptShow'
import { buttonList } from '../../../componets/dataList/buttonList'
import exportRuleDialog from '../../../componets/Reader/exportRuleDialog'
import directoryPurification from './directoryPurification'
import newAddRule from './newAddRule'
import RuleGroupType from './RuleGroupType'

@Preview
@CustomDialog
@Component
export default struct ruleView{
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State ruleTitle:Array<string> = ['替换净化','目录净化']
  @State ruleType:string = '替换净化'
  @State coverShow:boolean = false
  @State newReplacementRule:boolean = false
  @State ruleArray:Array<string> =
    ['一个目录 (标题)','书名净化标题 (标题)','JS标题(标题)','章节名称规整 (标题)','序号加括号 (标题)',
      '章节名重复① (标题)','章节名重复② (标题)','章节符号净化 (标题)','第XXX章 XXX(规范章节)(标题)',
    '中文标题转数字(可选)(标题)','中文标题转数字(可选)(标题)1','中文标题转数字(可选)(标题)2','中文标题转数字(可选)(标题)3',
      '中文标题转数字(可选)(标题)4','中文标题转数字(可选)(标题)5','中文标题转数字(可选)(标题)6','中文标题转数字(可选)(标题)7']
  @State isRuleCheck:boolean = false
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
    Flex({
      direction:FlexDirection.Column
    }){
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
      .animationIsBatchF()
      Column(){
        this.headTitle()
      }
      .padding({right:20,left:20})
      .animationIsBatchT()


      Search({
        placeholder:'搜索'
      }).margin({
        top:8,bottom:8,
        right:20,left:20
      })
        .animationIsBatchF()
      Stack(){
        if (this.ruleType === '替换净化'){
          RuleGroupType({
            coverShow:this.coverShow
          })
            .visibility(!this.isBatch?Visibility.Visible:Visibility.None)
            .opacity(!this.isBatch?1:0)
            .scale({
              centerX: "50%",
              centerY: "50%",
              x: !this.isBatch ? 1 : 0,
              y: !this.isBatch ? 1 : 0,
            })
            .animation({
              duration: 600,
              curve: CommonConstants.UniCurve
            })
            .zIndex(9999).backgroundColor(!this.coverShow?Color.White:'')
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
          this.ruleType = index === 0 ? this.ruleTitle[0] : this.ruleTitle[1]
        })
      }
      .alignContent(Alignment.Top)
      Column(){
        this.operateListBuilder()
      }
      .animationIsBatchT()
      //替换
      Flex(){

      }
      .bindSheet($$this.newReplacementRule, this.newAddRule(), {
        height: '95%',
        showClose: false,
        dragBar: true,
        backgroundColor:Color.White,
        onDisappear: () => {
          // this.clickBookType = ''
        }
      })
      //目录
      Flex(){

      }
      .bindSheet($$this.purification, this.directoryPurification(), {
        height: '95%',
        showClose: false,
        dragBar: true,
        backgroundColor:Color.White,
        onDisappear: () => {
          // this.clickBookType = ''
        }
      })

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
      top:this.topRectHeight,
      bottom:this.bottomRectHeight
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
    Flex({
      direction: FlexDirection.Column, wrap: FlexWrap.Wrap,
      alignItems:ItemAlign.Center
    }){
      Scroll(){
        Column({
          space:12
        }){
          ForEach(this.ruleArray,(item:string)=>{
            if (this.ruleType === this.ruleTitle[0]){
              this.ruleReplaceTitle(item,isTop)
            } else {
              this.ruleDirectoryTitle(item,isTop)
            }
          })
        }
        .padding({top:12,left:20,right:20,bottom:5})
      }
      .padding({top:!isTop?this.ruleType === this.ruleTitle[0]?this.isBatch?0:30:0:0})
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
    }
  }

  @State isRule:boolean = false
  @State isBatch:boolean = false
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

            })
          Image($r('app.media.more_translate')).width(24).height(24).bindMenu(this.moreTranslate(),{
            borderRadius:12
          })
            .animationIsBatchF()
          Checkbox().selectedColor($r('app.color.theme_color')).select(this.isRuleCheck)
            .onChange((value:boolean)=>{
              this.checkedRuleListPush(title,value)
            })
            .width(20).height(20)
            .animationIsBatchT()
        } else {
          Text('新增').font({
            size:12,
            weight:400
          }).fontColor($r('app.string.color_black_45'))
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
            Image($r('app.media.more_translate')).width(24).height(24).bindMenu(this.moreTranslate(),{
              borderRadius:12
            })
              .animationIsBatchF()
            Checkbox().selectedColor($r('app.color.theme_color')).select(this.isRuleCheck)
              .onChange((value:boolean)=>{
                this.checkedRuleListPush(title,value)
              })
              .width(20).height(20)
              .animationIsBatchT()
          } else {
            Text('新增').font({
              size:12,
              weight:400
            }).fontColor($r('app.string.color_black_45'))
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
  @State isEdit:boolean = false
  @Builder newAddRule(){
    Column(){
      newAddRule({
        cancel:() =>{
          this.newReplacementRule = false
        },
        isEdit:this.isEdit
      })
    }
  }
  @State purification:boolean = false
  @Builder directoryPurification(){
    Column(){
      directoryPurification({
        cancel:() =>{
          this.purification = false
        },
        isEdit:this.isEdit
      })
    }
  }

  @State moreTranslateMenu:buttonList[] = [
    new buttonList(0,'编辑',$r('app.media.icon_operate_top')),
    new buttonList(1,'置顶',$r('app.media.icon_operate_export')),
    new buttonList(2,'移动至',$r('app.media.icon_operate_move')),
    new buttonList(3,'删除',$r('app.media.delete_svg'))
  ]
  @Builder moreTranslate(){
    Flex({
      direction:FlexDirection.Column
    }){
      ForEach(this.moreTranslateMenu, (item: buttonList, index) => {
        if (!(this.ruleType === this.ruleTitle[1] && index === 2)){
         Column(){
           Row(){
             Image(item.icon)
               .width(20)
               .height(20)
               .margin({
                 right: 8
               })
               .fillColor($r('app.string.color_black_88'))
             Text(`${item.title}`).fontSize(14)
           }.onClick(()=>{
             this.moreTranslateFunction(index)
           })
           .padding({left:5,top:12,bottom:12})

           Divider()
         }
         .alignItems(HorizontalAlign.Start)
         .padding(5)
        }
      })
    }.width(100)
  }

  ruleDialog(index:number){
    switch (index){
      case 0:
        if (this.ruleType === this.ruleTitle[0]) {
          this.newReplacementRule = true;this.isEdit = false;break;
        } else {
          this.purification = true;this.isEdit = false;break;
        }
      case 1: this.isRuleChange = true;break;
      case 3: this.isBatch = !this.isBatch;break;
    }
  }

  moreTranslateFunction(index:number){
    switch (index){
      case 0:
        if (this.ruleType === this.ruleTitle[0]) {
          this.newReplacementRule = true;this.isEdit = true;break;
        } else {
          this.purification = true;this.isEdit = true;break;
        }
    }
  }

  @Builder headTitle(){
    Flex(
      {
        alignItems:ItemAlign.Center
      }
    ){
      Column(){
        Text(this.checkedRuleList.length === this.ruleArray.length ?'取消选择':'全选').fontSize(16).onClick(()=>{
          this.isRuleCheck = !this.isRuleCheck
        })
      }
      .alignItems(HorizontalAlign.Start)
      .width('33%')
      Column(){
        Text(`已选${this.checkedRuleList.length}项目`).fontSize(20).fontWeight(600)
      }.width('33%')
      Column(){
        Text('完成').fontSize(16)
      }.onClick(()=>{
        this.isBatch = false
        this.checkedRuleList = []
        this.isRuleCheck = false
      })
      .alignItems(HorizontalAlign.End)
      .width('33%')
    }
    .padding(10)
  }

  @Styles animationIsBatchF() {
    .visibility(!this.isBatch?Visibility.Visible:Visibility.None)
    .opacity(!this.isBatch?1:0)
    .scale({
      centerX: "50%",
      centerY: "50%",
      x: !this.isBatch ? 1 : 0,
      y: !this.isBatch ? 1 : 0,
    })
    .animation({
      duration: 600,
      curve: CommonConstants.UniCurve
    })
  }

  @Styles animationIsBatchT() {
    .visibility(this.isBatch?Visibility.Visible:Visibility.None)
    .opacity(this.isBatch?1:0)
    .scale({
      centerX: "50%",
      centerY: "50%",
      x: this.isBatch ? 1 : 0,
      y: this.isBatch ? 1 : 0,
    })
    .animation({
      duration: 600,
      curve: CommonConstants.UniCurve
    })
  }


  @State operateList:buttonList[] = [
    new buttonList(1,'置顶',$r('app.media.icon_operate_top')),
    new buttonList(2,'禁用',$r('app.media.icon_operate_export')),
    new buttonList(3,'导出',$r('app.media.icon_operate_export')),
    new buttonList(4,'移动至',$r('app.media.icon_operate_move')),
    new buttonList(5,'删除',$r('app.media.delete_svg'))
  ]
  @State operateDisable:boolean = false
  @Builder
  operateListBuilder() {
    GridRow({
      columns:this.ruleType === this.ruleTitle[1]?4:5
    }){
        ForEach(this.operateList,(item:buttonList)=>{
          if (!(this.ruleType === this.ruleTitle[1] && item.id === 4)) {
            GridCol(){
              if (item.id === 2) {
                Column(){
                  Toggle({ type: ToggleType.Switch, isOn: $$this.operateDisable})
                    .selectedColor($r('app.color.theme_color')).hoverEffect(HoverEffect.None)
                    .onChange(()=>{
                      if (this.checkedRuleList.length === 0) {
                        showMessage('请选择要禁用的内容')
                        this.operateDisable = false
                        return
                      }
                    })
                  Text(item.title).fontColor($r('app.string.color_black_88')).fontSize(12).fontWeight(400).lineHeight(20)
                }.padding({
                  top:12,bottom:12
                })
              } else {
                operateIcon({
                  item:item
                })
                  .onClick(()=>{
                    this.operateFunction(item.id)
                  })
              }
            }
          }
        })
    }
  }
  operateFunction(index:number){
    switch (index){
      case 3:
       this.operateExport();break;
    }
  }

  operateExport(){
    this.exportRuleDialogController?.open()
    showMessage('导出');
  }

  //弹窗
  exportRuleDialogController: CustomDialogController | null = new CustomDialogController({
    builder: exportRuleDialog(),
    backgroundColor: Color.Transparent,
    autoCancel: false,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 16,
  })
}