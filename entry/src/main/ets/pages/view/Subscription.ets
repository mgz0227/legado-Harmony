
@Component
export default struct Subscription {
  @State subscription: string = '订阅源'
  build(){
    Column(){
      Text(this.subscription)
    }
  }
}