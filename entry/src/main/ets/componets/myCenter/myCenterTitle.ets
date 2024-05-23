import { router } from '@kit.ArkUI'
import CommonConstants from '../../common/constants/CommonConstants'

@Component
export struct MyCenterTitle{

  @Prop title:string

  // 是否显示编辑按钮
  isShowEdit?:boolean = false
  // 是否显示菜单
  isShowMore?:boolean = false

  // 编辑标题按钮事件
  onEditClickEvent?: (event: ClickEvent) => void
  // 更多菜单按钮
  onMoreClickEvent?: (event: ClickEvent) => void

  @StorageProp('topRectHeight') topRectHeight: number = 0

  // 重构 我的中心标题栏
  build() {
    Column(){
      // 如果同步状态栏高度不成功，默认40
      Blank(this.topRectHeight == 0 ? 40 : this.topRectHeight)

      Row(){
        Image($r("app.media.return_left"))
          .size({width:CommonConstants.TITLE_IMG_SIZE,height:CommonConstants.TITLE_IMG_SIZE})
          .onClick(()=>{
            router.back()
          })

        Row(){
          Row(){
            if (this.isShowEdit){
              // 左占位
              Blank(CommonConstants.TITLE_IMG_SIZE)
                .margin({right: 8})
            }

            // 标题
            Text(this.title).fontSize(16).fontWeight(600).lineHeight(24)
              .textAlign(TextAlign.Center)

            // 修改标题的 笔图标
            if (this.isShowEdit){
              Image($r("app.media.ic_public_edit"))
                .size({width:CommonConstants.TITLE_IMG_SIZE,height:CommonConstants.TITLE_IMG_SIZE})
                .margin({left: 8})
                .onClick(this.onEditClickEvent)
            }
          }
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1) // 占满剩余空间

        // 修改标题的 菜单标
        if (this.isShowMore){
          Image($r("app.media.more_vertical"))
            .size({width:CommonConstants.TITLE_IMG_SIZE,height:CommonConstants.TITLE_IMG_SIZE})
            .onClick(this.onMoreClickEvent)
        }else { // 占位，保持标题居中
          Blank(CommonConstants.TITLE_IMG_SIZE)
        }
      }
      // 固定高度不能适配所有设备，应该100%，主轴居中显示
      .width("100%").justifyContent(FlexAlign.Center).padding({top:12,bottom:12})
      //.width(320).justifyContent(FlexAlign.Start).padding({top:12,bottom:12})
    }
  }
}