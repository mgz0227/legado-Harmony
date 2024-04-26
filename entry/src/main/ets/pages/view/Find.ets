
@Component
export default struct Find {
  @State find: string = '发现'
  build(){
    Column(){
      Text(this.find)
    }
  }
}