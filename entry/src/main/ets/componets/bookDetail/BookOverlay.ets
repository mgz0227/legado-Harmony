import CommonConstants from '../../common/constants/CommonConstants'

@Component
export default struct BookOverlay {
  // @Prop bookWidth:number
  // @Prop bookHeight:number
  @Prop bookImage:Resource
  @Prop isTop:boolean
  @Prop isShow:boolean = false
  build() {

    Stack(){
      if (this.isShow){
        Column(){

        }
        .zIndex(3)
        .backgroundColor('rgba(0,0,0,0.45)')
        .width(CommonConstants.NOVEL_IMG_WIDTH).height(CommonConstants.NOVEL_IMG_HEIGHT)
      }
      Flex({
        alignItems: ItemAlign.End,
      }){
        if (this.isTop){
          Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
            .backgroundColor('rgba(0, 0, 0, 0.45)')
        }
      }
      .align(Alignment.Start)
      .width(CommonConstants.NOVEL_IMG_WIDTH).height(CommonConstants.NOVEL_IMG_HEIGHT)
      .backgroundImage(this.bookImage)
      .backgroundImageSize({width:CommonConstants.NOVEL_IMG_WIDTH,height:CommonConstants.NOVEL_IMG_HEIGHT})
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
  }
}