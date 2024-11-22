/**
 * 新建/修改书单
 */
import CommonConstants from '../../../../../common/constants/CommonConstants'
import PaddingConstants from '../../../../../common/constants/PaddingConstants'
import { ThemeStorageKey } from '../../../../../common/constants/Theme'
import { ThemeItem } from '../../../../../common/model/Theme'
import worksListsUtils from '../../../../../common/utils/WorksListsUtils'
import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import { showMessage } from '../../../../../componets/common/promptShow'
import BooksDao from '../../../../../database/dao/BooksDao'
import { Books } from '../../../../../database/entities/Books'
import { WorksBookList } from '../../../../../database/entities/WorksBookList'
import { WorksLists, WORK_BOOK_LIST_STATUS } from '../../../../../database/entities/WorksLists'
import shareWorksBook from '../../../dialog/shareWorksBook'
import newAddShelf from './newAddShelf'

@Component
export default struct newBookShelf{
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Prop currentIndex:number
  @State TextRecommend:Record<number, string> = {}
  @State delCache:boolean = false
  @State addBooksList:Books[] = []
  @Prop bookIds:number[] = []
  @State  @Watch('changeBookIds')newBookIds:number[] = []
  @State isShowAddBook:boolean = false
  changeShowNumber:Function = (_index:number)=>{

  }
  submit:Function = ()=>{
  }
  @Prop lastWorkBookList:WorksLists
  //状态管理0新增,1预览,2修改
  @Prop workBookListStatus:number = 0
  changeBookIds(){
    this.getBookIds()
  }
  @Prop returnClose:boolean = false

  async aboutToAppear(): Promise<void> {
    if (this.workBookListStatus === 0) {
      this.newBookIds = this.bookIds
    } else {
      this.workBookList = this.lastWorkBookList
      if (this.workBookList.worksBookList) {
        //初始推荐理由
        this.workBookList.worksBookList.forEach((item: WorksBookList) => {
          if (item.bookId) {
            this.TextRecommend[item.bookId] = item.recommend ?? '';
          }
        })
        //初始书籍
        let bookIds = worksListsUtils.getBookIds(this.workBookList.worksBookList)
        if (this.bookIds && this.bookIds.length && this.workBookListStatus === 2) {
          this.bookIds.forEach((id: number) => {
            if (!bookIds.includes(id)) {
              bookIds.push(id);
            }
          });
        }
        if (bookIds.length) {
          this.newBookIds = bookIds;
        }
      }
    }
  }
  getBookIds(){
    this.workBookList.worksBookList = []
    BooksDao.getBookByIds(this.newBookIds).then((val)=>{
      this.addBooksList = val
      this.addBooksList.forEach((item: Books) => {
        const exists = this.workBookList.worksBookList?.some(book => book.bookId === item.id);
        if (item.id && !exists) {
          this.TextRecommend[item.id] = this.TextRecommend[item.id] ?? '';
        }

        if (!exists) {
          let books = new WorksBookList();
          books.bookId = item.id;
          books.recommend = '';
          this.workBookList.worksBookList?.push(books);
        }
      });
    })
  }

