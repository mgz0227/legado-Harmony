@Component
export default struct IndexSearchType {
  @Prop title:string
  @Prop searchValue:string

  build() {
    Row(
      {
        space:3
      }
    ) {
      Text(this.title)
        .fontColor(this.searchValue === this.title ? 'rgba(0, 0, 0, 1.00)' :  'rgba(0,0,0,0.5)')
        .fontSize(15)
        .fontWeight(this.searchValue === this.title ? 600 : 400)
      if (this.title === this.searchValue){
        Image($r('app.media.direction_down')).width(15).height(15)
      }
    }
  }
}