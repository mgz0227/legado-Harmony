/**
 * @author 2008
 * @datetime 2024/6/12 21:48
 * @className: purificationView
 */
import ruleView from './ruleView';

@Component
export default struct purificationView{
  @Link isShowPurification: boolean;
  @State isRule: boolean = false;
  ruleViewDialog: CustomDialogController | null = new CustomDialogController({
    builder: ruleView(),
    cancel: this.clickExitDialog,
    autoCancel: true,
    alignment: DialogAlignment.Top,
    customStyle:true
  })
  clickExitDialog(){
    this.ruleViewDialog?.close()
  }

  build() {
    Column(){
      Column({
        space:12
      }){
        this.titleContent('替换净化')
        this.titleContent('移除重复标题')
        this.titleContent('重新分段')
        this.titleContent('反转内容')
        this.titleContent('编辑内容',true)
        Column(){
          this.titleContent('净化规则管理',true)
        }.onClick(()=>{
          this.ruleViewDialog?.open()
        })
      }.padding({top:16,left:20,right:20,bottom:16})
      Divider()
      Column({
        space:12
      }){
       Text('取消').fontSize(16).fontWeight(400).fontColor($r('app.string.color_black_88'))

      }
      .onClick(()=>{
        this.isShowPurification = false
      })
      .padding({top:16,left:20,right:20,bottom:16})
    }
  }

  @Builder titleContent(title:string,isToggle:boolean = false){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      alignItems:ItemAlign.Center
    }){
      Text(title).fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
      if (!isToggle){
        Toggle({ type: ToggleType.Switch, isOn: false})
          .selectedColor("#F60").hoverEffect(HoverEffect.None)
      } else {
        Image($r('app.media.icon_right')).width(25).height(25)
      }

    }
  }
}