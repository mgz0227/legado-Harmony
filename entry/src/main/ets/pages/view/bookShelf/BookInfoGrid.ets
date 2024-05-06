import delDialogExample from '../../../componets/common/delDialog'
import router from '@ohos.router'
import { promptAction } from '@kit.ArkUI'

@Component
/**
 * 书签_宫格
 */
export default struct BookInfoGrid{
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


  build() {
    Column() {
      Column(){
        if (this.isShowCheck){
          Flex({
            alignItems: ItemAlign.End,
            justifyContent:FlexAlign.End
          }){
            Checkbox({
              name: this.title
            })
              .selectedColor($r('app.color.theme_color'))
              .unselectedColor('rgba(255, 255, 255, 0.6)')
          }
          .borderRadius(10)
          .backgroundColor(this.isShowCheck ?'rgba(0, 0, 0, 0.3)':'')
          .width(100).height(120)
        }
       /* if (this.searchValue === '浏览历史'){
          Flex({
            justifyContent:FlexAlign.SpaceBetween,
            alignItems: ItemAlign.End
          }){
            Row(){
              Row({space:5}){
                Image(this.isJoin?$r("app.media.add_check"):$r("app.media.add_shelf")).width(10).height(10)
                  .fillColor('rgb(255, 255, 255)')
                Text('书架').fontSize(8).fontColor('rgb(255, 255, 255)')
              }.padding({ left:8,right:8,bottom:5,top:5 })
            }
            .margin({bottom:3})
            .backgroundColor(this.isJoin?'rgba(255, 255, 255,0.5)':'')
            .borderColor('rgb(255, 255, 255)')
            .borderWidth(this.isJoin?0:1)
            .borderRadius(50)
            .onClick(()=>{
              this.isJoin = !this.isJoin
              promptAction.showToast({
                message: this.isJoin?'已加入书架':'已移出书架',
                duration: 1000,
              })
            })

            Image($r('app.media.delete_svg')).width(17).fillColor('rgb(255, 255, 255)')
              .margin({bottom:3})
              .onClick(()=>{
                if (this.bookInfoDel != null) {
                  this.bookInfoDel.open()
                }
              })
          }
          .padding({left:5,right:5})
          .borderRadius(10)
          .backgroundColor(this.searchValue === '浏览历史'?'rgba(0, 0, 0, 0.3)':'')
          .width(90).height(120)
        }*/
      }
      .borderRadius(10)
      .width(100).height(120)
      .backgroundImage(this.bookImage)
      .backgroundImageSize({width:100,height:120})
      Text(this.title)
        .fontSize(15)
        .fontWeight(700)
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .maxLines(2)
      //描述
      // Text(this.describe).fontSize(12).fontColor('rgb(174,174,174)')
      //   .textOverflow({
      //     overflow:TextOverflow.Ellipsis
      //   })
      //   .ellipsisMode(EllipsisMode.END)
      //   .fontWeight(500)
      //   .maxLines(1)
      Text(this.chapter).fontSize(12).fontColor('rgb(174,174,174)')
        .textOverflow({
          overflow:TextOverflow.Ellipsis
        })
        .ellipsisMode(EllipsisMode.END)
        .fontWeight(500)
        .maxLines(1)
    }
    .padding({ left:8,right:8,bottom:5,top:5 })
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
}