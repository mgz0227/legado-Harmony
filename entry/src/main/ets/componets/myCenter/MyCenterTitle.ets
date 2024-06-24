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
  // onMoreClickEvent?: (event: ClickEvent) => void
  // @State onSelect: number = 0
  @StorageLink("onSelect") onSelect: number = 0

  // @BuilderParam menu?: ()=> void

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
                .size({width: 16,height: 16})
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
            //.onClick(this.onMoreClickEvent)
            .bindMenu(this.menu)
        }else { // 占位，保持标题居中
          Blank(CommonConstants.TITLE_IMG_SIZE)
        }
      }
      // 固定高度不能适配所有设备，应该100%，主轴居中显示
      .width("100%").justifyContent(FlexAlign.Center).padding({top:12,bottom:12})
      //.width(320).justifyContent(FlexAlign.Start).padding({top:12,bottom:12})
    }
  }

  @Builder menu(){
    Column(){
      // TODO 菜单现在不支持自定义形状
      // Image($r("app.media.ic_menu_triangle"))
      //   .width(18)
      //   .height(8)
      Menu() {
        MenuItemGroup() {
          MenuItem(this.menuItemUi("按时间排序", 0))
          MenuItem(this.menuItemUi("按名称排序", 1))
          MenuItem(this.menuItemUi("按大小排序", 2))
        }
        MenuItem(this.logout())
      }
      .radius(12)
    }
  }

  @Builder menuItemUi(text: string, index: number){
    Row(){
      Row(){
        Text(text)
          .font({size: 16, weight: 400})
          .fontColor(index === this.onSelect ? "#FF6600" : "#000000")
          .height(22)
        if (this.onSelect === index){
          Image($r("app.media.ic_select"))
            .height(20)
            .width(20)
            .margin({left: 8})
        }else {
          Blank(20)
            .margin({left: 8})
        }
      }
      .alignItems(VerticalAlign.Center)
    }
    .padding({left: 20, right: 20, top: 12, bottom: 12})
    .height(46)
    .onClick(()=>{
      this.onSelect = index
    })
  }

  @Builder logout(){
    Row(){
      Row(){
        Image($r("app.media.ic_logout"))
          .height(20)
          .width(20)
          .margin({right: 8})
        Text("退出登录")
          .font({size: 16, weight: 400})
          .fontColor("#EF4444")
          .height(22)
      }
      .alignItems(VerticalAlign.Center)
    }
    .padding({left: 20, right: 20, top: 12, bottom: 12})
    .height(46)
  }
}