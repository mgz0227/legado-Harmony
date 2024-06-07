import { BookList } from '../../../../componets/dataList/bookList'
import { shelfList } from '../../../../componets/dataList/shelfList'
import { showMessage } from '../../../../componets/common/promptShow'
import shareShelfBook from '../../dialog/shareShelfBook'

@CustomDialog
@Preview
@Component
export default struct editBookShelf{
  controller?: CustomDialogController

  @StorageLink('topRectHeight') topRectHeight: number = 0
  @Prop shelf:shelfList
  @State TextValue:string = ''
  @State isShow:boolean = false
  cancel: () => void = () => {
  }

  editBookShelf(bookId:string) {
    console.log(bookId)
    for (let index = 0; index < this.shelf.bookList.length; index++) {
      if (this.shelf.bookList[index].bookId === bookId) {
        this.shelf.bookList[index].isJoin = !this.shelf.bookList[index].isJoin
      }
      console.log(JSON.stringify(this.shelf.bookList[index]))
    }
  }


  shareShelfBookDialog: CustomDialogController | null = new CustomDialogController({
    builder: shareShelfBook({
      shelf:this.shelf
    }),
    cancel: this.exitDialog,
    autoCancel: true,
    width:'100%',
    height:'100%',
    alignment: DialogAlignment.Bottom,
    customStyle:true
  })

  exitDialog(){
    this.shareShelfBookDialog?.close()
  }
  @State isEdit:boolean = false
  build() {
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Column
    }
    ){
     Column(){
       Blank(20)
       Column({
         space:24
       }) {
         if (this.isEdit){
           Flex({
             alignItems:ItemAlign.Center,
             justifyContent:FlexAlign.Center
           }){
             Image($r('app.media.close'))
               .width(25)
               .height(25)
               .fillColor('rgba(0, 0, 0, 0.88)')
               .onClick(()=>{
                 this.isEdit=false
               })
             Column(){
               Text('编辑书单').fontSize(16).lineHeight(24).fontWeight(500).textAlign(TextAlign.Center).fontColor('rgba(0, 0, 0, 0.88)')
             }.margin({right:20}).width('100%')
           }
         } else {
           Flex({
             alignItems:ItemAlign.Center,
             justifyContent:FlexAlign.SpaceBetween
           }){
             Image($r('app.media.return_left'))
               .width(25)
               .height(25)
               .fillColor('rgba(0, 0, 0, 0.88)')
               .onClick(()=>{
                 this.controller?.close()
                 this.cancel()
                 // this.isAddShelfShow=true
               })
             Row({
               space:24
             }){
               Image($r('app.media.edit_black')).width(25)
                 .onClick(()=>{
                   // this.controller?.open()
                   this.isEdit=true
                 })
               Image($r('app.media.edit_share')).width(25)
                 .onClick(()=>{
                   this.shareShelfBookDialog?.open()
                 })
             }.justifyContent(FlexAlign.Center)
           }
         }

         Flex({
           direction:FlexDirection.Column,
           justifyContent:FlexAlign.SpaceBetween
         }){
           Column(){
             Text(this.shelf.title).fontSize(16).fontWeight(500).lineHeight(26).fontColor('rgba(0, 0, 0, 0.88)')
             Text(this.shelf.describe)
               .fontSize(14).fontWeight(500).lineHeight(26).fontColor('rgba(0, 0, 0, 0.88)')
               .margin({top:12})
              Scroll(){
                Column(){
                  ForEach(this.shelf.bookList,(item:BookList,index:number)=>{
                    this.BookShelfInfo(item,index)
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
      if (this.isEdit){
        Divider().strokeWidth(0.5)
        Flex({
          justifyContent:FlexAlign.Center
        }){
          this.newFooter()
        }.padding({top:12,bottom:12})
      }
    }
    .backgroundColor(Color.White)
    .padding({bottom:this.bottomRectHeight})
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

  @Builder BookShelfInfo(book:BookList,index:number){
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
            Image(this.shelf.bookList[index].isJoin?$r('app.media.unadd_book_shelf'):$r('app.media.add_book_shelf')).width(20).onClick(()=>{
              if (!book.isJoin) {
                this.shelf.bookList[index].isJoin = !this.shelf.bookList[index].isJoin
                // this.editBookShelf(book.bookId)
                showMessage('已加入书架')
              }
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