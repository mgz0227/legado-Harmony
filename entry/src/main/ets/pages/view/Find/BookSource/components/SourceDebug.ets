@Component
export  default struct SourceDebug {
  @State searchValue: string = ''
  @State isDebug: boolean = false

  build() {
    Stack() {
      // 搜索页面
      Scroll() {
        Column() {
          // 搜索框
          Row() {
            Search({
              value: this.searchValue,
              placeholder: `搜索书名或作者`,
              icon: "/common/images/search.svg"
            })
              .width("100%")
              .height(40)
              .onChange((value: string) => {
                this.searchValue = value
                this.isDebug = true
              })
              .onSubmit(() => {
                this.isDebug = true
              })
          }
          .padding({
            left: 20,
            right: 20,
            top: 8,
          })

          Column(){
            Text('内容提示')
          }
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .translate({x: this.isDebug ? -500 : 0})
      .animation({
        duration: 500
      })

      // 调试页面
      Scroll() {
        Column(){
          // 搜索框
          Row() {
            Search({
              value: this.searchValue,
              placeholder: `搜索书名或作者`,
              icon: "/common/images/search.svg"
            })
              .width("100%")
              .height(40)
              .onChange((value: string) => {
                this.searchValue = value
                this.isDebug = true
              })
              .onSubmit(() => {
                this.isDebug = true
              })
          }
          .padding({
            left: 20,
            right: 20,
            top: 8,
          })

          Column() {
            Text('调试页面')
            Button('返回').onClick(() => {
              this.isDebug = false
            })
          }
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .translate({x: this.isDebug ? 0 : 500})
      .animation({
        duration: 500
      })
    }
    .alignContent(Alignment.Top)
  }
}