import confirmDialogExample from '../../../../componets/common/confirmDialog'
import { showMessage } from '../../../../componets/common/promptShow'
import { WorksLists } from '../../../../database/entities/WorksLists'
import WorksBookListGrid from './WorksBookListGrid'
import worksBookInfoDialog from '../../dialog/worksBookInfoDialog'
import WorksBookListInfo from './WorksBookListInfo'
import worksListsDao from '../../../../database/dao/WorksListsDao'
import newBookShelf from '../Manage/bookManage/newBookShelf'

/**
 * 书单
 */
@Component
export default struct WorksBookLists {
  @Link checkGroup:Record<number, boolean>
  @Prop EXHIBIT: string
  @Prop currentIndex:number
  @Prop worksLists:WorksLists[] =[]
  @Prop isShowCheck:boolean = false
  @State worksBook:WorksLists = new WorksLists()
  @StorageLink('BOOK_IS_BOOK_WORKS_BOOK_LIST') @Watch('getWorkLists')isWorksBookListRefreshing: number = 0
  onSelect:Function = () => {}
  aboutToAppear(): void {
    if (this.worksLists.length === 0) {
      this.getWorkLists()
    }
  }
  @State workBookListStatus:number = 1

  getWorkLists() {
    worksListsDao.search({
      type:this.currentIndex
    }).then((val)=>{
      this.worksLists = val
    })
  }

  build() {
    Column(){
      GridRow({
        columns:this.EXHIBIT === '宫格'?3:1
      }){
        ForEach(this.worksLists, (item: WorksLists, index: number) => {
          GridCol(){
            if (this.EXHIBIT === '宫格') {
              WorksBookListGrid({
                work:item,
                isShowCheck:this.isShowCheck,
                checkGroup:this.checkGroup,
                onSelect:()=>{
                  this.onSelect()
                }
              }).width('33%')
                .gesture(
                  LongPressGesture({ repeat: true,duration:500 })
                    .onAction((event: GestureEvent) => {
                      if (event.repeat) {
                        if (!this.isShowCheck) {
                          this.worksBook = item
                          this.shelfInfoDialog?.open()
                        }
                      }
                    }))
                .onClick(()=>{
                  if (!this.isShowCheck) {
                    this.worksBook = item
                    this.isShowEditBook = true
                  }
                })

            } else {
              WorksBookListInfo({
                work:item,
                isShowCheck:this.isShowCheck,
                checkGroup:this.checkGroup,
                onSelect:()=>{
                  this.onSelect()
                }
              })
                .gesture(
                  LongPressGesture({ repeat: true,duration:500 })
                    .onAction((event: GestureEvent) => {
                      if (event.repeat) {
                        if (!this.isShowCheck) {
                          this.worksBook = item
                          this.shelfInfoDialog?.open()
                        }
                      }
                    }))
                .onClick(()=>{
                  if (!this.isShowCheck) {
                    this.worksBook = item
                    this.isShowEditBook = true
                  }
                })
            }
          }
        })
      }
      Flex()
        .bindContentCover($$this.isShowEditBook, this.showEditBook(), {
        modalTransition: ModalTransition.DEFAULT,
        onDisappear: () => {
          this.isShowEditBook = false;
        }
      })

    }

  }
  @State isShowEditBook:boolean = false
  @Builder showEditBook(){
    Column(){
      newBookShelf({
        currentIndex:this.currentIndex,
        changeShowNumber:()=>{
          this.isShowEditBook = false
          setTimeout(()=>{
            this.getWorkLists()
          },200)
        },
        returnClose:true,
        workBookListStatus:this.workBookListStatus,
        lastWorkBookList:this.worksBook
      })
    }
    .backgroundColor(Color.White)
  }
  shelfInfoDialog: CustomDialogController | null = new CustomDialogController({
    builder: worksBookInfoDialog({
      works:this.worksBook,
      cancel: () => {
        this.exitDialog()
      }
    }),
    cancel: this.exitDialog,
    autoCancel: true,
    width:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true

  })
  //退出弹框
  exitDialog(){
    setTimeout(()=>{
      this.getWorkLists()
    },100)
  }
  @State delCache:boolean = false
  shelfInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      delCache:this.delCache
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  onCancel() {
    //this.isClear = false
  }

  onAccept() {
    this.delShelf()
  }

  delShelf() {
    showMessage('删除成功')
  }

  exitApp() {
    // this.isClear = false
  }
}