/**
 * @author 2008
 * @datetime 2024/6/26 23:47
 * @className: noSourceFind
 * 公用暂无相关内容
 */
import CommonConstants from '../../common/constants/CommonConstants'

@Component
export default struct noFind {

  build() {
    Column(){
        Image($r('app.media.icon_no_source_find')).width(124).height(120)
          .margin({bottom:32})
        Text('暂无相关内容')
          .width(280)
          .font({
            size:14,
            weight:400,
            family:CommonConstants.FAMILY_PingFANG
          })
          .textAlign(TextAlign.Center)
          .margin({bottom:24})
    }
  }
}