  @State delBookIds:number = 0
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: ()=> {
        this.moveWorksBook()
      },
      delCache:this.delCache
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })
  //仅移除书单中的书籍不做删除
  moveWorksBook() {
    // 过滤出要保留的书籍
    this.workBookList.worksBookList = this.workBookList.worksBookList?.filter(item => item.bookId !== this.delBookIds);
    this.addBooksList = this.addBooksList.filter(item => item.id !== this.delBookIds);
    this.newBookIds = this.newBookIds.filter(item => item !== this.delBookIds);
    // 重置 delBookIds
    this.delBookIds = 0;
    showMessage('移除书单成功,提交生效!', 1000)
  }

  @State workBookList:WorksLists = {
    worksName: '',
    worksDescribe: '',
    worksRemark: '',
    worksCoverUrl: '',
    createTime: 0,
    updateTime: 0,
    worksType: 0,
    worksBookNum: 0,
    isTop: false,
    worksBookList:[]
  }
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }
    ){
      Column({
        space:24
      }) {
        Flex({
          alignItems:ItemAlign.Center,
          justifyContent:this.workBookListStatus !== 1 ? FlexAlign.Center : FlexAlign.SpaceBetween
        }){
          Image($r('app.media.return_left'))
            .width(25)
            .height(25)
            .fillColor('rgba(0, 0, 0, 0.88)')
            .onClick(()=>{
              if (this.workBookListStatus !== 2) {
                this.changeShowNumber(0)
              } else {
                if (this.returnClose) {
                  this.workBookListStatus = 1
                } else {
                  this.submit()
                }
              }
            })

          Row({
            space:24
          }){
            Image($r('app.media.edit_black')).width(25)
              .onClick(()=>{
                this.workBookListStatus = 2
              })
            Image($r('app.media.edit_share')).width(25)
              .onClick(()=>{
                this.shareShelfBookDialog?.open()
              })
          }
          .visibility(this.workBookListStatus === 1?Visibility.Visible:Visibility.None)
          .opacity(this.workBookListStatus === 1?1:0)
          .translate({ y: this.workBookListStatus === 1 ? 0 : -50})
          .animation({
            duration: 500,
            curve: CommonConstants.UniCurve
          })
          .justifyContent(FlexAlign.Center)

          Column(){
            Text(WORK_BOOK_LIST_STATUS[this.workBookListStatus])
              .fontSize(16)
              .lineHeight(24)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
              .fontColor($r('app.string.color_black_88'))
          }
          .visibility(this.workBookListStatus !== 1?Visibility.Visible:Visibility.None)
          .opacity(this.workBookListStatus !== 1?1:0)
          .translate({ y: this.workBookListStatus !== 1 ? 0 : -50})
          .animation({
            duration: 500,
            curve: CommonConstants.UniCurve
          })
          .justifyContent(FlexAlign.Center)
          .margin({right:20})
          .width('100%')
        }
        Column(){
          if (this.workBookListStatus !== 1){
            Stack() {
              TextInput({ text: this.workBookList.worksName ?? '', placeholder: `请输入书单名称` })
                .placeholderColor('#73000000')
                .maxLength(20)
                .placeholderFont({ size: 14, weight: 400 })
                .caretColor(this.theme.mainColor)
                .height(38)
                .margin({ top: 10, bottom: 10 })
                .fontSize(14)
                .fontColor('#E0000000')
                .borderRadius(4)
                .onChange((value: string) => {
                  this.workBookList.worksName = value
                })

              Text(`${this.workBookList.worksName?.length ?? 0}/20`)
                .fontSize(14)
                .fontColor('#73000000')
                .position({ top: 20, right: 10 })
            }.width('80%')

            TextArea({
              text:this.workBookList.worksDescribe,
              placeholder:'书单描述'
            })
              .borderRadius(4)
              .fontColor('#E0000000')
              .caretColor(this.theme.mainColor)
              .placeholderColor('#73000000')
              .width('80%')
              .fontSize(14)
              .fontWeight(500)
              .lineHeight(26)
              .fontColor($r('app.string.color_black_88'))
              .margin({
                top: PaddingConstants.PADDING_12
              })
              .onChange((value: string) => {
                this.workBookList.worksDescribe = value
              })
          } else {
            Text(this.workBookList.worksName).fontSize(16).fontWeight(500).lineHeight(26).fontColor('rgba(0, 0, 0, 0.88)')
            Text(this.workBookList.worksDescribe)
              .fontSize(14).fontWeight(500).lineHeight(26).fontColor('rgba(0, 0, 0, 0.88)')
              .margin({top:12})
          }

          Scroll(){
            Column(){
              ForEach(this.addBooksList,(item:Books,index:number)=>{
                this.BookShelfInfo(item,index)
              })
            }
          }
          .align(Alignment.TopStart)
          .scrollBar(BarState.Off)
          .layoutWeight(1)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .padding({left:20,right:20,top:12,bottom:12})
      .alignItems(HorizontalAlign.Start)

      if (this.workBookListStatus !== 1){
        Divider().strokeWidth(0.5)
        Flex({
          justifyContent:FlexAlign.Center
        }){
          this.newFooter()
        }
        .backgroundColor(Color.White)
      }
      Flex()
        .bindContentCover($$this.isShowAddBook, this.newAddBook(), {
          modalTransition: ModalTransition.DEFAULT,
          onDisappear: () => {
            this.isShowAddBook = false;
          }
        })
    }
    .padding({
      top:this.topRectHeight,
      bottom:this.bottomRectHeight
    })
  }

  @Builder newAddBook(){
    Column(){
      newAddShelf({
        currentIndex:this.currentIndex,
        addBookList:(selectBookId:number[])=>{
          this.newBookIds = selectBookId
          this.isShowAddBook = false;
          showMessage('加入书单成功,提交生效!')
        },
        close:() => {
          this.isShowAddBook = false;
        },
        lastBookIds:this.newBookIds
      })
    }
    .backgroundColor(Color.White)
  }

  @Builder newFooter(){
    Row({
      space:20
    }) {
      Flex({
        justifyContent:FlexAlign.Center,
        alignItems:ItemAlign.Center
      }){
       Row({
         space:5
       }){
         Image($r('app.media.add_new_fill')).width(20).height(20)
         Text('添加书籍').fontSize(16).fontWeight(500).fontColor('rgba(0, 0, 0, 0.45)').textAlign(TextAlign.Center)
       }
      }
      .width('40%')
      .height(38)
      .borderRadius(20)
      .backgroundColor('rgba(0, 0, 0, 0.04)')
      .onClick(()=>{
        this.isShowAddBook = true
      })
      Flex({
        justifyContent:FlexAlign.Center,
        alignItems:ItemAlign.Center
      }){
        Text('确定').fontSize(16).fontWeight(500).fontColor(Color.White)
      }
      .onClick(async ()=>{
        // showMessage(JSON.stringify(this.workBookList.worksBookList))
        // return
        if (!this.workBookList.worksName) {
          showMessage('书单名称不能为空!')
          return
        }
        //默认取书籍的第一个封面为书单封面
        if(this.addBooksList.length > 0){
          this.workBookList.worksCoverUrl = this.addBooksList[0].coverUrl ?? ''
        }
        await worksListsUtils.addWorksLists(this.workBookList)
        showMessage(this.workBookListStatus === 0?'创建书单成功':'修改书单成功')
        this.initWorkData()
        this.changeShowNumber(0)
        this.submit()
      })
      .borderRadius(20)
      .width('50%')
      .height(38)
      .backgroundColor(this.workBookList.worksName.length >=1?this.theme.mainColor: this.theme.mainColor)
    }.padding({top:12,bottom:12,left:20,right:20})
  }

  @Builder BookShelfInfo(book:Books,index:number){
    Column() {
      Row({
        space: 12
      }) {
        Stack(){
          if (book.isTop){
            Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
              .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
          }
          Image(book.coverUrl)
            .draggable(false)
            .alt($r('app.media.icon_book_default_cover_one'))
            .width(69)
            .height(92)
        }.alignContent(Alignment.BottomStart)

        Column({
          space:5
        }) {
          Row(){
            Text(book.bookName).fontSize(16).fontWeight(500).lineHeight(24)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(1).width('65%')

            if (this.workBookListStatus !== 1){
              Image($r('app.media.close')).width(12).onClick(()=>{
                this.bookInfoDel?.open()
                this.delBookIds = book.id ?? 0
              })
            } else {
              Image(book.isJoin?$r('app.media.unadd_book_shelf'):$r('app.media.add_book_shelf'))
                .width(20)
                .height(20)
                .onClick(()=>{
                if (!book.isJoin) {
                  showMessage('已加入书架')
                }
              })
            }
          }
          Text(book.intro)
            .fontSize(12)
            .lineHeight(20)
            .fontColor('rgba(0, 0, 0, 0.45)')
            .textOverflow({
              overflow:TextOverflow.Ellipsis
            })
            .height(50)
            .ellipsisMode(EllipsisMode.END)
            .maxLines(2).width('75%')
          Row({
            space:6
          }){
            Row(){
              Text('卖报小郎君').fontSize(10).fontWeight(400).fontColor(this.theme.mainColor)
            }
            .padding({left:6,right:6,top:5,bottom:5}).backgroundColor(this.theme.secondColor).borderRadius(10)
            Row(){
              Text('玄幻').fontSize(10).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
            }
            .fontStyles()
            Row(){
              Text('完本').fontSize(10).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
            }
            .fontStyles()
            Row(){
              Text('380万字').fontSize(10).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
            }.fontStyles()
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      Column(){
        if (this.workBookListStatus ===0 || this.workBookListStatus === 2){
          TextArea({placeholder:'添加推荐理由', text:this.TextRecommend[book.id ?? 0]}).padding(10).borderRadius(8)
            .onChange((value:string)=>{
              this.TextRecommend[book.id ?? 0] = value
              let books = new WorksBookList()
              books.bookId = book.id
              books.recommend = value
              let existingBook = this.workBookList.worksBookList?.find(item => item.bookId === books.bookId);
              if (existingBook) {
                existingBook.recommend = books.recommend;
              } else {
                this.workBookList.worksBookList?.push(books);
              }
            })
        } else {
          Text(this.TextRecommend[book.id ?? 0] ?? '')
            .padding(10)
        }
      }
      .padding({top:12,bottom:5})
      if (this.TextRecommend[book.id ?? 0] && this.TextRecommend[book.id ?? 0].length >= 1 && this.workBookListStatus !== 1){
        Flex({
          justifyContent:FlexAlign.End
        }){
          Text('清空').textAlign(TextAlign.End).fontColor(this.theme.mainColor)
        }.onClick(()=>{
          this.TextRecommend[book.id ?? 0] = ''
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .padding({top:16})
  }
  //初始化页面
  initWorkData(){
    this.addBooksList = []
    this.TextRecommend = {}
    this.workBookList = {
      worksName: '',
      worksDescribe: '',
      worksRemark: '',
      worksCoverUrl: '',
      createTime: 0,
      updateTime: 0,
      worksType: 0,
      worksBookNum: 0,
      isTop: false,
      worksBookList:[]
    }
  }

  shareShelfBookDialog: CustomDialogController | null = new CustomDialogController({
    builder: shareWorksBook({
      works:this.workBookList
    }),
    autoCancel: true,
    width:'100%',
    height:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true
  })
}

@Styles function fontStyles() {
  .padding({left:6,right:6,top:5,bottom:5})
  .backgroundColor('rgba(0, 0, 0, 0.06)')
  .borderRadius(10)
}