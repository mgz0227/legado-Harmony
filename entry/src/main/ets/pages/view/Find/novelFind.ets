import noFind from '../../../componets/common/noFind'
import mayAlsoLike from './mayAlsoLike'

@Component
export default struct novelFind {
  build() {
    Column({
      space:16
    }){
      Flex({
        justifyContent:FlexAlign.Center,
        alignContent:FlexAlign.Center
      }){
        Column(){
          mayAlsoLike()
          Text('小说')
          noFind().padding({
            top:107
          })
        }
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Flex({
        justifyContent:FlexAlign.Center,
        alignContent:FlexAlign.Center
      }){
        Column(){
          mayAlsoLike()
          Text('小说')
          noFind().padding({
            top:107
          })
        }
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)

      Flex({
        justifyContent:FlexAlign.Center,
        alignContent:FlexAlign.Center
      }){
        Column(){
          mayAlsoLike()
          Text('小说')
          noFind().padding({
            top:107
          })
        }
      }
      .borderRadius(12)
      .backgroundColor(Color.White)
      .height(436)
    }
    .alignItems(HorizontalAlign.Center)
  }
}