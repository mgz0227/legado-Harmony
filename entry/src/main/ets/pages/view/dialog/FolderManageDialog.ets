import CommonConstants from '../../../common/constants/CommonConstants'
import addBookTypeDialog from '../../../componets/common/addBookTypeDialog'
import commonInputDialog from '../../../componets/common/commonInputDialog'
import hideDialogExample from '../../../componets/common/hideDialog'
import { showMessage } from '../../../componets/common/promptShow'
import { BookList } from '../../../componets/dataList/bookList'
import { folderList } from '../../../componets/dataList/folderList'
import IndexSearchType from '../../../componets/head/IndexSearchType'
import { updateBookListData } from '../../../storage/bookListData'
import bookListManage from '../bookShelf/Manage/bookManage/bookListManage'
import newAddShelf from '../bookShelf/Manage/bookManage/newAddShelf'
import newBookShelf from '../bookShelf/Manage/bookManage/newBookShelf'

/**
 * 分组单击跳转页面
 */
@Component
export default struct FolderManageDialog {
  @Link folderType:string
  EXHIBIT_NAMES: string[] = ['列表', '宫格']
  @State EXHIBIT: string = '列表'
  @State isClear:boolean = false
  @State allCheck:boolean = false
  @State @Watch('changeCheckNumber')checkNumber:number = 0
  @State changeTop:boolean = false
  @State isShow:boolean = false

  @State isAddShelfShow:boolean = false

  @State bookType:string = ''

  @State BooTypeList:string[] = ['玄幻','修真', '都市', '穿越', '网游', '科幻', '历史']

  @State ShelfList:string[] = ['玄幻神作', '精品小说,亲自品鉴', '冷门小说不容错过','冷门小说不容错过']

  @State clickBookType:string = ''

  @State topTitle:string = '置顶'

  @State @Watch('changeCheckBookList')checkBookList:BookList[] = []

  @StorageProp(CommonConstants.KEY_NOVEL_BOOK_DATA)
  bookList:BookList[] = []

  changeCheckBookList(){
    if (this.checkBookList.length !== 0) {
      this.checkBookList.every(book => book.isTop)?this.topTitle = '取消置顶':this.topTitle = '置顶'
    } else {
      this.topTitle = '置顶'
    }
  }

  changeCheckNumber(){
    if (this.checkNumber !== 0 && this.checkNumber === this.bookList.length) {
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

  @StorageLink('GROUP_LIST_DATA') groupData:folderList[] = []
  //showBookList根据isTop字段排序true最上面
  // showBookSort() {
  //   this.bookList.sort((a, b) => {
  //     if (a.isTop && !b.isTop) {
  //       return -1
  //     } else if (!a.isTop && b.isTop) {
  //       return 1
  //     } else {
  //       // return 0
  //       return b.topUpdateTime.getTime() - a.topUpdateTime.getTime()
  //     }
  //   })
  // }

  @State @Watch('folderCheckNumber')folderCheckList:folderList[] = []
  folderCheckNumber(){
    this.checkNumber = this.folderCheckList.length
    this.changeCheckBookList()
  }
  @State showNumber:number = 0
  @State addCheckShelf:BookList[] = [
    new BookList('1','开局长生万古，苟到天荒地老','这个世界，有儒;有道；有佛书;有妖;有术士。警校毕业的许七安幽幽醒来，发现自己将要远赴','更新至·第340章 镇压',$r('app.media.shelf_book'),'玄幻')]
  build() {
    Column(){
      if (this.showNumber === 0){
        this.bookManage()
      } else if(this.showNumber === 1){
        newBookShelf({
          addCheckShelf:this.addCheckShelf,
          showNumber:this.showNumber,
          isAddShelfShow:this.isAddShelfShow,
          topIsShow:false
        })
      } else if (this.showNumber === 2){
        newAddShelf({
          addCheckShelf:this.addCheckShelf,
          showNumber:this.showNumber,
          isAddShelfShow:this.isAddShelfShow,
          topIsShow:false
        })
      }
    }.height('100%')
  }
  @Builder bookManage(){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }) {
      if (!this.isManage){
        this.headTitleManage()
      } else {
        this.headTitle()
      }
      Scroll(){
        bookListManage({
          isClear:this.isClear,
          EXHIBIT:this.EXHIBIT,
          allCheck:this.allCheck,
          showBookList:this.bookList,
          checkNumber:this.checkNumber,
          changeTop:this.changeTop,
          checkBookList:this.checkBookList,
          shelfType:0,
          isManage:this.isManage
        })
      }
      .height(!this.isManage?'95%':'85%')
      .align(Alignment.TopStart)
      .scrollBar(BarState.Off)
      if (this.isManage){
        this.footerTitle()
      }
    }.height('100%').width('100%')
  }

  @Builder headTitle(){
    Flex(
      {
        alignItems:ItemAlign.Center
      }
    ){
      Column(){
        Text(this.checkNumber>0 && this.checkNumber === this.bookList.length?'取消选择':'全选').fontSize(16).onClick(()=>{
          this.allCheck = !this.allCheck
        })
      }
      .alignItems(HorizontalAlign.Start)
      .width('33%')
      Column(){
        Text(`已选${this.checkNumber}项目`).fontSize(16).fontWeight(500).fontColor($r('app.string.color_black_88'))
      }.width('33%')
      Column(){
        Text('完成').fontSize(16)
      }.onClick(()=>{
        this.allCheck = false
        this.isManage = !this.isManage
      })
      .alignItems(HorizontalAlign.End)
      .width('33%')
    }
    // .height('5%')
    .padding(10)
  }
  @State titleManage:string = '最近阅读'
  @State searchValue: string = '最近阅读'
  @State isManage:boolean = false

