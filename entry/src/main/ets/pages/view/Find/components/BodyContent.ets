/**
 * @author 2008
 * @datetime 2024/7/14 19:57
 * @className: BodyContent
 */
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import noSourceFind from '../../../../componets/common/noSourceFind'
import RefreshComponent from '../../../../componets/common/RefreshComponent'
import sourceType from '../../../../componets/common/sourceType'
import SourceCommon from '../../../../componets/source/SourceCommon'
import BookFindContent from './BookFindContent'

@Component
export default struct BodyContent{
  sourceList: string[] = ['起点', '飞卢', '纵横', '番茄', '17K小说网']
  @State counter: number = 0
  @State sourceType: string = this.sourceList[0]
  @State isShowDialog: boolean = false
  @State isShowNoFind:boolean = true
  @State isRefreshing: boolean = false
  @Prop currentIndex:number
  tabsBodyController: TabsController = new TabsController();
  build() {
    Column(){
      Flex(
        {
          alignContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
          justifyContent:FlexAlign.SpaceBetween
        }
      ) {
        Scroll() {
          Row({ space: 20 }) {
            ForEach(this.sourceList,(item:string,index:number)=>{
              sourceType({
                title:item,
                sourceType:this.sourceType
              })
                .onClick(()=>{
                  this.tabsBodyController.changeIndex(index)
                  this.sourceType = item
                })
            })
          }.margin({top:5,bottom:5})
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
      if (this.isShowNoFind){
        noSourceFind({
          setOnclick: () => {
            this.isShowNoFind = false
          }
        })
          .margin({
            top:PaddingConstants.PADDING_20
          })

      } else {
        Tabs(){
          TabContent(){
            Refresh({ refreshing: $$this.isRefreshing, builder: this.refreshComponent }) {
              Scroll(){
                Stack({ alignContent: Alignment.Center }) {
                  BookFindContent({
                    currentIndex:this.currentIndex,
                    sourceType:this.sourceType
                  })
                }
                .padding({
                  left:20,right:20,bottom:20
                })
              }
              .scrollBar(BarState.Off)
            }
            .onStateChange((refreshStatus: RefreshStatus) => {
              if (refreshStatus === 1 || refreshStatus === 2) {
                this.RefreshingTitle = '松开刷新'
              } else {
                this.RefreshingTitle = '刷新中...'
              }
            })
            .layoutWeight(1)
            .onRefreshing(() => {
              setTimeout(() => {
                this.counter++
                this.isRefreshing = false
              }, 1000)
            })
          }
          .align(Alignment.Top)
        }
        .scrollable(false)
        .barWidth(0)
        .barHeight(0)
        .onChange((index) => {
          this.tabsBodyController.changeIndex(index)
          this.currentIndex = index
        })

      }
    }
  }

  @Builder sourceCommon(){
    Column(){
      SourceCommon()
    }.height('100%')
  }
  @State RefreshingTitle: string = '松开刷新'
  @Builder
  refreshComponent() {
    RefreshComponent({
      RefreshingTitle: this.RefreshingTitle,
    })
  }
}