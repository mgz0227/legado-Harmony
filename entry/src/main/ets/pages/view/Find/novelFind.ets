import noFind from '../../../componets/common/noFind'
import mayAlsoLike from './mayAlsoLike'

@Component
export default struct novelFind {
  build() {
    Column({
      space:16
    }){
      Column(){
        mayAlsoLike({
          mayAlsoLike:'畅销精选'
        })
        Text('小说')
        noFind().padding({
          top:75
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Column(){
        mayAlsoLike()
        Text('小说')
        noFind().padding({
          top:75
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Column(){
        mayAlsoLike()
        Text('小说')
        noFind().padding({
          top:75
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)
    }
    .alignItems(HorizontalAlign.Center)
  }
}