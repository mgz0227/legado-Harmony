import delDialogExample from '../../../componets/common/delDialog'
import router from '@ohos.router'
import { MarginType, promptAction } from '@kit.ArkUI'
import { BookList } from '../../../componets/dataList/bookList'

@Component
/**
 * 书签
 */
export default struct BookInfo{
  //标题
  @Prop title:string
  //描述
  @Prop describe:string
  //章节
  @Prop chapter:string
  //图片
  @Prop bookImage:Resource

  @Prop searchValue:string

  @Prop isJoin:boolean

  @Prop isShowCheck:boolean

  @Prop allCheck:boolean = false

  @Link checkBookList:BookList[]

  onDelete: () => void = () => {

  }

  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: delDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() }
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    // offset: { dx: 0, dy: '-40%' },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25,
  })

  onCancel() {
    console.info('取消')
  }

  onAccept() {
    this.onDelete()
  }

  exitApp() {
    console.info('点外围取消')
  }

  inputBookList(){
    this.checkBookList.push(new BookList(this.title,this.describe,this.chapter,this.bookImage,this.isJoin))
    console.log(JSON.stringify(this.checkBookList))
  }

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
        Image(this.bookImage).width(60).height(80)
        Column({
          space:24
        })
        {
          Text(this.title)
            .fontWeight(700)
          Column(){
            Text(this.describe).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
            Text(this.chapter).fontSize(12).fontColor('rgb(174,174,174)')
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .fontWeight(500)
              .maxLines(1)
          }
          .width('40%')
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(HorizontalAlign.Start)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/view/BookDetailPage',
            params: {
              bookId: '1',
              bookName: '大奉打更人',
              bookAuthor: '卖报小郎君',
              bookImage: $r('app.media.cover_list'),
              bookDescribe: '《大奉打更人》（第一卷）实体书已在天猫、当当、京东等全平台，以及各个实体书店发售。 这个世界，有儒；有道；有佛；有妖；有术士。 警校毕业的许七安幽幽醒来，发现自己身处牢狱之中，三日后流放边陲..... '
            }
          })
        })
      }
      if (this.isShowCheck) {
        Row() {
          Checkbox({
            name: this.title
          })
            .selectedColor($r('app.color.theme_color'))
            .select(this.allCheck)
            .onClick(()=>{
              this.allCheck = !this.allCheck
              if (this.allCheck) {
                this.inputBookList()
              }
            })
        }
        .padding({ left: 15, right: 15, bottom: 5, top: 5 })
      }
      if (this.searchValue === '浏览历史'){
        Column({space:15}){
          Row(){
           Image($r('app.media.delete_svg')).width(17).fillColor('rgba(0, 0, 0, 0.6)')
          }
          .onClick(()=>{
            if (this.bookInfoDel != null) {
              this.bookInfoDel.open()
            }
          })
          .padding({right:5})
          Row(){
            Row({space:5}){
              Image(this.isJoin?$r("app.media.add_check"):$r("app.media.add_shelf")).width(this.isJoin?15:10).height(this.isJoin?15:10)
                .fillColor('rgba(0, 0, 0, 0.9)')
              Text('书架').fontSize(10).fontColor('rgba(0, 0, 0, 0.45)')
            }.padding({ left:15,right:15,bottom:5,top:5 })
          }
          .backgroundColor(this.isJoin?'rgba(174,174,174,0.2)':'')
          .borderColor('rgb(174,174,174)')
          .borderWidth(this.isJoin?0:1)
          .borderRadius(50)
          .onClick(()=>{
            this.isJoin = !this.isJoin
            promptAction.showToast({
              message: this.isJoin?'已加入书架':'已移出书架',
              duration: 1000,
            })
          })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.End)
      }
    }
    .padding(10)
    .borderRadius(10)
  }
}