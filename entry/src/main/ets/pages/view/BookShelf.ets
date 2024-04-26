import IndexTop from '../../componets/IndexShelf'

@Component
export default struct BookShelf {
  @State bookShelf: string = '书架'
  build(){
    Column(){
      IndexTop()
    }

    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .height('100%')
  }
}