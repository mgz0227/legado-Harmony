/**
 * @author 惟草木之零落兮
 * @date 2024/5/22 15:05
 */

@Preview
@Component
export default struct MyCenterFileSearch{


    @State @Watch("searchEvent") searchValue: string = ''

    // 回调函数，回调搜索框输入的值
    onResultCallBack?: (searchValue: string)=> void

    controller: SearchController = new SearchController()

    build() {
        Row(){
            Search({ value: this.searchValue, placeholder: '搜索', controller: this.controller })
                .width('100%')
                .height(34)
                .placeholderColor("rgba(0, 0, 0, 0.45)")
                .placeholderFont({ size: 14, weight: 400 })
                .textFont({ size: 14, weight: 400 })
                .onSubmit((value: string) => {
                    this.searchValue = value
                })
                .onChange((value: string) => {
                    this.searchValue = value
                })
                .padding({left: 16, right: 16, top: 6, bottom: 6})
                .backgroundColor("rgba(0, 0, 0, 0.04)")
        }
        .margin({top: 8, bottom: 8})
        .width("100%")
        .height(34)
    }

    // 搜索框值发生变化触发该函数
    searchEvent(){
        if (this.onResultCallBack) this.onResultCallBack(this.searchValue)
    }
}