import router from '@ohos.router';
import bookListManage from './bookManage/bookListManage';
import { BookList } from '../../../../componets/dataList/bookList';
import {showMessage} from '../../../../componets/common/promptShow'
import CommonConstants from '../../../../common/constants/CommonConstants';
import addBookTypeDialog from '../../../../componets/common/addBookTypeDialog';
import confirmDialogExample from '../../../../componets/common/confirmDialog';
import { initBookListData, updateBookListData } from '../../../../storage/bookListData';
import { folderList } from '../../../../componets/dataList/folderList';
import BookFolderManages from './bookManage/BookFolderManages';

class routerParams {
  currentIndex:number
  EXHIBIT:string
  GROUPName:string
  constructor(currentIndex:number,EXHIBIT:string,GROUPName:string) {
    this.currentIndex = currentIndex
    this.EXHIBIT = EXHIBIT
    this.GROUPName = GROUPName
  }
}
/**
 * 管理跳转页面
 */
@Entry
@Component
struct BookManagePage {
  // @State currentIndex: number = 0
  // @State EXHIBIT: string = '列表'
  // @State GROUPName:string = '标签' //标签
  @State GROUPName:string = (router.getParams() as routerParams).GROUPName
  @State currentIndex: number = (router.getParams() as routerParams).currentIndex
  @State EXHIBIT: string = (router.getParams() as routerParams).EXHIBIT
  @State isClear:boolean = false
  @State allCheck:boolean = false
  @State @Watch('changeCheckNumber')checkNumber:number = 0
  @State showBookList:BookList[] = []
  @State changeTop:boolean = false
  @State isShow:boolean = false

  @State isAddShelfShow:boolean = false



  @State bookType:string = ''

  @State BooTypeList:string[] = ['玄幻','修真', '都市', '穿越', '网游', '科幻', '历史']

  @State ShelfList:string[] = ['玄幻神作', '精品小说,亲自品鉴', '冷门小说不容错过']

  @State clickBookType:string = ''

  @State @Watch('changeCheckBookList')checkBookList:BookList[] = []

  @State topTitle:string = '置顶'

  changeCheckBookList(){
    if (this.checkBookList.length !== 0) {
      this.checkBookList.every(book => book.isTop)?this.topTitle = '取消置顶':this.topTitle = '置顶'
    } else if (this.folderCheckList.length !== 0) {
      this.folderCheckList.every(folder => folder.isTop)?this.topTitle = '取消置顶':this.topTitle = '置顶'
    } else {
      this.topTitle = '置顶'
    }
  }

  changeCheckNumber(){
    if (this.checkNumber !== 0 && this.checkNumber === this.showBookList.length) {
        this.allCheck = true
    }
  }

  addBookType: CustomDialogController | null = new CustomDialogController({
    builder: addBookTypeDialog({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      bookType: this.bookType
    }),
    cancel: this.exitDialog,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    // offset: { dx: 0, dy: '-40%' },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25
  })
  //退出弹框
  exitDialog(){
    this.bookType = ''
  }
  //取消
  onCancel(){
    this.bookType = ''
  }
  //确定
  onAccept(){
    console.log(this.bookType)
    //对比bookType看是否BooTypeList数组中存在
    if (this.BooTypeList.includes(this.bookType)) {
      showMessage(`已存${this.bookType}分组`)
      this.bookType= ''
      return
    } else{
      this.BooTypeList.push(this.bookType)
      this.bookType= ''
      showMessage(`已添加${this.bookType}分组`)
    }
  }

  @StorageProp(CommonConstants.KEY_NOVEL_BOOK_DATA)
  bookList:BookList[] = []
  @StorageProp(CommonConstants.KEY_CARTOON_BOOK_DATA)
  cartoonList:BookList[] = []
  @StorageProp(CommonConstants.KEY_SOUND_BOOK_DATA)
  soundList:BookList[] = []


  @State novelPageList:folderList[] = [
    new folderList(1,'玄幻',12,$r('app.media.folder_test'),'玄幻','宿命之环等3本有更新'),
    new folderList(2,'都市',13,$r('app.media.folder_test'),'都市'),
    new folderList(3,'仙侠',12,$r('app.media.folder_test'),'仙侠'),
    new folderList(4,'武侠',12,$r('app.media.folder_test'),'武侠'),
    new folderList(5,'奇幻',12,$r('app.media.folder_test'),'奇幻'),
    new folderList(6,'科幻',12,$r('app.media.folder_test'),'科幻'),
    new folderList(7,'历史',12,$r('app.media.folder_test'),'历史'),
    new folderList(8,'游戏',12,$r('app.media.folder_test'),'游戏'),
    new folderList(9,'悬疑',12,$r('app.media.folder_test'),'悬疑')
  ]

