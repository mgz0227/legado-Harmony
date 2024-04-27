import novelPage from '../pages/view/bookShelf/novelPage'
import BookMark from './head/BookMark'
import BookType from './head/BookType'
import IndexSearchType from './head/IndexSearchType'

@Component
export default struct IndexTop {

  @State currentIndex: number = 0
  THEME_NAMES: string[] = ['更新目录', '添加本地', 'WebDav 书籍']
  @State searchValue:string = '最近阅读'
  @State bookType:string = '全部'
  build() {
    Column() {
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.End
      }){
        Row({space:20}){
          BookMark({title:'小说',index:0,currentIndex:this.currentIndex}).onClick(()=>{
            this.currentIndex = 0
          })
          BookMark({title:'漫画',index:1,currentIndex:this.currentIndex}).onClick(()=>{
            this.currentIndex = 1
          })
          BookMark({title:'有书声',index:2,currentIndex:this.currentIndex}).onClick(()=>{
            this.currentIndex = 2
          })
        }
        .padding({left:15})
        Row({space:15}){
          Image($r('app.media.search')).width('8%')
          Image($r('app.media.more')).width('8%')
            .bindMenu([
            {
              value: this.THEME_NAMES[0],
              action: () => {
                this.changeTheme(0)
              }
            },
            {
              value: this.THEME_NAMES[1],
              action: () => {
                this.changeTheme(1)
              }
            },
            {
              value: this.THEME_NAMES[2],
              action: () => {
                this.changeTheme(2)
              }
            }
          ])
        }.margin({right:20 })

      }
      .padding({bottom:10})
      .borderRadius({ bottomRight:5 ,bottomLeft:5})
      .backgroundImage($r('app.media.backgroundimage'))
      .backgroundImageSize({width:'100%'})
      .height('10%')
      .width('100%')

      Column(){
        Row({space:16}){
          IndexSearchType({title:'最近阅读',searchValue:this.searchValue})
            .onClick(()=> {
              this.searchValue = '最近阅读'
            })
          IndexSearchType({title:'浏览历史',searchValue:this.searchValue})
            .onClick(()=> {
              this.searchValue = '浏览历史'
            })
          IndexSearchType({title:'文件夹',searchValue:this.searchValue})
            .onClick(()=> {
              this.searchValue = '文件夹'
            })
          IndexSearchType({title:'宫格',searchValue:this.searchValue})
            .onClick(()=> {
              this.searchValue = '宫格'
            })
          Divider().vertical(true).height(15).color('#182431').opacity(0.5)
          IndexSearchType({title:'管理',searchValue:this.searchValue})
            .onClick(()=> {
              this.searchValue = '管理'
            })
        }
      }
      .padding(15)

      Flex(
        {
          alignItems: ItemAlign.Center
        }
      ) {
        Scroll(){
          Row({space:10}){
            BookType({title:'全部',bookType:this.bookType}).onClick(()=>{
              this.bookType = '全部'
            })
            BookType({title:'未分组',bookType:this.bookType}).onClick(()=>{
              this.bookType = '未分组'
            })
            BookType({title:'本地',bookType:this.bookType}).onClick(()=>{
              this.bookType = '本地'
            })
            BookType({title:'书单',bookType:this.bookType}).onClick(()=>{
              this.bookType = '书单'
            })
            BookType({title:'玄幻',bookType:this.bookType}).onClick(()=>{
              this.bookType = '玄幻'
            })
            BookType({title:'修仙',bookType:this.bookType}).onClick(()=>{
              this.bookType = '修仙'
            })
            BookType({title:'女同',bookType:this.bookType}).onClick(()=>{
              this.bookType = '女同'
            })
            BookType({title:'军事',bookType:this.bookType}).onClick(()=>{
              this.bookType = '军事'
            })
          }
        }
        .padding({left:15,right:15})
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
        Column(){
         Image($r('app.media.more_search')).width(25).height(25)
        }
      }

      Scroll(){
        Stack({alignContent:Alignment.Center}) {
          if (this.currentIndex === 0){
            novelPage().zIndex(0)
          } else if(this.currentIndex === 1) {
            Text('漫画').width('100%').backgroundColor('rgba(255, 255, 255, 0.8)').align(Alignment.Top).zIndex(1)
          } else if(this.currentIndex === 2) {
            Text('有书声').width('100%').backgroundColor('rgba(255, 255, 255, 0.8)').align(Alignment.Top).zIndex(2)
          }
        }
        .padding(15)
      }
      .scrollBar(BarState.Off)
    }
    .height('80%')
    .width('100%')

  }

  @Builder TabBuilderImage(index: number, name: string) {
    Column() {
      Image($r('app.media.SUB_theme'))
    }.width('100%')
  }

  changeTheme(themeNum: number) {

  }
}