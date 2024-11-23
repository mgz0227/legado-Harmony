import { ThemeStorageKey } from '../../../../../common/constants/Theme'
import { ThemeItem } from '../../../../../common/model/Theme'
import BookOverlay from '../../../../../componets/bookDetail/BookOverlay'
import { BookGroups } from '../../../../../database/entities/BookGroups'

/**
 * 文件夹列表_管理页
 */
@Component
export default struct BookFolderInfoManage {
  @Prop group:BookGroups
  @Link checkGroup:Record<number, boolean>
  @Prop isManage:boolean
  onSelect:Function = () => {}
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
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
          isTop:this.group.isTop,
          coverType:this.group.coverType
        })
        Column({
          space:24
        })
        {
          Text(this.group.groupName)
            .fontWeight(700)
          Column(){
            Text(`共${this.group.bookIds?.length||0}本`).fontSize(12).fontColor('rgb(174,174,174)')
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
      if (this.isManage){
        Row() {
          Checkbox()
            //判断是否存在当前id
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
        .padding({ left: 15, right: 15, bottom: 5, top: 5 })
      }


    }
    .padding(10)
    .borderRadius(10)
  }


}