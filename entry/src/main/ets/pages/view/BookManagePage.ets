import router from '@ohos.router';
import bookListManage from '../../componets/bookManage/bookListManage';
import { BookList } from '../../componets/dataList/bookList';
import {showMessage} from '../../componets/common/promptShow'
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
  @State currentIndex: number = 0
    // (router.getParams() as routerParams).currentIndex
  @State EXHIBIT: string = '列表'
    // (router.getParams() as routerParams).EXHIBIT
  @State isClear:boolean = false
  @State allCheck:boolean = false
  @State @Watch('changeCheckNumber')checkNumber:number = 0
  @State showBookList:BookList[] = []
  @State changeTop:boolean = false

  changeCheckNumber(){
    if (this.checkNumber !== 0 && this.checkNumber === this.showBookList.length) {
        this.allCheck = true
    }
  }

  @State bookList:BookList[] = [
    new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('2','仙人消失之后','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('3','仙人消失之后','会说话的肘子·未读过3','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('4','仙人消失之后','会说话的肘子·未读过4','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('5','仙人消失之后','会说话的肘子·未读过5','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('6','仙人消失之后','会说话的肘子·未读过6','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('7','仙人消失之后','会说话的肘子·未读过7','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('8','仙人消失之后','会说话的肘子·未读过8','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('9','仙人消失之后','会说话的肘子·未读过9','更新至·第340章 镇压',$r('app.media.cover_list'))
    ,new BookList('10','仙人消失之后','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list'))
  ]

  @State cartoonList:BookList[] = [
    new BookList('1','极主夫道','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('2','极主夫道','会说话的肘子·未读过2','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('3','极主夫道','会说话的肘子·未读过3','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('4','极主夫道','会说话的肘子·未读过4','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('5','极主夫道','会说话的肘子·未读过5','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('6','极主夫道','会说话的肘子·未读过6','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('7','极主夫道','会说话的肘子·未读过7','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('8','极主夫道','会说话的肘子·未读过8','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('9','极主夫道','会说话的肘子·未读过9','更新至·第340章 镇压',$r('app.media.cover_list1'))
    ,new BookList('10','极主夫道','会说话的肘子·未读过10','更新至·第340章 镇压',$r('app.media.cover_list1'))
  ]

  @State soundList:BookList[] = [
    new BookList('1','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('2','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('3','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('4','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('5','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('6','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('7','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('8','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('9','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('10','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('11','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2')),
    new BookList('12','三体广播据','729声工厂 · 第一季 第五集 红岸基地','共101集 · 最终季 最终集 回归大宇宙',$r('app.media.cover_list2'))
  ]

  onCurrentIndexChange(){
    if (this.currentIndex === 0) {
      this.showBookList = this.bookList
    } else if(this.currentIndex === 1){
      this.showBookList = this.cartoonList
    } else if(this.currentIndex === 2){
      this.showBookList = this.soundList
    }
    this.showBookSort()
  }
  //showBookList根据isTop字段排序true最上面
  showBookSort() {
    this.showBookList.sort((a, b) => {
      if (a.isTop && !b.isTop) {
        return -1
      } else if (!a.isTop && b.isTop) {
        return 1
      } else {
        return b.topUpdateTime.getTime() - a.topUpdateTime.getTime()
      }
    })
  }

  onPageShow(): void {
    this.onCurrentIndexChange()
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
      Flex({
        justifyContent:FlexAlign.Center
      }){
        Scroll(){
          bookListManage({
            isClear:this.isClear,
            EXHIBIT:this.EXHIBIT,
            allCheck:this.allCheck,
            showBookList:this.showBookList,
            checkNumber:this.checkNumber,
            changeTop:this.changeTop
          })
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
        Text(!this.allCheck?'全选':'取消选择').fontSize(16).onClick(()=>{
          this.allCheck = !this.allCheck
        })
      }
      .alignItems(HorizontalAlign.Start)
      .width('33%')
      Column(){
        Text(`已选${this.checkNumber}项目`).fontSize(20).fontWeight(600)
      }.width('33%')
      Column(){
        Text('完成').fontSize(16)
      }.onClick(()=>{
        this.allCheck = false
      })
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
      .onClick(()=>{
        if (this.checkNumber === 0) {
          showMessage('请选择要置顶的内容')
          return
        }
        this.changeTop = true
      })
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
        this.isClear = true
      })
    }
    .height('10%')
    .padding(20)
  }
}