import CommonConstants from '../../common/constants/CommonConstants'
import { PublicConstants } from '../../common/constants/PublicConstants'
import { readBookList } from '../dataList/readBookList'


@Component
export struct readStatisticsDataList{
  @Prop dateValue:number[]
  @Link bookList:readBookList[]
  @State translateX:number=0
  @State bookIndex:number=0
  @State screenStartX: number = 0
  @State screenStartY: number = 0
  @State lastScreenX: number = 0
  @State lastScreenY: number = 0
  @Consume delStatus:boolean
  @Builder text(value:string,back:ResourceColor="rgba(0, 0, 0, 0.45)"){
    Text(value)
      .fontSize(12)
      .fontWeight(400)
      .lineHeight(20)
      .fontColor(back)
  }
  scroller: Scroller = new Scroller()
  // 时间 本数
  @Builder readHeader(dateValue:number[]){

    Row(){
      Text(`${dateValue[0]}年读过${dateValue[1]}本`)
        .fontSize(16)
        .lineHeight(24)
        .fontWeight(500)
    }.padding({top:12,bottom:12})
    .width("100%")
    .justifyContent(FlexAlign.Start)
  }
  //作者及书名
  @Builder bookAuthor(book:readBookList){
    Column({space:12}){
      Text(book.bookName).fontSize(16).lineHeight(24)
      Column(){
        this.text(book.author)
        this.text(`累计阅读${book.readingDuration[0]}小时${book.readingDuration[1]}分钟`)
      }.alignItems(HorizontalAlign.Start)
    }.alignItems(HorizontalAlign.Start)
    .width("50%")
    .height(80)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({left:12})
  }
  //时间及进度
  @Builder bookTime(status:boolean,dateTime:Date,schedule:number,index:number){
    Column({space:30}){
      if(this.delStatus){
        Checkbox({ name: 'checkbox1'+index, group: 'checkboxGroup' })
          .select(status)
          .selectedColor(0xed6f21)
          .shape(CheckBoxShape.CIRCLE)
          .onChange((value: boolean) => {
            this.bookList[index].status=value
          })
          .transition(
            TransitionEffect.asymmetric(
              TransitionEffect.OPACITY.animation({ duration: 500 }).combine(
                TransitionEffect.translate({ x: 100 }).animation({ duration: 500 }))
              ,
              TransitionEffect.OPACITY.animation({ delay: 500, duration: 1000 }).combine(
                TransitionEffect.translate({ x: 100 }).animation({ duration: 500 }))
            )
          )
      }else{
        Text(this.dateTimeToString(dateTime))
          .fontSize(12)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor("rgba(0, 0, 0, 0.45)")
          .transition(
            TransitionEffect.asymmetric(
              TransitionEffect.OPACITY.animation({ duration: 500 }).combine(
                TransitionEffect.translate({ x: 0 }).animation({ duration: 0 }))
              ,
              TransitionEffect.OPACITY.animation({ delay: 500, duration: 1000 }).combine(
                TransitionEffect.translate({ x: 100 }).animation({ duration: 500 }))
            )
          )
      }
      Row(){
        this.text("读到",Color.Black)
        Text(schedule.toString()).fontSize(24).lineHeight(24).fontWeight(600)
        this.text("%",Color.Black)
      }
    }.alignItems(HorizontalAlign.End)
    .justifyContent(FlexAlign.SpaceBetween)
    .width("25%")
    .padding(0)
    .height(80)
  }
  build() {
     Column(){
       this.readHeader(this.dateValue)
       Scroll(){
         Column(){
           ForEach(this.bookList,(book:readBookList,index:number)=>{
             Row(){
               Row(){
                 Row(){
                   //封面
                   Image(book.coverImage)
                     .size({width:60,height:80})
                   //书名作者及阅读时长
                   this.bookAuthor(book)
                   //时间和进度
                   this.bookTime(book.status,book.dateTime,book.schedule,index)
                 }.padding(16).width("100%")
                 Row(){
                   Text("删除").fontColor(PublicConstants.THEME_COLOR_WHITE)
                 }.width(70).height(110).backgroundColor(Color.Red)
                 .justifyContent(FlexAlign.Center)
               }.justifyContent(FlexAlign.End)
               .translate({x:this.bookIndex==index?this.translateX:0})
               .animation({
                 duration: 500,
                 curve: Curve.FastOutSlowIn
               })
               .onTouch((e) => {
                 this.ouTouch(e)
               })
               .gesture(
                 SwipeGesture({ direction: SwipeDirection.All })
                   .onAction(() => {
                     if(!this.delStatus){
                       console.log(index+"")
                       this.bookIndex=index
                       let direction =this.directionIf()
                       if(direction==="Left"){
                         this.translateX=-70
                       }else{
                         this.translateX=0
                       }
                     }
                   })
               )
             }.width(CommonConstants.FULL_WIDTH)
             .backgroundColor(PublicConstants.THEME_COLOR_WHITE)
             .borderRadius(12)
             .margin({bottom:16})
             .clip(true)
           })
         }
       }.scrollable(ScrollDirection.Vertical)
       .scrollBar(BarState.Off) // 滚动条常驻显示
       .friction(0.6)
       .edgeEffect(EdgeEffect.None)
       .size({width:320,height:"80%"})
       .padding({bottom:50})
       .align(Alignment.TopStart)
     }
  }

  ouTouch(e:TouchEvent){
    if (e.type === TouchType.Down && e.touches.length > 0) { // 触摸开始，记录初始位置
      this.screenStartX = e.touches[0].screenX;
      this.screenStartY = e.touches[0].screenY;
    } else if (e.type === TouchType.Up && e.changedTouches.length > 0) { // 当手指抬起时，更新最后的位置
      this.lastScreenX = e.changedTouches[0].screenX;
      this.lastScreenY = e.changedTouches[0].screenY;
    }
  }


  directionIf():string{
    const swipeX = this.lastScreenX - this.screenStartX;
    const swipeY = this.lastScreenY - this.screenStartY;
    // 判断滑动方向
    let directionText = '';
    if (Math.abs(swipeX) > Math.abs(swipeY)) {
      if (swipeX > 0) {
        directionText = 'Right'; // 向右滑动
      } else {
        directionText = 'Left'; // 向左滑动
      }
    }
    return directionText
  }
  dateTimeToString(date:Date){
    let year=date.getFullYear()
    let month=date.getMonth()+1
    let day=date.getDate()
    return `${year}/${month}/${day}`
  }


}

