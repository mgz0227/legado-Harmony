import CommonConstants from '../../common/constants/CommonConstants'
import { showMessage } from '../common/promptShow'
import { dataItem } from '../dataList/dataItem'

@Component
export struct sourceTabs{
  @Prop sourceList:dataItem[]
  @Link read_index:number
  @State translateNum:number=0
  @State translateX:number=120
  @Builder read_builder(){
    Row(){
      ForEach(this.sourceList,(item:dataItem,index:number)=>{
        Row(){
          Text(item.title)
        }
        .width('50%')
        .backgroundColor("rgba(0, 0, 0, 0)")
        .justifyContent(FlexAlign.Center)
        .onClick((event)=>{
          let x=event.target.area.position.x?.toString()
          if( this.read_index>index){
            if(x!=undefined){
              this.translateNum-=parseInt(x)
            }
            if(index==0){
              this.translateNum=0
            }
          }else if( this.read_index<index){
            if(x!=undefined){
              this.translateNum=parseInt(x)
            }
          }
          this.read_index=index
        })
      })
    }.height(30)
    .width(CommonConstants.FULL_HEIGHT)
  }
  build() {
    Row(){
      Row()
        .backgroundColor(Color.White)
        .stateStyles({
          normal:this.readListStyles
        })
        .size({width:"50%",height:30})
        .translate({x:this.translateNum,y: 0,z: 0})
        .animation({
          duration:200,
          curve:Curve.Linear
        })
    }
    .overlay(this.read_builder(), {
      align: Alignment.Center,
      offset: { x: 0, y:0}
    })
    .width(CommonConstants.FULL_HEIGHT)
    .backgroundColor("rgba(0, 0, 0, 0.04)")
    .stateStyles({
      normal:this.readListStyles
    })
    .padding(2)
    .margin({top:12,bottom:12})
  }

  @Styles readListStyles(){
    .height(32)
    .borderRadius(30)
  }
}