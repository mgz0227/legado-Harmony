import { showMessage } from '../common/promptShow'
import sourceType from '../common/sourceType'
import BookType from '../head/BookType'
import SourceCommon from '../source/SourceCommon'
import groupTypePanel from './groupTypePanel'

@Component
export default struct FindGroupSource {
  sourceList: string[] = ['起点', '飞卢', '纵横', '番茄', '17K小说网']
  @State sourceType: string = this.sourceList[0]
  @State isShowDialog: boolean = false
  build() {
    Flex(
      {
        alignContent: FlexAlign.Center,
        alignItems: ItemAlign.Center,
        justifyContent:FlexAlign.SpaceBetween
      }
    ) {
      Scroll() {
        Row({ space: 20 }) {
          ForEach(this.sourceList,(item:string)=>{
            sourceType({
              title:item,
              sourceType:this.sourceType
            })
              .onClick(()=>{
                this.sourceType = item
              })
          })
        }.margin({top:5})
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)

      Row() {
        Image($r('app.media.more_search')).width(24).height(24)
      }.width(
        '10%'
      )
      .onClick(()=>{
        this.isShowDialog = true
      })
      .bindSheet(this.isShowDialog,this.sourceCommon(),{
        detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
        dragBar: true,
        showClose:false,
        onDisappear:()=>{
          this.isShowDialog = false
        }
      })
    }
    .margin({ left: 15 })
  }

  @Builder sourceCommon(){
    Column(){
      SourceCommon()
    }.height('100%')
  }
}