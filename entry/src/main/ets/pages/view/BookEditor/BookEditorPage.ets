import { router, SwipeRefresher } from '@kit.ArkUI'
import { BookEditorType } from './BookEditorType/BookEditorType'
import inputComponent from './InputComponet/inputComponet'

//设置书籍封面图片样式
@Extend(Image) function BookIconSize(){
  .width(90)
  .height(120)
  .borderRadius(5)
}

@Entry
@Component
struct BookEditorPage {

  BookIcon:Resource = $r('app.media.cover_list')
  BookName:string = '大奉打更人'
  Author:string = '卖报小郎君'
  BookIconUrl:string = 'https://www.qidian.com/book/1031940621'
  BookSynopsis:string = "《大奉打更人》（第一卷）实体书已在天猫、当当、京东等全平台，以及各个实体书店发售。这个世界，有儒；有道；有佛；有妖；有术士。\n" +
    "警校毕业的许七安幽幽醒来，发现自己身处牢狱之中，三日后流放边陲.....他起初的目的只是自保，顺便在这个没有人权的社会里当个富家翁悠闲度日。\n" +
    "多年后，许七安回首前尘，身后是早已逝去的敌人，以及累累白骨。\n" +
    "滚滚长江东逝水，浪花淘尽英雄，是非成败转头空。青山依旧在，几度夕阳红。"



  private BookEditor:BookEditorType = new BookEditorType(
    this.BookName,
    this.Author,
    this.BookIcon,
    this.BookIconUrl,
    this.BookSynopsis
  );


  //标题文本颜色
  TitleTextColor:Color = Color.Grey
  //正文文本颜色
  TextColor:string = "#e0000000"
  //更换书籍封面图按钮颜色
  ButtonColor:string = '#0f000000'
  //编辑书籍确认、取消按钮颜色
  BtnConfirmColor:string = '#F60'
  BtnCancelColor:string = '#1fff6600'

  //电池显示组件
  @Builder BufComponent () {
    Column(){
      Text('')
        .fontSize(16)
    }
    .height(40)
  }

  //顶部导航栏组件
  @Builder TopComponent() {
    Flex({justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center})
    {
      Image($r('app.media.return_left'))
        .width(20)
        .height(20)
        .onClick(()=>{
          router.back()
        })
      Text('书籍信息编辑')
        .margin({left: 12})
        .fontColor(this.TextColor)
    }
    .padding({left: 20, right: 20, top: 12, bottom: 12})
    .height(48)
  }

  //保存或重置书籍编辑内容组件
  @Builder SelectComponent() {
    Flex({justifyContent: FlexAlign.SpaceBetween}){
      Button(){
        Text('重置')
          .fontSize(16)
          .fontColor(this.BtnConfirmColor)
      }
      .backgroundColor(this.BtnCancelColor)
      .width(152)
      .height(38)
      .onClick(()=>{

      })
      Button(){
        Text('保存')
          .fontSize(16)
          .fontColor(Color.White)
      }
      .borderRadius(7)
      .backgroundColor(this.BtnConfirmColor)
      .width(152)
      .height(38)
      .onClick(()=>{

      })
    }
    .height(64)
    .padding({left: 20, right: 20, top: 12, bottom: 12})
  }

  @State BookIconArr2:BookEditorType [] = [
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
    new BookEditorType(),
  ]
  @State BookIconArr:Resource [] = [
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
    this.BookIcon,
  ]
  @State selectIcon:boolean = false
  @State BookSource:number = 24
  @State FindBook:string = '已搜索到' + this.BookSource + '个书源,'
  @State FindBookOver:string = '共搜索到' + this.BookSource + '个书源,'
  @State Loading:boolean = true
  //弹窗组件
  @State isWindowShow:boolean = false
  @Builder WindowBuilder() {
    Column(){
      Flex(){
        if (this.Loading){
          SwipeRefresher({ isLoading: true })
            .width(30)
            .height(24)
            .colorBlend(this.BtnConfirmColor)
        }
        // Image($r('app.media.right'))
        //   .objectFit(ImageFit.Contain)
        //   .aspectRatio(1)
        //   .rotate({ x: 0, y: 0, z: 1, angle: this.rotateAngle })
        //   .height(24)
        //   .width(24)
        Flex({justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center})
        {
          Text(this.Loading ? this.FindBook:this.FindBookOver)
            .fontSize(14)
            .fontColor(Color.Grey)
          Text(this.Loading ? '点击暂停':'点击刷新')
            .fontSize(14)
            .fontColor(this.BtnConfirmColor)
            .margin({left:10})
            .onClick(()=>{
            this.Loading ? this.Loading = false: this.Loading = true;
          })
        }
        .height(24)
      }
      .onAppear(()=>{
        // this.startRotate()
        this.Loading = true
      })
      .height(54)
      .padding({top: 16, bottom: 16, left:20, right:20})

      List(){
        ListItem(){
          Flex({wrap:FlexWrap.Wrap}){
            ForEach(this.BookIconArr2, (Item:BookEditorType,Index:number)=>{
              Image(Item.getBookIcon())
                .BookIconSize()
                .borderRadius(10)
                .margin({left:22, bottom:24})
                .borderWidth(Item.getBookSelect() ? 2 : 0)
                .borderColor(Color.Black)
                .onClick(()=>{
                    this.BookIconArr2[Index].setBookSelect(true)
                    this.BookIconArr2.push(new BookEditorType())
                    this.BookIconArr2.pop()
                })

            })
          }.width('100%')
        }
      }.height('100%').width("100%")

    }
    .width('100%')
  }


