/**
 * @author 2008
 * @datetime 2024/7/26 20:35
 * @className: catalogAddShelf
 * 加入书单弹窗
 * todo 书单功能db暂未实现
 */
import CommonConstants from '../../../../../common/constants/CommonConstants'
import buttonCommon from '../../../../../componets/common/buttonCommon'
@Component
export default struct catalogAddShelf{
  onClickShelf:Function = (_isCatalogAddShelf:boolean)=>{

  }
  @State ShelfList:string[] = ['玄幻神作', '精品小说,亲自品鉴', '冷门小说不容错过','冷门小说不容错过']
  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      alignContent:FlexAlign.Center,
      direction:FlexDirection.Column
    }) {
      Column(){
        Column(){
          Text('加入书单').fontSize(16).fontWeight(700).lineHeight(24)
        }
        .padding({right:20,left:20,top:12,bottom:12})
        Divider().strokeWidth(0.5)
        Flex(){
          this.ColumnTitle('')
        }
        Scroll(){
          Column(){
            ForEach(this.ShelfList,(item:string)=>{
              this.ColumnTitle(item)
            })
          }
        }
        .height('45%')
        .scrollBar(BarState.Off)
      }
      Column(){
        Divider().strokeWidth(0.5)
        buttonCommon({
          cancel:()=>{
            this.onClickShelf(false)
          }
        })
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder ColumnTitle(title:string) {
    Column() {
      if (title === ''){
        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems:ItemAlign.Center
        }){
          Row({
            space:12
          }){
            Image($r('app.media.add')).width(24).fillColor($r('app.color.theme_color'))
            Text('新建书单').fontSize(14).fontColor($r('app.color.theme_color')).fontWeight(400).lineHeight(22)
          }.onClick(()=>{

          })
        }
      } else {
        Flex({
          justifyContent:FlexAlign.SpaceBetween,
          alignItems:ItemAlign.Center
        }){
          Row({
            space:12
          }){
            Image($r('app.media.shelf')).width(24)
            Text(title).fontSize(14).fontWeight(400).lineHeight(22).textOverflow({
              overflow:TextOverflow.Ellipsis
            }).ellipsisMode(EllipsisMode.END).maxLines(1)
          }

          if (false) {
            Image($r('app.media.ic_public_return_right')).width(24).height(24)
          } else {
            Text('已在书单').fontSize(12).fontWeight(400).lineHeight(20).fontColor('rgba(0, 0, 0, 0.45)')
          }
        }
      }
    }
    .onClick(()=>{

    })
    .padding({
      left:20,
      right:20,
      top:12,
      bottom:12
    })
  }
}