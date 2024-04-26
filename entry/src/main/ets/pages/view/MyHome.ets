@Component
export default struct MyHome {
  @State myHome: string = '我的'
  build(){
    Column(){
      Text(this.myHome)
    }
  }

}