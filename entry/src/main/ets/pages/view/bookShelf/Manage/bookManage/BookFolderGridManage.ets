import { ThemeStorageKey } from '../../../../../common/constants/Theme'
import { ThemeItem } from '../../../../../common/model/Theme'
import { BookGroups } from '../../../../../database/entities/BookGroups'

/**
 * 文件夹宫格_管理页
 */
@Component
export default struct BookFolderGridManage {
  @Prop group:BookGroups
  @Link checkGroup:Record<number, boolean>
  @Prop isManage:boolean
  onSelect:Function = () => {}
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    Column() {
      Stack() {
        Stack(){
          if (this.isManage){
            Checkbox()
              .zIndex(9)
              .select(this.group.groupId?this.checkGroup[this.group.groupId] ?? false:false)
              .selectedColor(this.theme.mainColor)
              .onChange((val: boolean) => {
                if (this.group.groupId) {
                  this.checkGroup[this.group.groupId] = val
                }
              })
              .onClick(()=>{
                this.onSelect()
              })
          }
          Stack(){
            if (this.group.isTop){
              Text('置顶').fontColor(Color.White).fontWeight(300).fontSize(8).padding(3).borderRadius(5)
                .backgroundColor('rgba(0, 0, 0, 0.45)').zIndex(1)
            }
            Image(this.group.coverUrl)
              .draggable(false)
              .alt($r('app.media.icon_book_default_cover_one'))
              .width(88)
              .height(120)
          }.alignContent(Alignment.BottomStart)
        }
        .alignContent(Alignment.BottomEnd)
        .zIndex(2)


        Row() {
          Image($r('app.media.occlusion1')).draggable(false)
        }
        .zIndex(1).width(95).height(110)
        Row() {
          Image($r('app.media.occlusion2')).draggable(false)
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