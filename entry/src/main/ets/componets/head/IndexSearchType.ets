@Component
export default struct IndexSearchType {
  @Prop title:string
  @Link searchValue:string
  @State isShown: boolean = false

  @State THEME_NAME: string[] = ['最近阅读', '阅读排序', '更新排序', '手动排序']
  // @State THEME_NAMES: string[] = []

  build() {
    if (this.THEME_NAME.includes(this.title)){
      Row(
        {
          space:3
        }
      ) {
        Text(this.title)
          .fontColor(this.searchValue === this.title ? 'rgba(0, 0, 0, 1.00)' :  'rgba(0,0,0,0.5)')
          .fontSize(15)
          .fontWeight(this.searchValue === this.title ? 600 : 400)
        Image(this.isShown?$r('app.media.direction_upper'):$r('app.media.direction_down'))
          .width(15).height(15)
          .opacity(this.title === this.searchValue?1:0.3)
      }
      .onClick(()=>{
        this.searchValue = this.title
        this.isShown = !this.isShown
      })
      .bindMenu(this.isShown, this.MenuBuilder,
        {
          onDisappear: ()=>{
            this.isShown = false;
          }
        })
    } else {
      Row(
        {
          space:3
        }
      ) {
        Text(this.title)
          .fontColor(this.searchValue === this.title ? 'rgba(0, 0, 0, 1.00)' :  'rgba(0,0,0,0.5)')
          .fontSize(15)
          .fontWeight(this.searchValue === this.title ? 600 : 400)
      }
    }

  }

  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      ForEach(this.THEME_NAME, (item:string, index) => {
        if (item !== this.searchValue){
          Column() {
            Row() {
              Text(item).fontSize(15)
            }
            .width('100%')
            .height(30)
            .justifyContent(FlexAlign.Center)
            .align(Alignment.Center)
            .onClick(() => {
              this.title = item
              this.searchValue = item
              // this.THEME_NAMES = this.THEME_NAME.filter((value) => {
              //   return value !== item;
              // })
            })
            if (index != this.THEME_NAME.length - 1) {
              Divider().height(10).width('80%').color('#ccc')
            }
          }
        }

      })
    }.width(150)
  }
}