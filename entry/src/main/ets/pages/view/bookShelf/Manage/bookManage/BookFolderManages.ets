import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import { showMessage } from '../../../../../componets/common/promptShow'
import { folderList } from '../../../../../componets/dataList/folderList'
import BookFolderGridManage from './BookFolderGridManage'
import BookFolderInfoManage from './BookFolderInfoManage'

@Component
export default struct BookFolderManages {
  @Link @Watch('onIsClearChange') isClear:boolean
  @Link allCheck:boolean
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
    for (let index = 0; index < this.folderCheckList.length; index++) {
      this.folderList = this.folderList.filter(folder => folder.id !== this.folderCheckList[index].id);
    }
    this.isClear = false
    this.folderCheckList = []
    showMessage('删除成功')
  }

  //监听isClear变化
  onIsClearChange() {
    console.log(JSON.stringify(this.isClear))
    if (this.folderCheckList === null || this.folderCheckList.length === 0) {
      showMessage('请选择要删除的内容')
      this.isClear = false
      return
    }
    if (this.isClear) {
      this.bookInfoDel?.open()
    }
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
               folderList:item,
               changeTop:this.changeTop,
               allCheck:this.allCheck,
               folderCheckList:this.folderCheckList
             })
           }
         })
       } else {
         ForEach(this.folderList, (item: folderList) => {
           if (!item.isShow) {
             BookFolderGridManage({
               folderList:item,
               changeTop:this.changeTop,
               allCheck:this.allCheck,
               folderCheckList:this.folderCheckList
             }).width('33%')
           }
         })
       }
     }
   }



 }
}