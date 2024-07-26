import BookOverlay from '../../../../../componets/bookDetail/BookOverlay'
import { showMessage } from '../../../../../componets/common/promptShow'
import BooksDao from '../../../../../database/dao/BooksDao'
import { BookGroups } from '../../../../../database/entities/BookGroups'

/**
 * 文件夹列表_管理页
 */
@Component
export default struct BookFolderInfoManage {

  @Prop group:BookGroups
  @State count:number = 0
  aboutToAppear(): void {
    if (this.group.groupId) {
      BooksDao.countBookByGroup(this.group.groupId)
        .then((val)=>{
          showMessage(JSON.stringify(val))
          this.count = val
        })
    }
  }
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
          bookImage:this.group.coverUrl,
          isTop:this.group.isTop
        })
        Column({
          space:24
        })
        {
          Text(this.group.groupName)
            .fontWeight(700)
          Column(){
            Text(`共${this.count}本`).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(400)
              .maxLines(1)
              .lineHeight(20)
            // Text(this.group.?this.folderList.newUpdateBook:'暂无更新')
            //   .fontSize(12)
            //   .fontWeight(400)
            //   .textOverflow({
            //     overflow:TextOverflow.Ellipsis
            //   })
            //   .ellipsisMode(EllipsisMode.END)
            //   .maxLines(1)
            //   .lineHeight(20)
          }
          .width('60%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
      }
      Row() {
        Checkbox({
          name: JSON.stringify(this.group.groupId),
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