import { SetList } from '../dataList/SetListGroup'

@Component
export struct SetListView{


  topLeft: number = 0

  topRight: number = 0

  bottomLeft: number = 0

  bottomRight: number = 0

  @ObjectLink setList :SetList


  build() {
    Row(){

      if (this.setList.bottomText != null && this.setList.bottomText.length > 0){
        Column(){
          Text(this.setList.value).fontSize(16).margin({bottom:10}).width('100%')
          Text(this.setList.bottomText).fontSize(13).fontColor('#8C8C8C').width('100%')
        }.width('75%')

      }else {
        Text(this.setList.value).fontSize(16)
      }



      Row(){
        if (this.setList.rightText != null && this.setList.rightText.length > 0){
          Text(this.setList.rightText).fontSize(13).fontColor('#8C8C8C')
        }

        if (this.setList.showArrow){
          Image($r("app.media.right")).size({width:25,height:25})
        }else {
          Toggle({ type: ToggleType.Switch, isOn: this.setList.toggleStatus}).onChange((isOn:boolean)=>{
            this.setList.toggleStatus = isOn;
          })
        }
      }.alignItems(VerticalAlign.Center)


    }.width("100%")
    .backgroundColor(Color.White)
    .padding(20)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .borderRadius({topLeft:this.topLeft,topRight:this.topRight,bottomLeft:this.bottomLeft,bottomRight:this.bottomRight})
  }
}