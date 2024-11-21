import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import { showMessage } from '../../../../../componets/common/promptShow'
import { BookGroups } from '../../../../../database/entities/BookGroups'
import BookFolderGridManage from './BookFolderGridManage'
import BookFolderInfoManage from './BookFolderInfoManage'

@Component
export default struct BookFolderManages {
  @Prop bookGroups:BookGroups[] = []
  @Link checkGroup:Record<number, boolean>
  @Prop EXHIBIT:string
  @State delCache:boolean = false
  @Prop isManage:boolean = true
  onSelect:Function = () => {}
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
   if (this.bookGroups === null || this.bookGroups.length === 0) {
     Column() {
       Image($r('app.media.no_record')).width(200).height(200)
       Text('暂无浏览记录').fontSize(12).fontColor('rgba(96, 96, 96, 0.6)').fontWeight(500).padding(5)
     }
     .margin({ top: 120 })
   } else {
     Column(){
       if (this.EXHIBIT === '列表') {
         ForEach(this.bookGroups, (item: BookGroups) => {
           if (item.show && !item.isSystem) {
             BookFolderInfoManage({
               group:item,
               checkGroup:this.checkGroup,
               isManage:this.isManage,
               onSelect:()=>{
                 this.onSelect()
               }
             })
           }
         })
       } else {
         GridRow({
           columns:3
         }){
           ForEach(this.bookGroups, (item: BookGroups) => {
             if (item.show && !item.isSystem) {
               GridCol(){
                 BookFolderGridManage({
                   group:item,
                   checkGroup:this.checkGroup,
                   isManage:this.isManage,
                   onSelect:()=>{
                     this.onSelect()
                   }
                 })
               }
             }
           })
         }
       }
     }.layoutWeight(1)
   }
 }
}