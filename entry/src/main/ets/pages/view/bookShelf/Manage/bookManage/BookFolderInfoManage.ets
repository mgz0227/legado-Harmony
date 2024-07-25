import BookOverlay from '../../../../../componets/bookDetail/BookOverlay'
import { folderList } from '../../../../../componets/dataList/folderList'

/**
 * 文件夹列表_管理页
 */
@Component
export default struct BookFolderInfoManage {

  @Prop folderList:folderList
  build() {
    Flex(
      {
        alignItems:ItemAlign.Center,
        justifyContent:FlexAlign.SpaceBetween
      }
    ) {
      Row({
        space:20
      }){
        BookOverlay({
          bookImage:this.folderList.bookImage,
          isTop:this.folderList.isTop
        })
        Column({
          space:24
        })
        {
          Text(this.folderList.title)
            .fontWeight(700)
          Column(){
            Text(`共${this.folderList.countNumber}本`).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(400)
              .maxLines(1)
              .lineHeight(20)
            Text(this.folderList.newUpdateBook?this.folderList.newUpdateBook:'暂无更新')
              .fontSize(12)
              .fontWeight(400)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(1)
              .lineHeight(20)
          }
          .width('60%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
      }
      Row() {
        Checkbox({
          name: this.folderList.title,
          group:'checkboxGroup'
        })
          .selectedColor($r('app.color.theme_color'))
      }
      .padding({ left: 15, right: 15, bottom: 5, top: 5 })

    }
    .padding(10)
    .borderRadius(10)
  }


}