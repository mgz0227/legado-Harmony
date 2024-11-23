import { PublicConstants } from '../../common/constants/PublicConstants'
import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'
import { dataItem } from '../dataList/dataItem'


@Component
export struct cloudDisKBindSheetComponet{
  @Prop items:dataItem[]
  @Link bindSheetIndex:number
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    Column({space:16}){
      ForEach(this.items,(item:dataItem,index:number)=>{
        Row({space:10}){
          //$r("app.media.my_center_file_icon")
          Image(item.type==1?$r("app.media.phone_icon"):$r("app.media.my_center_file_icon"))
            .size({width:20,height:20})
            .fillColor(index==this.bindSheetIndex ? this.theme.mainColor :  Color.Black)
          Text(item.title).fontSize(14)
            .lineHeight(22)
            .fontColor(index==this.bindSheetIndex? this.theme.mainColor :Color.Black)
        }.padding({top:14,bottom:14,left:20,right:20})
        .width(280)
        .borderRadius(8)
        .backgroundColor(index==this.bindSheetIndex? this.theme.secondColor:"rgb(245, 245, 245)")
        .onClick(()=>{
          this.bindSheetIndex=index
        })
        .border({
          width:index==this.bindSheetIndex?1:0,
          color:index==this.bindSheetIndex? this.theme.mainColor :PublicConstants.THEME_COLOR_WHITE
        })
      })
    }.padding({top:12,left:20,right:20})

  }
}