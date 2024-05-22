import CommonConstants from '../../common/constants/CommonConstants'
import addBookTypeDialog from '../common/addBookTypeDialog'
import confirmDialogExample from '../common/confirmDialog'
import { showMessage } from '../common/promptShow'
import { BookList } from '../dataList/bookList'

@Component

export default struct catalogMove{
  @Link isShow:boolean
  @State BooTypeList:string[] = ['玄幻','修真', '都市', '穿越', '网游', '科幻', '历史']
  @Prop checkNumber:number = 0
  @Link checkBookList:BookList[]

  @State clickBookType:string = ''

  build() {
    Column() {
      Column(){
        Text('移动分组').fontSize(16).fontWeight(700)
      }.padding({right:20,left:20,top:12,bottom:12})
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
      console.log(JSON.stringify(this.checkBookList))
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

  @State bookType:string = '哈哈哈'

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

  @State delCache:boolean = false
  //是否确认移动分组
  clickBookTypeDialog: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: ()=> { this.clickBookCancel() },
      confirm: ()=> { this.clickBookAccept() },
      title:`移动到${this.clickBookType}`,
      delCache:this.delCache
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
  @Link showBookList:BookList[]
  mobileBookType(){
    //循环遍历checkBookList当bookId和showBookList中的bookId相同时，将showBookList bookType改为clickBookType
    for (let i = 0; i < this.checkBookList.length; i++) {
      for (let j = 0; j < this.showBookList.length; j++) {
        if (this.checkBookList[i].bookId === this.showBookList[j].bookId) {
          this.showBookList[j].bookType = this.clickBookType
          console.log(JSON.stringify(this.showBookList) + 'test')
          return
        }
      }
    }
    this.checkBookList = []
  }
}