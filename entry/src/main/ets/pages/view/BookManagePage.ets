import router from '@ohos.router';
import cartoonPage from './bookShelf/cartoonPage';
import novelPage from './bookShelf/novelPage';
import soundPage from './bookShelf/soundPage';
class routerParams {
  currentIndex:number
  EXHIBIT:string
  constructor(currentIndex:number,EXHIBIT:string) {
    this.currentIndex = currentIndex
    this.EXHIBIT = EXHIBIT
  }
}
/**
 * 管理跳转页面
 */
@Entry
@Component
struct BookManagePage {
  @State currentIndex: number = (router.getParams() as routerParams).currentIndex
  @State EXHIBIT: string = (router.getParams() as routerParams).EXHIBIT

  @State isClear:boolean = false
  @State isManage:boolean = true

  @State allCheck:boolean = false

  @State manageDelete:boolean = false

  onPageShow(): void {
    console.log(this.currentIndex + '')
    console.log(this.EXHIBIT + '')
  }
  build() {
    Column() {
      Blank(20)
      Row({ space: 15 }) {
        Image($r('app.media.return_left'))
          .width(25)
          .height(25)
          .onClick(()=>{
            router.back()
          })
      }
      .margin({left:5})
      .width("100%")

      this.headTitle()
      Flex(){
        Scroll(){
          if (this.currentIndex === 0){
            novelPage({
              searchValue:'最近阅读',
              currentIndex:0,
              isClear:this.isClear,
              EXHIBIT:this.EXHIBIT,
              isShowCheck:true,
              allCheck:this.allCheck
              // manageDelete:this.manageDelete
            })
          } else if(this.currentIndex === 1) {
            cartoonPage({searchValue:'最近阅读',
              currentIndex:1,
              isClear:this.isClear,
              EXHIBIT:this.EXHIBIT,
              isShowCheck:true})
          } else if(this.currentIndex === 2) {
            soundPage({searchValue:'最近阅读',
              currentIndex:2,
              isClear:this.isClear,
              EXHIBIT:this.EXHIBIT,
              isShowCheck:true})
          }
        }
        .height('80%')
        .align(Alignment.TopStart)
        .scrollBar(BarState.Off)
      }
      this.footerTitle()
    }
    .padding(10)
    .backgroundColor("rgb(245, 245, 245)")
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [["rgb(254, 203, 169)", 0.0], ["RGB(245, 245, 245)", 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
  }

  @Builder headTitle(){
    Flex(
      {

        alignItems:ItemAlign.Center
      }
    ){
      Column(){
        Text(!this.allCheck?'全选':'取消全选').fontSize(16).onClick(()=>{
          this.allCheck = !this.allCheck
        })
      }
      .alignItems(HorizontalAlign.Start)
      .width('33%')
      Column(){
        Text(`已选1项目`).fontSize(20).fontWeight(600)
      }.width('33%')
      Column(){
        Text('完成').fontSize(16)
      }
      .alignItems(HorizontalAlign.End)
      .width('33%')
    }
    .padding(10)
  }

  @Builder footerTitle(){
    Flex(
      {
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }
    ){
      Column({
        space:5
      }){
        Image($r('app.media.pip_to_top')).width(14)
        Text('置顶').fontSize(14).fontWeight(500)
      }
      Column({
        space:5
      }){
        Image($r('app.media.move')).width(21)
        Text('移动至').fontSize(14).fontWeight(500)
      }
      Column({
        space:5
      }){
        Image($r('app.media.add_shelf_book')).width(17)
        Text('加入书单').fontSize(14).fontWeight(500)
      }
      Column({
        space:5
      }){
        Image($r('app.media.delete_svg')).width(20)
        Text('删除').fontSize(14).fontWeight(500)
      }.onClick(()=>{
        this.manageDelete = true
      })
    }
    .height('10%')
    .padding(20)
  }
}