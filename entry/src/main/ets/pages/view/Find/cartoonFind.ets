import noFind from '../../../componets/common/noFind'
import mayAlsoLike from './mayAlsoLike'

@Component
export default struct cartoonFind {
  build() {
    Column({
      space:16
    }){
      Column(){
        mayAlsoLike()
        Text('漫画')
        noFind({
          hintIndex:1
        }).padding({
          top:75
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Column(){
        mayAlsoLike()
        Text('漫画')
        noFind().padding({
          top:75
        })
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Column(){
        mayAlsoLike()
        Text('漫画')
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