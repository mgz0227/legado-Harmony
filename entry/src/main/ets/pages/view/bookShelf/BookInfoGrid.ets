import confirmDialogExample from '../../../componets/common/confirmDialog'
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

  onDelete: () => void = () => {

  }

  //弹窗
  bookInfoDel: CustomDialogController | null = new CustomDialogController({
    builder: confirmDialogExample({
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