  // //刷新动画
  // @State rotateAngle:number=0
  // @State timeoutID:number = 1
  // startRotate() {
  //   this.timeoutID = setInterval(() => {
  //     this.rotateAngle = 0
  //     animateTo({ duration: 800 }, () => {
  //       this.rotateAngle = 360
  //     })
  //   }, 800);
  // }
  // clearAnimation(){
  //   clearTimeout(this.timeoutID);
  // }

  build() {
    Column() {
      this.BufComponent()//留给电池显示

      this.TopComponent()
      Flex({direction:FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center})
      {
        Image(this.BookIcon).BookIconSize()
        Flex({direction:FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center})
        {
          Column({space:4})
          {
            Text('书名').fontColor(this.TitleTextColor).fontSize(12)
            Flex({justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center})
            {
              inputComponent({
                TEXT:this.BookEditor.getBookName(),
                Height:32,
                FontSize:12,
                FontColor:this.TextColor
              })
              // Text(this.BookEditor.getBookName()).fontSize(12).fontColor(this.TextColor).margin({left:16})
            }
            .borderRadius(5)
            .backgroundColor('#0a000000')
            .height(32)
          }
          .alignItems(HorizontalAlign.Start)
          .height(58)
          Column({space:4})
          {
            Text('作者').fontColor(this.TitleTextColor).fontSize(12)
            Flex({justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center})
            {
              inputComponent({
                TEXT:this.BookEditor.getBookAuthor(),
                Height:32,
                FontSize:12,
                FontColor:this.TextColor
              })
              // Text(this.BookEditor.getBookAuthor()).fontSize(12).fontColor(this.TextColor).margin({left:16})
            }
            .borderRadius(5)
            .backgroundColor('#0a000000')
            .height(32)
          }
          .alignItems(HorizontalAlign.Start)
          .height(58)
        }
        .width(212)
        .height(120)
      }
      .height(144)
      .padding({left: 20, right: 20, top: 12, bottom: 12})
      Flex({direction:FlexDirection.Column, justifyContent:FlexAlign.SpaceBetween}){
        Text('封面地址').fontSize(12)
        Flex({justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}){
          inputComponent({
            TEXT:this.BookEditor.getBookIconUrl(),
            Height:32,
            FontSize:14,
            FontColor:this.TextColor
          })
        }
        .height(38)
        .borderRadius(5)
        .backgroundColor('#0a000000')
        Flex({justifyContent: FlexAlign.SpaceBetween}){
          Flex({justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}){
            Text('选择本地图片')
              .fontSize(14)
          }
          .borderRadius(7)
          .backgroundColor(this.ButtonColor)
          .width(152)
          .height(38)
          Flex({justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}){
            Text('封面换源')
              .fontSize(14)
          }
          .borderRadius(7)
          .backgroundColor(this.ButtonColor)
          .width(152)
          .height(38)
          .onClick(()=>{
            this.isWindowShow = true
          })
          .bindSheet(this.isWindowShow, this.WindowBuilder(),{
            detents:[688,300,100],
            maskColor: '#99000000',
            backgroundColor:Color.White,
            blurStyle:BlurStyle.Thick,
            showClose:false,
            preferType: SheetType.CENTER,
            shouldDismiss:((sheetDismiss: SheetDismiss)=> {
              console.log("bind sheet shouldDismiss")
              sheetDismiss.dismiss()
              this.isWindowShow = false
            })
          })
        }
      }
      .width('100%')
      .height(140)
      .padding({left: 20, right: 20, top: 12, bottom: 12})
      Flex({direction:FlexDirection.Column}){

        Text('书籍简介')
          .fontSize(12)
          .fontColor(this.TitleTextColor)

        List(){
          ListItem(){
            inputComponent({
              TEXT:this.BookEditor.getBookSynopsis(),
              textAlign:Alignment.TopStart,
              Height:296,
              FontSize:14,
              FontColor:this.TextColor
            })
            // Text(this.BookSynopsis)
            //   .fontSize(14)
            //   .fontColor(this.TextColor)
            //   .lineHeight(22)
            //   .textAlign(TextAlign.JUSTIFY)
            //   .fontWeight(400)
          }
        }
        .width(320)
        .height(296)
        .borderRadius(10)
        .backgroundColor('#0a000000')
        .margin({top:4})

      }
      .height(344)
      .padding({left: 20, right: 20, top: 12, bottom: 12})

      this.SelectComponent()
    }
    .onAppear(()=>{
      this.BookIconArr2.forEach((item:BookEditorType) => {
        item.setBookIcon(this.BookIcon)
        item.setBookSelect(false)
      });
    })
    .direction(Direction.Rtl)
    .width('100%')
  }

}

