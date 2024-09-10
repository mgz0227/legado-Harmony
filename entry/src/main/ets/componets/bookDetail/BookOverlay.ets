import CommonConstants from '../../common/constants/CommonConstants'

@Component
export default struct BookOverlay {
  @Prop bookImage:Resource|string
  @Prop isTop:boolean
  @Prop isShow:boolean = false
  @Prop coverType:number = 0
  build() {

    Stack(){
      if (this.isShow){
        Column(){

        }
        .zIndex(3)
        .backgroundColor('rgba(0,0,0,0.45)')
        .width(CommonConstants.NOVEL_IMG_WIDTH).height(CommonConstants.NOVEL_IMG_HEIGHT)
      }

      Stack(){
        if (this.isTop){
          Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
            .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
        }
        Image(this.bookImage)
          .draggable(false)
          .alt($r('app.media.icon_book_default_cover_one'))
          .width(CommonConstants.NOVEL_IMG_WIDTH)
          .height(CommonConstants.NOVEL_IMG_HEIGHT)
      }
      .zIndex(2)
      .alignContent(Alignment.BottomStart)
      if (this.coverType !== 2){
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
    }
    .align(Alignment.BottomStart)
  }
}