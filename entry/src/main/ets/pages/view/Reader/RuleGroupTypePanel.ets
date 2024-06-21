import { showMessage } from '../../../componets/common/promptShow'
import { folderList } from '../../../componets/dataList/folderList'

@Component
export default struct RuleGroupTypePanel{
  @Link groupCoverShow:boolean
  @State isShowIcon:boolean = false
  @Link ruleList:Array<string>


  @StorageProp('GROUP_LIST_DATA') groupData:folderList[] = []

  @StorageProp('APP_INDEX_SCROLLABLE') APP_INDEX_SCROLLABLE: boolean = true
  build() {
    Column({
      space:15
    }){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.End
      }){
        Row({space:12}){
          Text('分组管理').fontSize(16).fontWeight(500).lineHeight(24).fontColor('rgba(0, 0, 0, 0.88)')
          Text('点击进入,长按编辑').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
        }.alignItems(VerticalAlign.Bottom)
        Row({space:12}){
          Text(this.isShowIcon?'完成':'管理').fontSize(12).fontWeight(400).lineHeight(20).fontColor($r('app.color.theme_color'))
            .onClick(()=>{
              this.isShowIcon = !this.isShowIcon
            })
          Image($r('app.media.close')).width(24).height(20).onClick(()=>{
            this.groupCoverShow = false
            this.isShowIcon = false
          })
        }
      }
      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
        justifyContent:FlexAlign.Start
      }){
        ForEach(this.ruleList,(item:string,index:number)=>{
          if (index === 0) {
            Row(){
              this.GroupTypeColor(item)
              if (this.isShowIcon) {
                Image($r('app.media.sort')).width(12).height(12).offset({x:-20,y:-20})
              }
            }.width('25%')
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.dragIndex = index // 获取当前拖拽子组件的索引
                console.info('onTouch' + this.dragIndex)
              }
            })
            .draggable(this.isShowIcon)
            .onDragStart(()=>{
              console.log('onDragStart')
            })
            .onDrop((event: DragEvent, extraParams: string) => {
              console.log('onDrop')
              this.changeIndex(this.dragIndex, index)
            })

          } else {
            Row(){
              this.GroupType(item)
              if (this.isShowIcon) {
                Image($r('app.media.sort')).width(12).height(12).offset({x:-20,y:-20})
              }
            }.width('25%')
            .draggable(this.isShowIcon)
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.dragIndex = index // 获取当前拖拽子组件的索引
                console.info('onTouch' + this.dragIndex)
              }
            })
            .onDragStart(()=>{
              console.log('onDragStart')
            })
            .onDrop((event: DragEvent, extraParams: string) => {
              console.log('onDrop')
              this.changeIndex(this.dragIndex, index)
            })
          }
        })
      }
    }

    .borderRadius({bottomLeft:20,bottomRight:20})
    .padding({left:20,right:20,top:12,bottom:12})
    .width('100%').backgroundColor(Color.White)
  }


  @State dragIndex: number = 0
  changeIndex(index1: number, index2: number) { // 交换数组位置
    if (!this.isShowIcon) {
      showMessage('请在管理状态下拖到改变顺序')
      return
    }

    let temp1 = this.ruleList[index1];
    this.ruleList[index1] = this.ruleList[index2];
    this.ruleList[index2] = temp1;
  }
  @Builder GroupTypeColor(title:string){
    Column(){
      Row(){
        Text(title).fontWeight(500).fontSize(12).textOverflow({
          overflow:TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END)
          .maxLines(1).fontColor($r('app.color.theme_color'))
          .textAlign(TextAlign.Center)
      }
      .margin({ right: 16, bottom: 16 })
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width(68)
      .backgroundColor('rgba(252, 121, 0, 0.12)')
      .padding({left:16,right:16,top:6,bottom:6})
    }
  }
  @Builder GroupType(title:string){
   Column(){
     Row(){
       Text(title).fontWeight(500).fontSize(12).textOverflow({
         overflow:TextOverflow.Ellipsis
       }).ellipsisMode(EllipsisMode.END)
         .maxLines(1).fontColor(Color.Black)
         .textAlign(TextAlign.Center)
     }
     .margin({ right: 16, bottom: 16 })
     .justifyContent(FlexAlign.Center)
     .alignItems(VerticalAlign.Center)
     .width(68)
     .backgroundColor('rgba(0, 0, 0, 0.04)').padding({left:16,right:16,top:6,bottom:6})
   }
  }
}