  onCurrentIndexChange(){
    if (this.currentIndex === 0 && this.GROUPName !== '文件夹') {
      this.showBookList = this.bookList
    } else if(this.currentIndex === 1 && this.GROUPName !== '文件夹'){
      this.showBookList = this.cartoonList
    } else if(this.currentIndex === 2 && this.GROUPName !== '文件夹'){
      this.showBookList = this.soundList
    } else {
      this.showBookList = []
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
    initBookListData()
    this.onCurrentIndexChange()
  }
  // @State folderCheckNumber:number = 0
  @State @Watch('folderCheckNumber')folderCheckList:folderList[] = []
  folderCheckNumber(){
    this.checkNumber = this.folderCheckList.length
    this.changeCheckBookList()
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
          if (this.GROUPName === '文件夹'){
            BookFolderManages({
              isClear:this.isClear,
              allCheck:this.allCheck,
              folderList:this.novelPageList,
              folderCheckList:this.folderCheckList,
              changeTop:this.changeTop,
              EXHIBIT:this.EXHIBIT
            })
          } else {
            bookListManage({
              isClear:this.isClear,
              EXHIBIT:this.EXHIBIT,
              allCheck:this.allCheck,
              showBookList:this.showBookList,
              checkNumber:this.checkNumber,
              changeTop:this.changeTop,
              checkBookList:this.checkBookList,
              shelfType:this.currentIndex
            })
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
        Text(this.topTitle).fontSize(14).fontWeight(500)
      }
      .onClick(()=>{
        if (this.checkNumber === 0) {
          showMessage(`请选择要${this.topTitle}的内容`)
          return
        }
        if(this.topTitle === '置顶'){
          console.log('置顶')
          if (this.GROUPName === '文件夹') {
            this.isTopChange()
          } else {
            this.changeTop = true
          }
        } else {
          this.cancelShowTop()
        }
      })
      Column({
        space:5
      }){
        Image($r('app.media.move')).width(21)
        Text('移动至').fontSize(14).fontWeight(500)
      }.onClick(()=>{
        this.isShow = true
      })
      .bindSheet($$this.isShow,this.catalogMove(), {
        height:300,
        showClose: false,
        dragBar: false,
        blurStyle:BlurStyle.COMPONENT_ULTRA_THIN,
        maskColor: 'rgba(0,0,0,0.6)',
        onDisappear:()=>{
          this.clickBookType = ''
          console.log('隐藏')
        }
      })
      Column({
        space:5
      }){
        Image($r('app.media.add_shelf_book')).width(17)
        Text('加入书单').fontSize(14).fontWeight(500)
      }
      .onClick(()=>{
        this.isAddShelfShow = true
      })
      .bindSheet($$this.isAddShelfShow,this.catalogAddShelf(), {
        height:300,
        showClose: false,
        dragBar: false,
        blurStyle:BlurStyle.COMPONENT_ULTRA_THIN,
        maskColor: 'rgba(0,0,0,0.6)',
        onDisappear:()=>{
          this.clickBookType = ''
          console.log('隐藏')
        }
      })
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

  cancelShowTop(){
    //循环遍历checkBookList当bookId和showBookList中的bookId相同时，将showBookList isTop改为false
    if (this.GROUPName === '文件夹') {
      for (let i = 0; i < this.folderCheckList.length; i++) {
        for (let j = 0; j < this.novelPageList.length; j++) {
          if (this.folderCheckList[i].id === this.novelPageList[j].id) {
            this.novelPageList[j].isTop = false
            break
          }
        }
      }
      this.showFolderSort()
      this.folderCheckList = []
    } else {
      for (let i = 0; i < this.checkBookList.length; i++) {
        for (let j = 0; j < this.showBookList.length; j++) {
          if (this.checkBookList[i].bookId === this.showBookList[j].bookId) {
            this.showBookList[j].isTop = false
            break
          }
        }
      }
      this.checkBookList = []
      updateBookListData(this.currentIndex,this.showBookList)
    }
    this.changeTop = true
    showMessage('取消置顶成功')
  }



  @Builder catalogMove() {
    Column() {
      Column(){
        Text('移动分组').fontSize(16).fontWeight(700).lineHeight(24)

      }.padding({right:20,left:20,top:12,bottom:12})

      Divider().strokeWidth(0.5)
      Scroll(){
        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center,
          justifyContent:FlexAlign.Start
        }){
          this.title('')
          ForEach(this.BooTypeList,(item:string)=>{
            this.title(item)
          })
        }
        .padding(20)
      }
      .height('65%')
      .scrollBar(BarState.Off)
      Divider().strokeWidth(0.5)
      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(()=>{
        this.isShow = false
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 32,
        right:32,
        top: 16
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder catalogAddShelf() {
    Column() {
      Column(){
        Text('加入书单').fontSize(16).fontWeight(700).lineHeight(24)
      }.padding({right:20,left:20,top:12,bottom:12})
      Divider().strokeWidth(0.5)
      Flex(){
        this.ColumnTitle('')
      }
      Scroll(){
        Column(){
          ForEach(this.ShelfList,(item:string)=>{
            this.ColumnTitle(item)
          })
        }
      }
      .align(Alignment.Start)
      .height('45%')
      .scrollBar(BarState.Off)
      Divider().strokeWidth(1)
      Row({
        space:20
      }) {
        Column(){
          Text('取消').fontSize(16).fontWeight(400).fontColor($r('app.color.theme_color'))
            .lineHeight(24)
            .padding({left:32,right:32,bottom:12,top:12})
        }
        .width('50%')
        .borderRadius(20)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('rgba(255, 102, 0, 0.12)')
        Column(){
          Text('确定').fontSize(16).fontWeight(400).fontColor(Color.White)
            .lineHeight(24)
            .padding({left:32,right:32,bottom:12,top:12})
        }
        .width('50%')
        .borderRadius(20)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor($r('app.color.theme_color'))
      }
      .onClick(()=>{
        this.isAddShelfShow = false
      })
      .padding({
        left: 32,
        right:32,
        top: 16
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder ColumnTitle(title:string) {
    Column() {
      if (title === ''){


        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems:ItemAlign.Center
        }){
          Row({
            space:12
          }){
            Image($r('app.media.add')).width(24).fillColor($r('app.color.theme_color'))
            Text('新建书单').fontSize(14).fontColor($r('app.color.theme_color')).fontWeight(400).lineHeight(22)
          }
        }
      } else {
       Flex({
         justifyContent:FlexAlign.SpaceBetween,
         alignItems:ItemAlign.Center
       }){
         Row({
           space:12
         }){
           Image($r('app.media.shelf')).width(24)
           Text(title).fontSize(14).fontWeight(400).lineHeight(22).textOverflow({
             overflow:TextOverflow.Ellipsis
           }).ellipsisMode(EllipsisMode.END).maxLines(1)
         }

         if (false) {
           Image($r('app.media.ic_public_return_right')).width(24).height(24)
         } else {
           Text('已在书单').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
         }
       }
      }
    }
    .onClick(()=>{

    })
    .padding({
      left:20,
      right:20,
      top:12,
      bottom:12
    })
  }

  @Builder title(title:string) {
    Column() {
      if (title === ''){
        Image($r('app.media.add')).width(24)
      } else {
        Text(title).fontSize(14).textOverflow({
          overflow:TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END).maxLines(1)
      }
    }
    .onClick(()=>{
      if(title === ''){
        this.addBookType?.open()
        return
      }
      if (this.checkNumber === 0) {
        showMessage('请选择要移动的内容')
        return
      }
      this.clickBookType = title
      this.clickBookTypeDialog?.open()
    })
    .margin({ left: 16, bottom: 16 })
    .width(85).height(36)
    .backgroundColor('rgba(0, 0, 0,0.06)')
    .padding({
      left:16,
      right:16,
      top:8,
      bottom:8
    })
  }

  //是否确认移动分组
  clickBookTypeDialog: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: ()=> { this.clickBookCancel() },
      confirm: ()=> { this.clickBookAccept() },
      title:`移动到${this.clickBookType}`
    }),
    cancel: this.clickExitDialog,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  clickBookCancel() {
    this.clickBookType = ''
  }

  clickBookAccept() {
    this.mobileBookType()
  }

  clickExitDialog() {
    this.clickBookType = ''
  }

  mobileBookType(){
    //循环遍历checkBookList当bookId和showBookList中的bookId相同时，将showBookList bookType改为clickBookType
    for (let i = 0; i < this.checkBookList.length; i++) {
      for (let j = 0; j < this.showBookList.length; j++) {
        if (this.checkBookList[i].bookId === this.showBookList[j].bookId) {
          this.showBookList[j].bookType = this.clickBookType
          break
        }
      }
    }
    updateBookListData(this.currentIndex,this.showBookList)
    this.clickBookType = ''
    this.checkBookList = []
    this.isShow = false
    this.changeTop = true
    showMessage('移动成功')
  }

  isTopChange(){
    console.log('置顶操作中')
    if (this.folderCheckList.length === this.novelPageList.length) {
      this.folderCheckList.reverse()
      this.novelPageList = this.folderCheckList
      for (let index = 0; index < this.folderCheckList.length; index++) {
        this.novelPageList[index].isTop = true
      }
    } else {
      for (let index = 0; index < this.folderCheckList.length; index++) {
        for (let j = 0; j < this.novelPageList.length; j++) {
          if (this.folderCheckList[index].id === this.novelPageList[j].id) {
            this.novelPageList[j].topUpdateTime = new Date()
            this.novelPageList[j].isTop = true
            break
          }
        }
      }
    }
    showMessage('置顶成功')
    this.changeTop = false
    this.allCheck = false
    //更新缓存
    // updateBookListData(this.currentIndex,this.showBookList)
    // this.checkBookList = []
    this.folderCheckList = []
    this.showFolderSort()
  }

  showFolderSort() {
    this.novelPageList.sort((a, b) => {
      if (a.isTop && !b.isTop) {
        return -1
      } else if (!a.isTop && b.isTop) {
        return 1
      } else {
        return b.topUpdateTime.getTime() - a.topUpdateTime.getTime()
      }
    })
  }
}