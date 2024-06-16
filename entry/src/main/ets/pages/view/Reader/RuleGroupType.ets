import BookType from '../../../componets/head/BookType'
import RuleGroupTypePanel from './RuleGroupTypePanel'

@Component
export default struct RuleGroupType {
  @State globalPositionY: Length = 0
  @Link coverShow:boolean
  @State ruleType:string = '全部'
  @State ruleList:Array<string> = ['全部','标题','标点','去广告','排版','格式','未分组']

  build() {
    if (this.coverShow){
      Stack(){
        RuleGroupTypePanel({
          groupCoverShow:this.coverShow,
          ruleList:this.ruleList
        }).zIndex(9999)
        Rect()
          // .fillOpacity(0)
          .height('90%')
          .width('100%')
          .fill('rgba(0, 0, 0, 0.45)')
          .offset({y:10})
      }.alignContent(Alignment.TopStart)
    } else {
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Scroll() {
          Row({ space: 10 }) {
            ForEach(this.ruleList,(item:string)=>{
              BookType({ title: item, bookType: this.ruleType }).onClick(() => {
                this.ruleType = item
              })
            })

          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
        Row(){
          Image($r('app.media.more_search')).width(25).height(25)
        }.width(
          '10%'
        ).onClick(()=>{
          this.coverShow = true
        })
      }
      .margin({ left: 20,right:20,bottom:10})
    }
  }
}