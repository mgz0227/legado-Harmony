/**
 * @author 2008
 * @datetime 2024/5/23 22:21
 * @className: shareShelfBook
 */
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { BookList } from '../../../componets/dataList/bookList'
import { buttonList } from '../../../componets/dataList/buttonList'
import { shelfList } from '../../../componets/dataList/shelfList'

@CustomDialog
@Preview
export default struct shareShelfBook{
  controller?: CustomDialogController
  @Prop shelf:shelfList
  @State buttonListInfo:buttonList[] = [
    new buttonList(1,'微信',$r('app.media.wechat')),
    new buttonList(2,'QQ',$r('app.media.QQ_blue')),
    new buttonList(3,'朋友圈',$r('app.media.circle_friends')),
    new buttonList(4,'QQ空间',$r('app.media.QQ_space')),
    new buttonList(5,'导出本地',$r('app.media.export')),
    new buttonList(6,'复制链接',$r('app.media.copy_link')),
    new buttonList(7,'保存图片',$r('app.media.save_img')),
    new buttonList(8,'系统分享',$r('app.media.more'))
  ]

  build() {
    Stack(){
      Rect().height('100%').width('100%').backgroundColor(Color.Black).onClick(()=>{
        this.controller?.close()
      })
        .opacity(0.15)
        .zIndex(1)
      Flex({
        direction:FlexDirection.Column,
        justifyContent:FlexAlign.SpaceBetween
      }){
        Column(){
          Text(this.shelf.title)
            .textAlign(TextAlign.Center)
            .fontSize(16).fontWeight(500).lineHeight(24).fontColor($r('app.string.color_black_88'))
          Text(this.shelf.describe)
            .textAlign(TextAlign.Center)
            .fontSize(12).fontWeight(400).lineHeight(20).fontColor($r('app.string.color_black_88'))
            .margin({top:12})
          Column(){
            ForEach(this.shelf.bookList,(item:BookList,index:number)=>{
              this.BookShelfInfo(item,index)
            })
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin(40)
      .padding({top:24,left:20,right:20})
      .width('80%')
      .height('90%')
      .backgroundColor(Color.White)
      .zIndex(2)

      Column(){
        Column(){
          Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
        }
        .padding({top:12,bottom:28})
        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
          justifyContent:FlexAlign.Start
        }){
          ForEach(this.buttonListInfo,(item:buttonList)=>{
            InsideCircleIcon({
              item:item
            })
          })
        }
        Column(){
          this.footerTitle()
        }
        .borderRadius(8)
        .margin({ left:20,right:20,bottom:20 })
        .backgroundColor($r('app.color.share_shelf_book_background'))
      }
      .zIndex(3)
      .borderRadius({topLeft:20,topRight:20})
      .backgroundColor(Color.White)
    }
    .align(Alignment.Bottom)
  }
  @State validDate:string = '7天有效'
  @Builder footerTitle(){
    Flex({
      direction:FlexDirection.Row,
      justifyContent:FlexAlign.SpaceBetween

    }){
      Text('链接有效期').fontColor($r('app.string.color_black_88')).fontSize(12).fontWeight(400).lineHeight(20).textAlign(TextAlign.Center)
      Row({
        space:8
      }){
        Text(this.validDate).fontColor($r('app.string.color_black_45')).fontSize(12).fontWeight(400)
        Image($r('app.media.icon_right')).width(24).height(24).fillColor(($r('app.string.color_black_45')))
      }
    }
    .padding(16)
  }

  @Builder BookShelfInfo(book:BookList,index:number){
    Flex({
      direction:FlexDirection.Column
    }) {
      Row({
        space: 12
      }) {
        Image($r('app.media.shelf_book'))
        .width(69)
        .height(92)

        Column({
          space:5
        }) {
          Row(){
            Text(book.title).fontSize(16).fontWeight(500).lineHeight(24)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(2)
          }
          Text(book.describe)
            .fontSize(12)
            .lineHeight(20)
            .fontColor('rgba(0, 0, 0, 0.45)')
            .textOverflow({
              overflow:TextOverflow.Ellipsis
            })
            .height(50)
            .ellipsisMode(EllipsisMode.END)
            .maxLines(2)
          Row({
            space:2
          }){
            Text('卖报小郎君·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('玄幻·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('完本·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('380万字').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      Column(){
        TextArea({placeholder:'添加推荐理由',text:book.describe})
          .padding(10).borderRadius(8)
      }.padding({top:12,bottom:5})
    }
    .align(Alignment.Start)
    .padding({top:16})
  }
}
@Styles function fontStyles() {
  .padding({left:6,right:6,top:5,bottom:5})
  .backgroundColor('rgba(0, 0, 0, 0.06)')
  .borderRadius(10)
}