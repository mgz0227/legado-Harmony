import BookOverlay from '../../../componets/bookDetail/BookOverlay'
import { folderList } from '../../../componets/dataList/folderList'
import {novelPageList} from '../../../viewData/bookData'
import BookFolderGridManage from './Manage/bookManage/BookFolderGridManage'
import BookFolderInfoManage from './Manage/bookManage/BookFolderInfoManage'

/**
 * 文件夹
 */
@Component
export default struct BookFolder {
  @Prop EXHIBIT:string
  @State folderCheckList:folderList[] = []
  build() {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap,alignContent:FlexAlign.Center}){
      ForEach(novelPageList, (item: folderList,index:number) => {
        if (this.EXHIBIT === '宫格'){
          this.bookInfoGrid(item.title,item.bookImage,item.countNumber)
        } else {
          ForEach(novelPageList, (item: folderList,index:number) => {
            this.bookFolderInfo(item)
          })
        }
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

  @Builder bookFolderInfo(folderList:folderList){
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
          bookImage:folderList.bookImage,
          bookWidth:60,
          bookHeight:80,
          isTop:folderList.isTop
        })
        Column({
          space:24
        })
        {
          Text(folderList.title)
            .fontWeight(700)
          Column(){
            Text(`共${folderList.countNumber}本`).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(400)
              .maxLines(1)
              .lineHeight(20)
            Text(folderList.newUpdateBook?folderList.newUpdateBook:'暂无更新')
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
    }
    .padding(10)
    .borderRadius(10)
  }
}