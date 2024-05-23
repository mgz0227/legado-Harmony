import confirmDialogExample from '../../../../componets/common/confirmDialog'
import { showMessage } from '../../../../componets/common/promptShow'
import { shelfList } from '../../../../componets/dataList/shelfList'
import ShelfInfoDialog from '../../dialog/ShelfInfoDialog'
import BookShelfGrid from './BookShelfGrid'
import BookShelfInfo from './BookShelfInfo'
import editBookShelf from './editBookShelf'

/**
 * 书单
 */
@Component
export default struct ShelfBookList {
  @Prop EXHIBIT: string
  @StorageProp('SHELF_LIST_DATA')
  shelfBookList: shelfList[] = []
  @State checkBookShelf: shelfList[] = []
  @Prop changeTop:boolean
  @Prop allCheck:boolean
  @Prop isShowCheck:boolean = false
  @State isShow:boolean = false
  @State shelfBook:shelfList = this.shelfBookList[0]
  @Link @Watch('onIsClearChange') isClear:boolean
  //监听isClear变化
  onIsClearChange() {
    if (this.checkBookShelf === null || this.checkBookShelf.length === 0) {
      showMessage('请选择要删除的内容')
      this.isClear = false
      return
    }
    if (this.isClear) {
      this.shelfInfoDel?.open()
    }
  }
  build() {
    Column(){
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Center }) {
        ForEach(this.shelfBookList, (item: shelfList, index: number) => {

          if (this.EXHIBIT === '宫格') {
            BookShelfGrid({
              allCheck: this.allCheck,
              bookShelf:item,
              checkBookShelf:this.checkBookShelf,
              changeTop:this.changeTop,
              isShowCheck:this.isShowCheck
            }).width('33%')
              .gesture(
                LongPressGesture({ repeat: true,duration:500 })
                  .onAction((event: GestureEvent) => {
                    if (event.repeat) {
                      if (!this.isShow) {
                        this.shelfBook = item
                        this.isShow = true
                        this.shelfInfoDialog?.open()
                      }
                    }
                  }))
              .onClick(()=>{
                if (!this.isShow) {
                  this.shelfBook = item
                  this.isShow = true
                  this.shelfAllInfoDialog?.open()
                }
                // showMessage('跳转')
              })

          } else {
            BookShelfInfo({
              allCheck: this.allCheck,
              bookShelf:item,
              checkBookShelf:this.checkBookShelf,
              changeTop:this.changeTop,
              isShowCheck:this.isShowCheck
            })
              .gesture(
                LongPressGesture({ repeat: true,duration:500 })
                  .onAction((event: GestureEvent) => {
                    if (event.repeat) {
                      if (!this.isShow) {
                        this.shelfBook = item
                        this.isShow = true
                        this.shelfInfoDialog?.open()
                      }
                    }
                  }))
              .onClick(()=>{
                if (!this.isShow) {
                  this.shelfBook = item
                  this.isShow = true
                  this.shelfAllInfoDialog?.open()
                }
                showMessage('跳转')
              })
          }
        })
      }
    }

  }
  shelfAllInfoDialog: CustomDialogController | null = new CustomDialogController({
    builder: editBookShelf({
      shelf:this.shelfBook,
      cancel: () => {
        this.exitDialog()
      }
    }),
    cancel: this.exitDialog,
    autoCancel: true,
    width:'100%',
    height:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true
  })

  shelfInfoDialog: CustomDialogController | null = new CustomDialogController({
    builder: ShelfInfoDialog({
      itemData:this.shelfBook,
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
    this.isShow = false
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
    this.isClear = false
    showMessage('删除成功')
  }

  exitApp() {
    // this.isClear = false
  }
}