@Component
export default struct groupTypePanel{
  @Link groupCoverShow:boolean
  build() {
    Column({
      space:15
    }){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.End
      }){
        Row({space:12}){
          Text('显示分组').fontSize(16).fontWeight(500).lineHeight(24).fontColor('rgba(0, 0, 0, 0.88)')
          Text('点击进入').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
        }.alignItems(VerticalAlign.Bottom)
        Row({space:12}){
          Text('管理').fontSize(12).fontWeight(400).lineHeight(20).fontColor($r('app.color.theme_color'))
          Image($r('app.media.close')).width(24).height(20).onClick(()=>{
            this.groupCoverShow = false
          })
        }
      }
      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
        justifyContent:FlexAlign.Start
      }){
        Row(){
          this.GroupType()
        }.width('25%')
        Row(){
          this.GroupType1('全部')
          //后续添加右上角图
        }.width('25%')
        Row(){
          this.GroupType1('未分组')
        }.width('25%')
        Row(){
          this.GroupType1('本地')
        }.width('25%')
        Row(){
          this.GroupType1('书单')
        }.width('25%')
      }

      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.End
      }){
        Row({space:12}){
          Text('隐藏分组').fontSize(16).fontWeight(500).lineHeight(24).fontColor('rgba(0, 0, 0, 0.88)')
          Text('点击进入,长按编辑').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
        }.alignItems(VerticalAlign.Bottom)
        Row({space:8}){
          Image($r('app.media.help')).width(20).height(20)
          Text('标签锁').fontSize(16).fontWeight(500).lineHeight(24).fontColor('rgba(0, 0, 0, 0.45)')
          Toggle({ type: ToggleType.Switch, isOn: false})
            .selectedColor("#F60").hoverEffect(HoverEffect.None)
        }.alignItems(VerticalAlign.Bottom).justifyContent(FlexAlign.End)
      }
      Scroll(){
        if (true){
          Flex({
            direction: FlexDirection.Row
          }){
            Row(){
              this.GroupType1('游戏')
            }.width('25%')
            Row(){
              this.GroupType1('未分组')
            }.width('25%')
            Row(){
              this.GroupType1('本地')
            }.width('25%')
            Row(){
              this.GroupType1('书单')
            }.width('25%')
            Row(){
              this.GroupType1('书单')
            }.width('25%')
          }
        } else {
          Flex({
            justifyContent:FlexAlign.Center
          }){
            Text('暂无隐藏分组').fontSize(12).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
          }
          .borderRadius(4)
          .width('100%')
          .backgroundColor('rgba(0, 0, 0, 0.04)')
          .padding({top:6,bottom:6})

        }
      }.scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)

    }
    .borderRadius({bottomLeft:20,bottomRight:20})
    .padding({left:20,right:20,top:12,bottom:20})
    .width('100%').backgroundColor(Color.White)
  }
  @Builder GroupType(){
    Row(){
      Text('分组').fontWeight(500).fontSize(12).textOverflow({
        overflow:TextOverflow.Ellipsis
      }).ellipsisMode(EllipsisMode.END)
        .maxLines(1).fontColor($r('app.color.theme_color'))
        .textAlign(TextAlign.Center)
    }
    .margin({ right: 16, bottom: 16 })
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .width(68)
    .backgroundColor('rgba(0, 0, 0, 0.04)').padding({left:16,right:16,top:6,bottom:6})
  }
  @Builder GroupType1(title:string){
    Row(){
      Text(title).fontWeight(500).fontSize(12).textOverflow({
        overflow:TextOverflow.Ellipsis
      }).ellipsisMode(EllipsisMode.END)
        .maxLines(1).fontColor(Color.Black)
        .textAlign(TextAlign.Center)
    }

    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .width(68)
    .backgroundColor('rgba(0, 0, 0, 0.04)').padding({left:16,right:16,top:6,bottom:6})
  }
}