  @Builder headTitleManage(){
    Flex(
      {
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.Center
      }
    ){
      Column(){
        IndexSearchType({ title: this.titleManage, searchValue: this.searchValue })
      }
      .alignItems(HorizontalAlign.Start)
      .width('33%')
      Column(){
        Text(`${this.folderType}`)
          .textAlign(TextAlign.Center)
          .fontSize(16).fontWeight(500).fontColor($r('app.string.color_black_88'))
      }
      .width('33%')
      .onClick(()=>{
        this.restTitleDialog?.open()
      })
      Row(
        {
          space:12
        }
      ){
        Text(this.EXHIBIT === '列表'?'宫格':'列表')
          .textAlign(TextAlign.Center)
          .fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
          .onClick(()=>{
            if (this.EXHIBIT === '列表') {
              this.EXHIBIT = '宫格'
            } else {
              this.EXHIBIT = '列表'
            }
          })
        Divider()
          .vertical(true)
          .height(15)
          .color('#989797')
          .opacity(0.3)
          .strokeWidth(1)
        Text('管理')
          .textAlign(TextAlign.Center)
          .fontSize(14).fontWeight(400).fontColor($r('app.string.color_black_88'))
          .onClick(()=>{
            this.isManage = !this.isManage
          })
      }
      .justifyContent(FlexAlign.End)
      .width('33%')
    }
    // .height('5%')
    .padding(10)
  }


  @Builder footerTitle(){
    Flex(
      {
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }){
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
          this.changeTop = true
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
       height:330,
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
        height:330,
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
    .padding(12)
    // .height('10%')
  }
  showFolderType(){
    console.log(JSON.stringify(this.folderCheckList))
    for (let i = 0; i < this.folderCheckList.length; i++) {
      for (let j = 0; j < this.groupData.length; j++) {
        if (this.folderCheckList[i].id === this.groupData[j].id) {
          this.groupData[j].isShow = true
          console.log(JSON.stringify(this.groupData[j]))
          break
        }
      }
    }
    this.allCheck = false
    this.folderCheckList = []
    this.showFolderSort()
    showMessage('隐藏成功')
  }

  //是否确认移动分组
  clickBookTypeDialog: CustomDialogController | null = new CustomDialogController({
    builder: hideDialogExample({
      cancel: ()=> { this.clickBookCancel() },
      confirm: ()=> { this.clickBookAccept() }
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

  }

  clickExitDialog() {
    this.clickBookType = ''
  }

  cancelShowTop(){
    //循环遍历checkBookList当bookId和showBookList中的bookId相同时，将showBookList isTop改为false
    for (let i = 0; i < this.checkBookList.length; i++) {
      for (let j = 0; j < this.bookList.length; j++) {
        if (this.checkBookList[i].bookId === this.bookList[j].bookId) {
          this.bookList[j].isTop = false
          break
        }
      }
    }
    this.checkBookList = []
    updateBookListData(0,this.bookList)
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
      .height('45%')
      .scrollBar(BarState.Off)
      Divider().strokeWidth(0.5)
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
          }.onClick(()=>{
            this.showNumber = 1
          })
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

  //是否隐藏分组
  clickHideDialog: CustomDialogController | null = new CustomDialogController({
    builder: hideDialogExample({
      cancel: ()=> { this.clickHideCancel() },
      confirm: ()=> { this.clickHideAccept() },
      title:``
    }),
    cancel: this.hideDialog,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  clickHideCancel() {

  }

  clickHideAccept() {
    this.showFolderType()

  }

  hideDialog() {

  }

  isTopChange(){
    console.log('置顶操作中')
    if (this.folderCheckList.length === this.groupData.length) {
      this.folderCheckList.reverse()
      this.groupData = this.folderCheckList
      for (let index = 0; index < this.folderCheckList.length; index++) {
        this.groupData[index].isTop = true
      }
    } else {
      for (let index = 0; index < this.folderCheckList.length; index++) {
        for (let j = 0; j < this.groupData.length; j++) {
          if (this.folderCheckList[index].id === this.groupData[j].id) {
            this.groupData[j].topUpdateTime = new Date()
            this.groupData[j].isTop = true
            break
          }
        }
      }
    }
    showMessage('置顶成功')
    this.changeTop = false
    this.allCheck = false
    //更新缓存
    this.folderCheckList = []
    this.showFolderSort()
  }

  showFolderSort() {
    this.groupData.sort((a, b) => {
      if (a.isTop && !b.isTop) {
        return -1
      } else if (!a.isTop && b.isTop) {
        return 1
      } else {
        // return 0
        return b.topUpdateTime.getTime() - a.topUpdateTime.getTime()
      }
    })
  }


  restTitleDialog: CustomDialogController | null = new CustomDialogController({
    builder: commonInputDialog({
      textValue:this.folderType,
      cancel: () => {
        this.restTitleCancel()
      },
      confirm: () => {
        this.restTitleConfirm()
      },
      placeholder:'请输入分组名称',
      title:'重命名'
    }),
    gridCount: 4,
    cancel: this.restTitleCancel,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 25
  })

  restTitleCancel(){
    this.restTitleDialog?.close()
  }

  restTitleConfirm(){
    showMessage('重命名成功')
    this.restTitleDialog?.close()
  }

}