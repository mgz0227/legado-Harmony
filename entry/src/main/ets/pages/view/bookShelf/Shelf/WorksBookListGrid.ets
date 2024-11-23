import { ThemeStorageKey } from '../../../../common/constants/Theme'
import { ThemeItem } from '../../../../common/model/Theme'
import { WorksLists } from '../../../../database/entities/WorksLists'

@Component
export default struct WorksBookListGrid {

  @Prop work:WorksLists
  @Prop isShowCheck:boolean
  @Link checkGroup:Record<number, boolean>
  onSelect:Function = () => {}
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    Column() {
      Stack() {
        if (this.isShowCheck){
          Flex({
            alignItems: ItemAlign.End,
            justifyContent: FlexAlign.End
          }){
            Checkbox()
              .zIndex(2)
              .selectedColor(this.theme.mainColor)
              .unselectedColor('rgba(0, 0, 0, 0.35)')
              .select(this.work.worksId?this.checkGroup[this.work.worksId] ?? false:false)
              .selectedColor(this.theme.mainColor)
              .onChange((val: boolean) => {
                if (this.work.worksId) {
                  this.checkGroup[this.work.worksId] = val
                }
              })
              .onClick(() => {
                this.onSelect()
              })
          }
          .zIndex(3)
          .backgroundColor('rgba(0,0,0,0.45)')
          .width(88).height(120)
        }
          Stack(){
            if (this.work.isTop){
              Text('置顶')
                .fontColor(Color.White)
                .fontWeight(300)
                .fontSize(8)
                .padding(3)
                .borderRadius(5)
                .backgroundColor('rgba(0, 0, 0, 0.45)')
                .zIndex(1)
            }
            Image(this.work.worksCoverUrl)
              .draggable(false)
              .alt($r('app.media.icon_book_default_cover_one'))
              .width(88)
              .height(120)
          }
          .zIndex(2)
          .alignContent(Alignment.BottomStart)
        Row() {
          Image($r('app.media.occlusion1'))
            .draggable(false)
        }
        .zIndex(1)
        .width(95)
        .height(110)

        Row() {
          Image($r('app.media.occlusion2'))
            .draggable(false)
        }
        .zIndex(0)
        .width(100)
        .height(100)
      }
      .align(Alignment.BottomStart)

      Row().width(100).height(20).backgroundColor('rgba(255, 255, 255, 0.6)').borderRadius(10)

      Text(this.work.worksName)
          .fontSize(15)
          .fontWeight(700)
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .maxLines(2)
        Text(`共${this.work.worksBookNum}本`).fontSize(12).fontColor('rgb(174,174,174)')
          .textOverflow({
            overflow:TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
          .fontWeight(500)
          .maxLines(1)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left:8,right:8,bottom:5,top:5 })
  }
}