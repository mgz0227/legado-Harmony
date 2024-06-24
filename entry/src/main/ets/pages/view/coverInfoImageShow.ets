/**
 * @author 2008
 * @datetime 2024/5/27 16:09
 * @className: coverInfoImageShow
 */
import CommonConstants from '../../common/constants/CommonConstants'
import BookOverlay from '../../componets/bookDetail/BookOverlay'

@Component
export default struct coverInfoImageShow {
  @Prop coverCount:number
  @Prop image:Resource
  @Prop imageString:string
  build() {
    if (this.coverCount === 1){
      this.coverImageOne(this.image)
    } else if (this.coverCount === 2){
      this.coverImageTwo()
    } else if (this.coverCount === 3){
      this.coverImageThree()
    }
  }

  @Builder coverImageOne(bookImage:Resource){
    Column(){
      BookOverlay({
        bookImage:bookImage,
        // isTop:this.folderList.isTop
      })
      Row().width(86).height(20).backgroundColor(Color.White).borderRadius(2)
        .shadow({ radius: 5, color: 'rgba(0, 0, 0, 0.10)' })
      // .border({width:1,color:'rgba(255, 255, 255, 0.10)'})
      Row({
        space:12
      }){
        Text('默认样式')
          .fontWeight(400).fontSize(14).fontColor($r('app.string.color_black_45')).lineHeight(22)
        Radio({value:'default',group:'radioGroup'})
          .radioStyle({
            checkedBackgroundColor: $r('app.color.theme_color')
          })
          .border({width:2,color:'rgba(255, 255, 255, 0.10)'})
          .width(20).height(20)
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
            Image(this.imageString)
          } else {
            Column(){
              Image($r('app.media.add_image')).width(24).height(24)
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
          Image($r('app.media.occlusion1'))
        }
        .zIndex(1)
        .width(CommonConstants.NOVEL_IMG_WIDTH + 5).height(CommonConstants.NOVEL_IMG_HEIGHT - 5)

        Row(){
          Image($r('app.media.occlusion2'))
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
        Radio({value:'customize',group:'radioGroup'})
          .radioStyle({
            checkedBackgroundColor: $r('app.color.theme_color')
          })
          .border({width:2,color:'rgba(255, 255, 255, 0.10)'})
          .width(20).height(20)
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
        Radio({value:'allStyle',group:'radioGroup'})
          .radioStyle({
            checkedBackgroundColor: $r('app.color.theme_color')
          })
          .border({width:2,color:'rgba(255, 255, 255, 0.10)'})
          .width(20).height(20)
      }
      .padding({top:8})
    }
  }
}