import cartoonPage from '../pages/view/bookShelf/cartoonPage'
import novelPage from '../pages/view/bookShelf/novelPage'
import BookMark from './head/BookMark'
import BookType from './head/BookType'

import soundPage from '../pages/view/bookShelf/soundPage'
import IndexSearchType from './head/IndexSearchType'
import router from '@ohos.router'; // 引入路由管理器

@Component
export default struct IndexShelf {

  @State currentIndex: number = 0
  THEME_NAMES: string[] = ['书籍导入', '下载管理', '导入书单','批量管理']
  @State searchValue:string = '最近阅读'
  @State bookType:string = '全部'
  @State title:string = '最近阅读'
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
          Image($r('app.media.search')).width('8%').onClick(()=>{
            console.log('test')
            router.pushUrl({
              url: 'pages/search/SearchBook'
            });
          })
          Image($r('app.media.more')).width('8%')
            .bindMenu([
              {
                icon: $r('app.media.import_svg'),
                value: this.THEME_NAMES[0],
                action: () => {
                  this.changeTheme(0)
                }
              },
              {
                icon:$r('app.media.down_svg'),
                value: this.THEME_NAMES[1],
                action: () => {
                  this.changeTheme(1)
                }
              },
              {
                icon: $r('app.media.import_book_svg'),
                value: this.THEME_NAMES[2],
                action: () => {
                  this.changeTheme(2)
                }
              },
              {
                icon: $r('app.media.batch_svg'),
                value: this.THEME_NAMES[3],
                action: () => {
                  this.changeTheme(3)
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

      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent:FlexAlign.Start
        }
      ){
        Scroll(){
          Row({space:16}){
            IndexSearchType({title:this.title,searchValue:this.searchValue})
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
            Divider().vertical(true).height(15).color('#989797').opacity(0.5).strokeWidth(1)
            IndexSearchType({title:'管理',searchValue:this.searchValue})
              .onClick(()=> {
                this.searchValue = '管理'
              })
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
      }
      .padding(15)

      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent:FlexAlign.SpaceBetween
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
            if (this.currentIndex === 0){
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
            } else if(this.currentIndex === 1){
              BookType({title:'国漫',bookType:this.bookType}).onClick(()=>{
                this.bookType = '国漫'
              })
              BookType({title:'日漫',bookType:this.bookType}).onClick(()=>{
                this.bookType = '日漫'
              })
            } else if(this.currentIndex === 2){
              BookType({title:'广播',bookType:this.bookType}).onClick(()=>{
                this.bookType = '广播'
              })
              BookType({title:'深夜电台',bookType:this.bookType}).onClick(()=>{
                this.bookType = '深夜电台'
              })
            }
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
        Row(){
          Image($r('app.media.more_search')).width(25).height(25)

        }.width(
          '10%'
        )
      }.margin({left:15})

      Scroll(){
        Stack({alignContent:Alignment.Center}) {
          if (this.currentIndex === 0){
            novelPage({searchValue:this.searchValue}).zIndex(0)
          } else if(this.currentIndex === 1) {
            cartoonPage({searchValue:this.searchValue}).zIndex(1)
          } else if(this.currentIndex === 2) {
            soundPage({searchValue:this.searchValue}).zIndex(2)
          }
        }
        .padding(15)
      }
      .height('80%')
      .scrollBar(BarState.Off)
    }
  }

  @Builder TabBuilderImage(index: number, name: string) {
    Column() {
      Image($r('app.media.SUB_theme'))
    }.width('100%')
  }

  changeTheme(themeNum: number) {

  }
}