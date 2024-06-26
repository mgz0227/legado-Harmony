/**
 * @author 2008
 * @datetime 2024/6/26 23:55
 * @className: RefreshComponent
 * 公用下拉刷新消息
 */
@Component
export default struct RefreshComponent{
  @Prop RefreshingTitle:string = '松开刷新'
  build() {
    Row() {
      if (this.RefreshingTitle !== '松开刷新') {
        LoadingProgress().height(30)
      }
      Text(this.RefreshingTitle).fontSize(16).margin({ left: 20 })
    }
  }
}