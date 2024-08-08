import worksListsUtils from '../../../common/utils/WorksListsUtils'
import confirmDialogExample from '../../../componets/common/confirmDialog'
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { buttonList } from '../../../componets/dataList/buttonList'
import { WorksLists } from '../../../database/entities/WorksLists'
import newBookShelf from '../bookShelf/Manage/bookManage/newBookShelf'
import shareWorksBook from './shareWorksBook'

@CustomDialog
/**
 * 书单长按弹窗
 */
export default struct worksBookInfoDialog{
  controller?: CustomDialogController
  //推送提醒
  @Prop works:WorksLists
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'编辑',$r('app.media.edit')),
    new buttonList(2,'分享',$r('app.media.icon_share')),
    new buttonList(3,'删除',$r('app.media.ic_public_delete'))
  ]

  cancel: () => void = () => {
  }

  build() {
    Column(){
      Divider().strokeWidth(0.5).padding({bottom:16})
      GridRow({
        columns:4
      }){
        ForEach(this.buttonListInfo,(item:buttonList)=>{
          GridCol(){
            InsideCircleIcon({
              icon:item.icon,
              title:item.title
            })
              .onClick(()=>{
                switch (item.id){
                  case 1:
                    this.isShowEditBook = true
                    break
                  case 2:
                    this.shareShelfBookDialog?.open()
                    break
                  case 3:
                    this.delDialog?.open()
                    break;
                }
              })
          }
        })

      }
      Divider().strokeWidth(0.5).padding({bottom:16})
      Column(){
        Text('取消')
          .fontColor('rgba(0, 0, 0, 0.88)')
          .fontSize(16)
          .fontWeight(400)
          .lineHeight(24)
          .textAlign(TextAlign.Center)
      }
      .onClick(()=>{
        this.cancel()
        this.controller?.close()
      })
      .alignItems(HorizontalAlign.Center)
      .padding({bottom:16})
      Flex()
        .bindContentCover($$this.isShowEditBook, this.showEditBook(), {
          modalTransition: ModalTransition.DEFAULT,
          onDisappear: () => {
            this.isShowEditBook = false;
          }
        })
    }
    .borderRadius({topLeft:20,topRight:20})
    .backgroundColor(Color.White)
    .width('100%')
  }
  @State isShowEditBook:boolean = false
  @StorageLink('BOOK_IS_BOOK_WORKS_BOOK_LIST') isWorksBookListRefreshing: number = 0
  @Builder showEditBook(){
    Column(){
      newBookShelf({
        currentIndex:this.works.worksType,
        changeShowNumber:()=>{
          this.isShowEditBook = false
          setTimeout(()=>{
            this.isWorksBookListRefreshing++
          },100)
        },
        returnClose:true,
        workBookListStatus: 2,
        lastWorkBookList:this.works
      })
    }
    .backgroundColor(Color.White)
  }

  //分享弹窗
  shareShelfBookDialog: CustomDialogController | null = new CustomDialogController({
    builder: shareWorksBook({
      works:this.works
    }),
    autoCancel: true,
    width:'100%',
    height:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true
  })

  //删除确认弹出框
  @State delCache:boolean = false
  delDialog: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      confirm: ()=> {
        if (this.works.worksId) {
          worksListsUtils.delWorksByIds(this.works.worksId);
          this.controller?.close()
          this.cancel()
        }
      },
      delCache:this.delCache
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })
}