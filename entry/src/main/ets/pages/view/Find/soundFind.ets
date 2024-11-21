import noFind from '../../../componets/common/noFind'
import mayAlsoLike from './mayAlsoLike'

@Component
export default struct soundFind {
  build() {
    Column({
      space:16
    }){
      Column(){
        mayAlsoLike()
        Text('发现有声书')
        noFind().padding({
          top:107
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Column(){
        mayAlsoLike()
        Text('发现有声书')
        noFind().padding({
          top:107
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Column(){
        mayAlsoLike()
        Text('发现有声书')
        noFind().padding({
          top:107
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)
    }
    .alignItems(HorizontalAlign.Center)
  }
}