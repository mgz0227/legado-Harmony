import router from '@ohos.router'; // 引入路由管理器

@Component
export default struct IndexSubscription {
  @State SearchValue: string = ""

  build() {
    Column() {
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceEvenly
        }
      ) {
        Row({ space: 20 }) {
          Text("订阅")
          Search({ value: this.SearchValue, placeholder: '搜索订阅', icon: "/common/images/search.svg" })
            .width("60%")
            .height(40)
          // .onChange(this.onChange)
          // .onSubmit(this.onSubmit);
          Image($r('app.media.addSubscription')).width(24).onClick(() => {

          })
        }
      }

      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceEvenly
        }
      ) {
        Column() {
          Row({ space: 20 }) {
            Text("小说")
            Blank(1)
            Image($r('app.media.more_sub')).width(24).onClick(() => {

            })
          }
          .width("88%")

          Row({ space: 20 }) {
            Button(){
              Row({ space: 12 }){
                // Ellipse图片临时用，修改后记得删除
                Image($r('app.media.Ellipse'))
                  .width(30)
                  .height(30)
                Text("起点中文网")
              }
            }
              .type(ButtonType.Normal)
              .backgroundColor("#FFFFFF")
              .width("46%")
              .height(54)
              .border({
                radius: 12
              })
            Button(){
              Row({ space: 12 }){
                Image($r('app.media.addURL'))
                  .width(30)
                  .height(30)
                Text("添加网址")
                  .fontColor("#000000")
                  .opacity(0.45)
              }
            }
              .type(ButtonType.Normal)
              .backgroundColor("#FFFFFF")
              .width("46%")
              .height(54)
              .border({
                radius: 12
              })
          }
          .width("88%")
        }
      }
    }
  }
}