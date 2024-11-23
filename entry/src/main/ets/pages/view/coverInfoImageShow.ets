/**
 * @author 2008
 * @datetime 2024/5/27 16:09
 * @className: coverInfoImageShow
 */
import CommonConstants from '../../common/constants/CommonConstants'
import { ThemeStorageKey } from '../../common/constants/Theme'
import { ThemeItem } from '../../common/model/Theme'
import BookOverlay from '../../componets/bookDetail/BookOverlay'

@Component
export default struct coverInfoImageShow {
  @Prop coverCount:number
  @Prop image:Resource|string
  @Prop imageString:string
  @Prop selectImage:number = 0
  onSelectImageNumber:Function = (_selectImage:number)=>{}
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    if (this.coverCount === 1){
      this.coverImageOne(this.image)
    } else if (this.coverCount === 2){
      this.coverImageTwo()
    } else if (this.coverCount === 3){
      this.coverImageThree()
    }
  }

  @Builder coverImageOne(bookImage:Resource|string){
    Column(){
      BookOverlay({
        bookImage:bookImage
      })
      Row().width(86)
        .height(20)
        .backgroundColor(Color.White)
        .borderRadius(2)
        .shadow({ radius: 5, color: 'rgba(0, 0, 0, 0.10)' })
      Row({
        space:12
      }){
        Text('默认样式')
          .fontWeight(400)
          .fontSize(14)
          .fontColor($r('app.string.color_black_45'))
          .lineHeight(22)
        Radio({value:JSON.stringify('0'),group:'radioGroup'})
          .checked(this.selectImage === 0)
          .radioStyle({
            checkedBackgroundColor: this.theme.mainColor
          })
          .border({width:2,color:'rgba(255, 255, 255, 0.10)'})
          .width(20).height(20)
          .onChange((val)=>{
            val? this.onSelectImageNumber(0):''
          })
      }
      .padding({top:8})
    }
  }

  @Builder coverImageTwo(){
    Column(){
      Stack(){
        Flex({
          alignItems: ItemAlign.End,
        }){
          if (this.imageString) {
            Image(this.imageString).draggable(false)
          } else {
            Column(){
              Image($r('app.media.add_image')).width(24).height(24).draggable(false)
              Text('添加图片或gif').fontColor(Color.White).fontWeight(400).fontSize(10).lineHeight(18)
            }
            .padding({top:19,bottom:19,left:17,right:17})
          }
        }
        .borderRadius(5)
        .backgroundColor($r('app.string.color_black_65'))
        .align(Alignment.Start)
        .width(CommonConstants.NOVEL_IMG_WIDTH).height(CommonConstants.NOVEL_IMG_HEIGHT)
        .zIndex(2)

        Row(){
          Image($r('app.media.occlusion1')).draggable(false)
        }
        .zIndex(1)
        .width(CommonConstants.NOVEL_IMG_WIDTH + 5).height(CommonConstants.NOVEL_IMG_HEIGHT - 5)

        Row(){
          Image($r('app.media.occlusion2')).draggable(false)
        }.zIndex(0)
        .width(CommonConstants.NOVEL_IMG_WIDTH + 10).height(CommonConstants.NOVEL_IMG_HEIGHT - 10)
      }
      .align(Alignment.BottomStart)
      Row().width(86).height(20).backgroundColor(Color.White).borderRadius(2)
        .shadow({ radius: 5, color: 'rgba(0, 0, 0, 0.10)' })
      Row({
        space:12
      }){
        Text('自定义')
          .fontWeight(400).fontSize(14).fontColor($r('app.string.color_black_45')).lineHeight(22)
        Radio({value:JSON.stringify('1'),group:'radioGroup'})
          .checked(this.selectImage === 1)
          .radioStyle({
            checkedBackgroundColor: this.theme.mainColor
          })
          .border({width:2,color:'rgba(255, 255, 255, 0.10)'})
          .width(20).height(20)
          .onChange((val)=>{
            val? this.onSelectImageNumber(1):''
          })
      }
      .padding({top:8})
    }
  }

  @Builder coverImageThree(){
    Column(){
      Flex({
        alignItems: ItemAlign.End,
      }){
        if (this.imageString) {
          Image(this.imageString)
        } else {
          Column(){
            Image($r('app.media.add_image')).width(24).height(24)
            Text('添加图片或gif').fontColor(Color.White).fontWeight(400).fontSize(10).lineHeight(18)
          }.padding({top:37,bottom:37,left:14,right:13})
        }
      }
      .borderRadius(5)
      .backgroundColor($r('app.string.color_black_65'))
      .align(Alignment.Start)
      .width(CommonConstants.NOVEL_IMG_WIDTH + 14).height(CommonConstants.NOVEL_IMG_HEIGHT + 18)
      Row({
        space:12
      }){
        Text('全图样式')
          .fontWeight(400).fontSize(14).fontColor($r('app.string.color_black_45')).lineHeight(22)
        Radio({value:JSON.stringify('2'),group:'radioGroup'})
          .checked(this.selectImage === 2)
          .radioStyle({
            checkedBackgroundColor: this.theme.mainColor
          })
          .border({width:2,color:'rgba(255, 255, 255, 0.10)'})
          .width(20).height(20)
          .onChange((val)=>{
            val? this.onSelectImageNumber(2):''
          })
      }
      .padding({top:8})
    }
  }
}