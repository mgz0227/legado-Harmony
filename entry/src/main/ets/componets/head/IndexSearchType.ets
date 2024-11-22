import CommonConstants from '../../common/constants/CommonConstants'
import FontConstants from '../../common/constants/FontConstants'
import PaddingConstants from '../../common/constants/PaddingConstants'
import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'
import { BOOK_SEARCH_TYPE } from '../../database/entities/Books'

@Component
export default struct IndexSearchType {
  @Prop title:string
  @Link searchValue:string
  @State isShown: boolean = false
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  build() {
    if (BOOK_SEARCH_TYPE.includes(this.title)){
      Row(
        {
          space:3
        }
      ) {
        Text(this.title)
          .fontColor(this.searchValue === this.title ? 'rgba(0, 0, 0, 1.00)' :  'rgba(0,0,0,0.5)')
          .fontSize(15)
          .fontWeight(this.searchValue === this.title ? 600 : 400)
        Image(this.isShown?$r('app.media.direction_upper'):$r('app.media.direction_down'))
          .width(15).height(15)
          .opacity(this.title === this.searchValue?1:0.3)
      }
      .onClick(()=>{
        this.searchValue = this.title
        this.isShown = !this.isShown
      })
      .bindPopup(this.isShown,{
        builder: this.MenuBuilder(),
        placement: Placement.Bottom,
        enableArrow:true,
        radius:12,
        onStateChange: (e) => {
          if (!e.isVisible) {
            this.isShown = false;
          }
        }
      })
      // .bindMenu(this.isShown, this.MenuBuilder,
      //   {
      //     onDisappear: ()=>{
      //       this.isShown = false;
      //     }
      //   })
    } else {
      Row(
        {
          space:3
        }
      ) {
        Text(this.title)
          .fontColor(this.searchValue === this.title ? 'rgba(0, 0, 0, 1.00)' :  'rgba(0,0,0,0.5)')
          .fontSize(15)
          .fontWeight(this.searchValue === this.title ? 600 : 400)
      }
    }

  }

  @Builder MenuBuilder() {
    Column(){
      ForEach(BOOK_SEARCH_TYPE, (item:string, index) => {
        Column() {
          Row() {
            Text(item)
              .font({
                size: FontConstants.FONT_SIZE_14,
                weight: FontConstants.FONT_WEIGHT_400,
                family: CommonConstants.FAMILY_PingFANG
              })
              .fontColor(this.searchValue === item ? this.theme.mainColor : $r('app.string.color_black_88'))
            Image(item ===  this.searchValue?$r('app.media.hook'):'').width(20).height(20)
          }
          .padding({
            top: PaddingConstants.PADDING_12,
            bottom: PaddingConstants.PADDING_12,
            left:PaddingConstants.PADDING_20,
            right:PaddingConstants.PADDING_20
          })
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.SpaceBetween)
          .align(Alignment.Center)
          .onClick(() => {
            this.title = item
            this.searchValue = item
            this.isShown = false
          })
          if (index != BOOK_SEARCH_TYPE.length - 1) {
            Divider().height(10).width('80%').color('#ccc')
          }
        }
      })
    }
    .padding(PaddingConstants.PADDING_4)
    .width(150)
  }
}