import IndexSubscription from './Subscription/IndexSubscription'

@Component
export default struct Subscription {
  @State subscription: string = '订阅源'
  build(){
    Column(){
      Blank(20)
      IndexSubscription()

    }
    .backgroundColor('F3F4F8')
    // .border({
    //   width:1,
    //   color:Color.Blue
    // })
  }
}