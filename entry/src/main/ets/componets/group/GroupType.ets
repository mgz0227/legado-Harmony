import BookType from '../head/BookType'
import groupTypePanel from './groupTypePanel'

@Component
export default struct groupTypeComponent {
  @State globalPositionY: Length = 0
  @Link bookType: string
  @Link currentIndex: number
  @Link groupCoverShow:boolean
  @Link GROUP:string

  build() {
    if (this.groupCoverShow){
      Stack(){
        groupTypePanel({
          groupCoverShow:this.groupCoverShow
        })
          .zIndex(9999)
        Rect()
          // .fillOpacity(0)
          .height('100%')
          .width('100%')
          .fill('rgba(0, 0, 0, 0.45)')
          .offset({y:20})

      }.alignContent(Alignment.TopStart)
    } else {
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Scroll() {
          Row({ space: 10 }) {
            BookType({ title: '分组', bookType: this.bookType }).onClick(() => {
              this.bookType = '分组'
              this.GROUP = '文件夹'
            })
            BookType({ title: '全部', bookType: this.bookType }).onClick(() => {
              this.bookType = '全部'
            })
            BookType({ title: '未分组', bookType: this.bookType }).onClick(() => {
              this.bookType = '未分组'
            })
            BookType({ title: '本地', bookType: this.bookType }).onClick(() => {
              this.bookType = '本地'
            })
            BookType({ title: '书单', bookType: this.bookType }).onClick(() => {
              this.bookType = '书单'
            })
            if (this.currentIndex === 0) {
              BookType({ title: '玄幻', bookType: this.bookType }).onClick(() => {
                this.bookType = '玄幻'
              })
              BookType({ title: '修仙', bookType: this.bookType }).onClick(() => {
                this.bookType = '修仙'
              })
              BookType({ title: '女同', bookType: this.bookType }).onClick(() => {
                this.bookType = '女同'
              })
              BookType({ title: '军事', bookType: this.bookType }).onClick(() => {
                this.bookType = '军事'
              })
            } else if (this.currentIndex === 1) {
              BookType({ title: '国漫', bookType: this.bookType }).onClick(() => {
                this.bookType = '国漫'
              })
              BookType({ title: '日漫', bookType: this.bookType }).onClick(() => {
                this.bookType = '日漫'
              })
            } else if (this.currentIndex === 2) {
              BookType({ title: '广播', bookType: this.bookType }).onClick(() => {
                this.bookType = '广播'
              })
              BookType({ title: '深夜电台', bookType: this.bookType }).onClick(() => {
                this.bookType = '深夜电台'
              })
            }
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
        Row(){
          Image($r('app.media.more_search')).width(25).height(25)
        }.width(
          '10%'
        ).onClick(()=>{
          this.groupCoverShow = true
        })
        // .bindPopup(this.groupCoverShow, {
        //   builder: this.groupTypePanel,
        //   placement: Placement.Bottom,
        //   // mask:true,
        //   radius:10,
        //   offset: {y:-35},
        //   // mask:{color:'rgba(0,0,0,0.45)'},
        //   enableArrow: false,
        //   // autoCancel:false,
        //   width:'100%',
        //   popupColor:Color.Transparent,
        //   onStateChange: (e) => {
        //     if (!e.isVisible) {
        //       this.groupCoverShow = false;
        //     }
        //   }
        // })
      }.margin({ left: 15,bottom:10})
    }

  }

  @Builder
  groupTypePanel() {
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
        if (false){
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
      }  .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)

    }
    .padding({left:20,right:20,top:12})
    .width('100%').height('30%').backgroundColor(Color.White)
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