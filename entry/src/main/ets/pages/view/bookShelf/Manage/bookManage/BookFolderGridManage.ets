import BookOverlay from '../../../../../componets/bookDetail/BookOverlay'
import { folderList } from '../../../../../componets/dataList/folderList'

/**
 * 文件夹宫格_管理页
 */
@Component
export default struct BookFolderGridManage {

  @Prop @Watch('isCheckChange')allCheck:boolean
  @Link folderCheckList:folderList[]
  @Prop @Watch('isTopChange')changeTop:boolean
  @Prop folderList:folderList

  isTopChange(){
    this.allCheck = false
  }

  isCheckChange(){
    if (this.allCheck) {
      //判断bookId是否有存在
      if (this.folderCheckList.some(item => item.id === this.folderList.id)) {
        return
      }
      this.folderCheckList.push(this.folderList)
    } else {
      this.folderCheckList = this.folderCheckList.filter(item => item.id !== this.folderList.id);
    }
  }

  build() {
    Column() {
      Stack() {
        Flex({
          alignItems: ItemAlign.End,
          justifyContent: FlexAlign.End
        }) {
          Flex({
            alignItems: ItemAlign.End,
          }) {
            if (this.folderList.isTop) {
              Text('置顶')
                .fontColor(Color.White)
                .fontWeight(300)
                .fontSize(8)
                .padding(5)
                .margin({ left: 1, bottom: 1 })
                .borderRadius({ bottomLeft: 10, bottomRight: 5, topRight: 5, topLeft: 5 })
                .backgroundColor('rgba(0, 0, 0, 0.45)')
            }
          }
          .align(Alignment.Bottom)

          Checkbox({
            name: this.folderList.title
          })
            .zIndex(2)
            .selectedColor($r('app.color.theme_color'))
            .unselectedColor('rgba(0, 0, 0, 0.35)')
            .select(this.allCheck)
            .onClick(() => {
              this.allCheck = !this.allCheck
            })
        }
        .backgroundColor('rgba(0, 0, 0, 0.45)')
        .width(88)
        .height(120)
        .backgroundImage(this.folderList.bookImage)
        .backgroundImageSize({ width: 88, height: 120 })
        .zIndex(2)
        Row() {
          Image($r('app.media.occlusion1'))
        }
        .zIndex(1)
        .width(95).height(110)

        Row() {
          Image($r('app.media.occlusion2'))
        }.zIndex(0)
        .width(100).height(100)
      }
      Row().width(100).height(20).backgroundColor('rgba(255, 255, 255, 0.6)').borderRadius(10)
      Text(this.folderList.title)
          .fontSize(15)
          .fontWeight(700)
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .maxLines(2)
        Text(`共${this.folderList.countNumber}本`).fontSize(12).fontColor('rgb(174,174,174)')
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .fontWeight(500)
          .maxLines(1)
    }
    .padding({ left:8,right:8,bottom:5,top:5 })
  }
}