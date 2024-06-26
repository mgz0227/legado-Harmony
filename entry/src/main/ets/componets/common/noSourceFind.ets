/**
 * @author 2008
 * @datetime 2024/6/26 23:47
 * @className: noSourceFind
 * 公用无发现功能log
 */
import CommonConstants from '../../common/constants/CommonConstants'

@Component
export default struct noSourceFind {

  setOnclick:() => void = () => {

  }
  build() {
    Column(){
        Image($r('app.media.icon_no_source_find')).width(124).height(120)
          .margin({top:150,bottom:32})
        Text('该书源暂无发现功能，请切换至其他书源吧，点击下方按钮一键隐藏所有暂无发现功能书源')
          .width(280)
          .font({
            size:14,
            weight:400,
            family:CommonConstants.FAMILY_PingFANG
          })
          .margin({bottom:24})
      Button('一键隐藏').backgroundColor($r('app.color.theme_color'))
        .onClick(()=>{
          this.setOnclick()
        })
    }
  }
}