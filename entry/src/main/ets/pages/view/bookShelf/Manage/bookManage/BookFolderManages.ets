import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import { showMessage } from '../../../../../componets/common/promptShow'
import { folderList } from '../../../../../componets/dataList/folderList'
import BookFolderGridManage from './BookFolderGridManage'
import BookFolderInfoManage from './BookFolderInfoManage'

@Component
export default struct BookFolderManages {
  @Link folderCheckList:folderList[]
  @Prop changeTop:boolean
  @Link folderList:folderList[]
  @Prop EXHIBIT:string
  @State delCache:boolean = false
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
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
    // this.isClear = false
  }

  onAccept() {
    this.deleteFolder()
  }

  exitApp() {
    // this.isClear = false
  }

  deleteFolder() {
    showMessage('删除成功')
  }

 build() {
   if (this.folderList === null || this.folderList.length === 0) {
     Column() {
       Image($r('app.media.no_record')).width(200).height(200)
       Text('暂无浏览记录').fontSize(12).fontColor('rgba(96, 96, 96, 0.6)').fontWeight(500).padding(5)
     }
     .margin({ top: 120 })
   } else {
     Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
       if (this.EXHIBIT === '列表') {
         ForEach(this.folderList, (item: folderList) => {
           if (!item.isShow) {
             BookFolderInfoManage({
               folderList:item
             })
           }
         })
       } else {
         ForEach(this.folderList, (item: folderList) => {
           if (!item.isShow) {
             BookFolderGridManage({
               folderList:item
             }).width('33%')
           }
         })
       }
     }
   }



 }
}