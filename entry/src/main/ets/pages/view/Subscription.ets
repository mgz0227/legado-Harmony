import IndexSubscription from './Subscription/IndexSubscription'
import SubscriptionIndex from './Subscription/SubscriptionIndex'

@Component
export default struct Subscription {
  @State subscription: string = '订阅源'
  @Prop currentTabIndex: number
  build(){
    Column(){
      SubscriptionIndex({
        currentTabIndex:this.currentTabIndex,
      })
    }
    .backgroundColor('F3F4F8')
  }
}