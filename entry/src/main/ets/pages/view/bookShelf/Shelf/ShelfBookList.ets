import { shelfList } from '../../../../componets/dataList/shelfList'
import BookShelfGrid from './BookShelfGrid'
import BookShelfInfo from './BookShelfInfo'

/**
 * 书单
 */
@Component
export default struct ShelfBookList {
  @Prop EXHIBIT: string
  @StorageProp('SHELF_LIST_DATA')
  shelfBookList: shelfList[] = []
  @State checkBookShelf: shelfList[] = []
  @Prop changeTop:boolean
  @Prop allCheck:boolean
  @Prop isShowCheck:boolean = false
  aboutToAppear(): void {
    console.log(JSON.stringify(this.shelfBookList))
  }
  build() {
    Column(){
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Center }) {
        ForEach(this.shelfBookList, (item: shelfList, index: number) => {

          if (this.EXHIBIT === '宫格') {
            BookShelfGrid({
              allCheck: this.allCheck,
              bookShelf:item,
              checkBookShelf:this.checkBookShelf,
              changeTop:this.changeTop,
              isShowCheck:this.isShowCheck
            }).width('33%')
          } else {
            BookShelfInfo({
              allCheck: this.allCheck,
              bookShelf:item,
              checkBookShelf:this.checkBookShelf,
              changeTop:this.changeTop,
              isShowCheck:this.isShowCheck
            })
          }
        })
      }
    }
  }
}