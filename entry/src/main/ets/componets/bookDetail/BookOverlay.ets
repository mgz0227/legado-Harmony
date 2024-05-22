

@Component
export default struct BookOverlay {
  @Prop bookWidth:number
  @Prop bookHeight:number
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
        .width(this.bookWidth).height(this.bookHeight)
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
      .width(this.bookWidth).height(this.bookHeight)
      .backgroundImage(this.bookImage)
      .backgroundImageSize({width:this.bookWidth,height:this.bookHeight})
      .zIndex(2)

      Row(){
        Image($r('app.media.occlusion1'))
      }
      .zIndex(1)
      .width(this.bookWidth + 5).height(this.bookHeight + 5)

      Row(){
        Image($r('app.media.occlusion2'))
      }.zIndex(0)
      .width(this.bookWidth + 10).height(this.bookHeight + 10)
    }
    .align(Alignment.BottomStart)
  }
}