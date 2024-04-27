import ReadShow from '../../componets/common/ReadShow'
import IndexShelf from '../../componets/IndexShelf'

@Component
export default struct BookShelf {
  @State bookShelf: string = '书架'
  @State showReadShow:boolean = true
  //第一次打开页面过五秒把showReadShow改为false不是在Entry下

  build(){
    Column(){
      IndexShelf()
      Column() {
        if (this.showReadShow){
          ReadShow({showReadShow:this.showReadShow})
        }
        //显示五秒后隐藏


      }
      .padding(10)
      .justifyContent(FlexAlign.Center)
    }

    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .height('100%')
  }
}