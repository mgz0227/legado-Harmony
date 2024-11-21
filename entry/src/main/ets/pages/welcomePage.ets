import CommonConstants from '../common/constants/CommonConstants';
import router from '@ohos.router'; // 引入路由管理器
import { initAppData } from '../storage/appData';

@Entry
@Component
struct Index {
  @State name: string = '开源阅读'
  @State Tip: string = '享受阅读时光'
  onPageShow() {
    initAppData()
    setTimeout(() => {
      // 使用路由管理器跳转到主页面
      router.pushUrl({
        url: 'pages/Index' // 主页面的URI
      });
    }, 1500); // 1000毫秒 = 1秒
  }
  onPageHide() {
    {
      router.clear();
    }
  }
  build() {
    Stack() {
      Image($r('app.media.ic_launcher_background'))
        .width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.FULL_HEIGHT)

      Column() {
        Row() {
          Text(this.name)
            .fontSize(45)
            .fontWeight(FontWeight.Bold)
            .width(45)
          Text(this.Tip)
            .fontSize(20)
            .fontWeight(FontWeight.Normal)
            .width(25)
            .markAnchor({ x: -20, y: -80 })
        }

      }
      .width('100%')
    }
    .height('100%')
  }

}