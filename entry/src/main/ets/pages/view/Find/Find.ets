import IndexFind from './IndexFind'

@ComponentV2
@Preview
export default struct Find {

  build(){
    Column(){
      IndexFind()
    }
    .backgroundColor($r('app.string.color_black_88'))
  }
}