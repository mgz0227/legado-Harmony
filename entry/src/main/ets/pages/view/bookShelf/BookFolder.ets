import { folderList } from '../../../componets/dataList/folderList'
import {novelPageList} from '../../../viewData/bookData'
/**
 * 文件夹
 */
@Component
export default struct BookFolder {
  build() {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
      ForEach(novelPageList, (item: folderList,index:number) => {
        this.bookInfoGrid(item.title,item.bookImage,item.countNumber)
      })
    }
  }


  @Builder bookInfoGrid(title:string,bookImage:Resource,countNumer:number){
    Column({
      space:5
    }) {
      Column(){
        Column(){
          Stack(){
            Column(){

            }
            .width(88).height(120)
            .backgroundImage(bookImage)
            .backgroundImageSize({width:88,height:120})
            .zIndex(2)

            Row(){
              Image($r('app.media.occlusion1'))
            }
            .zIndex(1)
            .width(95).height(110)

            Row(){
              Image($r('app.media.occlusion2'))
            }.zIndex(0)
            .width(100).height(100)
          }
          .align(Alignment.BottomStart)
        }

        Row().width(100).height(20).backgroundColor('rgba(255, 255, 255, 0.6)').borderRadius(10)
      }
      Text(title)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)
      Text(`共${countNumer}本`).fontSize(12).fontColor('rgb(174,174,174)')
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .fontWeight(500)
        .maxLines(1)
    }
    .alignItems(HorizontalAlign.Start)
    .width('33%')
    .padding({ left:8,right:8,bottom:5,top:5 })
    .backgroundColor('rgba(244,244,244,0.8)')
  }
}