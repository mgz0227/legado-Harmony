/**
 * 新建书单
 */
import confirmDialogExample from '../../../../../componets/common/confirmDialog'
import { BookList } from '../../../../../componets/dataList/bookList'

@Component
export default struct newBookShelf{
  @Link showNumber:number
  @Link isAddShelfShow:boolean
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @Link addCheckShelf:BookList[]
  @State TextValue:string = ''
  @State deByBookId:string = ''
  @State delCache:boolean = false
  @Prop topIsShow:boolean = true
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      delCache:this.delCache
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  onCancel() {
    // this.isClear = false
  }

  onAccept() {
    this.deleteBookShelf()
  }

  deleteBookShelf() {
    this.addCheckShelf=this.addCheckShelf.filter((item:BookList)=>{
      return item.bookId!=this.deByBookId
    })
  }

  exitApp() {
    // this.isClear = false
  }

  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }
    ){
     Column(){
       if (this.topIsShow){
         Blank(this.topRectHeight)
       }
       Column({
         space:24
       }) {
         Flex({
           alignItems:ItemAlign.Center,
           justifyContent:FlexAlign.Center
         }){
           Image($r('app.media.close'))
             .width(25)
             .height(25)
             .fillColor('rgba(0, 0, 0, 0.88)')
             .onClick(()=>{
               // this.isAddShelfShow=true
               this.showNumber=0
             })
           Column(){
             Text('新建书单').fontSize(16).lineHeight(24).fontWeight(500).textAlign(TextAlign.Center).fontColor('rgba(0, 0, 0, 0.88)')
           }.margin({right:20}).width('100%')
         }
         Flex({
           direction:FlexDirection.Column,
           justifyContent:FlexAlign.SpaceBetween
         }){
           Column(){
             Text('冷门好书，不容错过').fontSize(16).fontWeight(500).lineHeight(26).fontColor('rgba(0, 0, 0, 0.88)')
             Text('有些书，不搞宣传，不搞推荐，默默的写完一本，然后掩埋在书海里无人问津，只待有缘人发现')
               .fontSize(14).fontWeight(500).lineHeight(26).fontColor('rgba(0, 0, 0, 0.88)')
               .margin({top:12})
              Scroll(){
                Column(){
                  ForEach(this.addCheckShelf,(item:BookList)=>{
                    this.BookShelfInfo(item)
                  })
                }
              }
              .align(Alignment.TopStart)
              .scrollBar(BarState.Off)
              .height('78%')
           }
           .alignItems(HorizontalAlign.Start)
         }
       }
       .padding({left:20,right:20,top:12,bottom:12})
       .align(Alignment.Center)
     }

      Divider().strokeWidth(0.5)
      Flex({
        justifyContent:FlexAlign.Center
      }){
        this.newFooter()
      }.padding({bottom:this.bottomRectHeight}).backgroundColor(Color.White)
    }

  }
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @Builder newFooter(){
    Row({
      space:20
    }) {
      Flex({
        justifyContent:FlexAlign.Center,
        alignItems:ItemAlign.Center
      }){
       Row({
         space:5
       }){
         Image($r('app.media.add_new_fill')).width(20).height(20)
         Text('添加书籍').fontSize(16).fontWeight(500).fontColor('rgba(0, 0, 0, 0.45)').textAlign(TextAlign.Center)
       }
      }
      .width('40%')
      .height(38)
      .borderRadius(20)
      .backgroundColor('rgba(0, 0, 0, 0.04)')
      .onClick(()=>{
        this.showNumber=2
      })
      Flex({
        justifyContent:FlexAlign.Center,
        alignItems:ItemAlign.Center
      }){
        Text('确定').fontSize(16).fontWeight(500).fontColor(Color.White)
      }
      .borderRadius(20)
      .width('50%')
      .height(38)
      .backgroundColor(this.TextValue.length>=1?$r('app.color.theme_color'):'rgba(252, 102, 0, 0.5)')
    }.padding({top:12,bottom:12,left:20,right:20})
  }

  @Builder BookShelfInfo(book:BookList){
    Column() {
      Row({
        space: 12
      }) {
        Flex({
          alignItems: ItemAlign.End,
        }) {
          // if (this.bookData.isTop) {
          //   Text('置顶')
          //     .fontColor(Color.White)
          //     .fontWeight(300)
          //     .fontSize(8)
          //     .padding(3)
          //     .borderRadius(5)
          //     .backgroundColor('rgba(0, 0, 0, 0.45)')
          // }
        }
        .align(Alignment.Bottom)
        .width(69)
        .height(92)
        .backgroundImage($r('app.media.shelf_book'))
        .backgroundImageSize({ width: 69, height: 92 })
        Column({
          space:5
        }) {
          Row(){
            Text(book.title).fontSize(16).fontWeight(500).lineHeight(24)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(1).width('70%')
            Image($r('app.media.close')).width(12).onClick(()=>{
              //根据bookId删除addCheckShelf
              this.deByBookId = book.bookId
              this.bookInfoDel?.open()
            })
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
            .maxLines(2).width('75%')
          Row({
            space:6
          }){
            Row(){
              Text('卖报小郎君').fontSize(10).fontWeight(400).fontColor($r('app.color.theme_color'))
            }
            .padding({left:6,right:6,top:5,bottom:5}).backgroundColor('rgba(255, 102, 0, 0.12)').borderRadius(10)
            Row(){
              Text('玄幻').fontSize(10).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
            }
            .fontStyles()
            Row(){
              Text('完本').fontSize(10).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
            }
            .fontStyles()
            Row(){
              Text('380万字').fontSize(10).fontWeight(400).fontColor('rgba(0, 0, 0, 0.45)')
            }.fontStyles()
          }
        }

        .alignItems(HorizontalAlign.Start)
      }.width('100%').padding(10)
      Column(){
        TextArea({placeholder:'添加推荐理由',text:$$this.TextValue}).padding(10).borderRadius(8)
      }.padding({top:12,bottom:5})
      if (this.TextValue.length >= 1){
        Flex({
          justifyContent:FlexAlign.End
        }){
          Text('清空').textAlign(TextAlign.End).fontColor($r('app.color.theme_color'))
        }.onClick(()=>{
          this.TextValue = ''
        })
      }
    }.padding({top:16})
  }
}
@Styles function fontStyles() {
  .padding({left:6,right:6,top:5,bottom:5})
  .backgroundColor('rgba(0, 0, 0, 0.06)')
  .borderRadius(10)
}