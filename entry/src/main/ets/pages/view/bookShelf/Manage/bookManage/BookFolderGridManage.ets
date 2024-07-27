import { showMessage } from '../../../../../componets/common/promptShow'
import BooksDao from '../../../../../database/dao/BooksDao'
import { BookGroups } from '../../../../../database/entities/BookGroups'

/**
 * 文件夹宫格_管理页
 */
@Component
export default struct BookFolderGridManage {

  @Prop group:BookGroups
  build() {
    Column() {
      Stack() {
        Stack(){
          Checkbox({
            name: JSON.stringify(this.group.groupId),
            group:'checkboxGroup'
          })
            .zIndex(999)
            .selectedColor($r('app.color.theme_color'))
            .unselectedColor('rgba(0, 0, 0, 0.35)')

          Stack(){
            if (this.group.isTop){
              Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
                .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
            }
            Image(this.group.coverUrl)
              .alt($r('app.media.icon_book_default_cover_one'))
              .width(88)
              .height(120)
          }.alignContent(Alignment.BottomStart)
        }
        .zIndex(2)
        // .alignContent(Alignment.BottomStart)


        Row() {
          Image($r('app.media.occlusion1'))
        }
        .zIndex(1).width(95).height(110)
        Row() {
          Image($r('app.media.occlusion2'))
        }
        .zIndex(0).width(100).height(100)
      }
      .alignContent(Alignment.BottomStart)
      Row().width(100).height(20).backgroundColor('rgba(255, 255, 255, 0.6)').borderRadius(10)
      Text(this.group.groupName)
          .fontSize(15)
          .fontWeight(700)
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .maxLines(2)
      Text(`共${this.group.bookIds?.length||0}本`).fontSize(12).fontColor('rgb(174,174,174)')
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