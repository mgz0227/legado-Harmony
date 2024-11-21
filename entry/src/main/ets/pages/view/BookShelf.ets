import ReadShow from '../../componets/common/ReadShow'
import IndexShelf from './bookShelf/IndexShelf'

@Component
export default struct BookShelf {
  @State bookShelf: string = '书架'
  build(){
    Column(){
      IndexShelf()
    }
    .backgroundColor('rgba(255, 255, 255, 0.8)')
  }
}