/**
 * @author 2008
 * @datetime 2024/7/14 21:54
 * @className: BookFind
 * 发现公用书籍展示组件
 */
import noFind from '../../../../componets/common/noFind'
import mayAlsoLike from '../mayAlsoLike'

@Component
export default struct BookFindContent{
  @Prop currentIndex:number
  @Prop sourceType: string
  build() {
    Column({
      space:16
    }){
      Column(){
        mayAlsoLike({
          mayAlsoLike:'畅销精选'
        })
        Text(JSON.stringify(this.currentIndex))
        Text(this.sourceType)
        noFind().padding({
          top:75
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)
    }
  }
}