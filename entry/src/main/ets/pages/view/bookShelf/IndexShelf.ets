import cartoonPage from './cartoonPage'
import novelPage from './novelPage'
import BookMark from '../../../componets/head/BookMark'
import BookType from '../../../componets/head/BookType'

import soundPage from './soundPage'
import IndexSearchType from '../../../componets/head/IndexSearchType'
import router from '@ohos.router'; // 引入路由管理器
import delDialogExample from '../../../componets/common/delDialog'
import BookFolder from './BookFolder'

@Component
export default struct IndexShelf {
  IndexShelf: CustomDialogController | null = new CustomDialogController({
    builder: delDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      title: '清空'
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    // offset: { dx: 0, dy: '-40%' },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25
  })

  onAccept() {
    console.info('确定')
    this.isClear = true
  }
  onCancel() {
    console.info('取消')
  }
  exitApp() {
    console.info('点外围取消')
  }

  @State currentIndex: number = 0
  THEME_NAMES: string[] = ['书籍导入', '下载管理', '导入书单','批量管理']
  EXHIBIT_NAMES: string[] = ['列表', '宫格']
  GROUP_NAMES:string[] = ['标签', '文件夹']
  @State EXHIBIT:string = '列表'
  @State GROUP:string = '标签'
  @State searchValue:string = '最近阅读'
  @State bookType:string = '全部'
  @State title:string = '最近阅读'
  @State isClear:boolean = false
  @State isRefreshing: boolean = false
  @State counter: number = 0
  @State RefreshingTitle:string = '松开刷新'
  build() {
    Column() {
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.End
      }) {
        Row({ space: 20 }) {
          BookMark({ title: '小说', index: 0, currentIndex: this.currentIndex }).onClick(() => {
            this.currentIndex = 0
          })
          BookMark({ title: '漫画', index: 1, currentIndex: this.currentIndex }).onClick(() => {
            this.currentIndex = 1
          })
          BookMark({ title: '有书声', index: 2, currentIndex: this.currentIndex }).onClick(() => {
            this.currentIndex = 2
          })
        }
        .padding({ left: 15 })

        Row({ space: 15 }) {
          Image($r('app.media.search')).width('8%').onClick(() => {
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
          justifyContent: FlexAlign.SpaceBetween
        }
      ){
        Scroll(){
          Flex({
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.SpaceBetween
          }){
            Row({space:15}){
              IndexSearchType({title:this.title,searchValue:this.searchValue})
              IndexSearchType({title:'浏览历史',searchValue:this.searchValue})
                .onClick(()=> {
                  this.GROUP = '标签'
                  this.searchValue = '浏览历史'
                })
              if (this.searchValue !== '浏览历史') {
                this.GroupBuilder()
                this.ExhibitBuilder()
                Text('管理')
                  .onClick(()=>{
                    router.pushUrl({
                      url:'pages/view/BookManagePage',
                      params: {
                        currentIndex:this.currentIndex,
                        EXHIBIT:this.EXHIBIT
                      }
                    })
                  })
                  .fontColor('rgba(0,0,0,0.5)')
                  .fontSize(15)
                  .fontWeight(400)
              }
            }
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)

        if (this.searchValue === '浏览历史') {
          Row() {
            Text('清空')
              .onClick(() => {
                if (this.IndexShelf != null) {
                  this.IndexShelf.open()
                }
              })
          }
        }
      }
      .padding(15)

      if (this.searchValue !== '浏览历史'){
      Flex(
        {
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Scroll() {
          Row({ space: 10 }) {
            BookType({ title: '全部', bookType: this.bookType }).onClick(() => {
              this.bookType = '全部'
            })
            BookType({ title: '未分组', bookType: this.bookType }).onClick(() => {
              this.bookType = '未分组'
            })
            BookType({ title: '本地', bookType: this.bookType }).onClick(() => {
              this.bookType = '本地'
            })
            BookType({ title: '书单', bookType: this.bookType }).onClick(() => {
              this.bookType = '书单'
            })
            if (this.currentIndex === 0) {
              BookType({ title: '玄幻', bookType: this.bookType }).onClick(() => {
                this.bookType = '玄幻'
              })
              BookType({ title: '修仙', bookType: this.bookType }).onClick(() => {
                this.bookType = '修仙'
              })
              BookType({ title: '女同', bookType: this.bookType }).onClick(() => {
                this.bookType = '女同'
              })
              BookType({ title: '军事', bookType: this.bookType }).onClick(() => {
                this.bookType = '军事'
              })
            } else if (this.currentIndex === 1) {
              BookType({ title: '国漫', bookType: this.bookType }).onClick(() => {
                this.bookType = '国漫'
              })
              BookType({ title: '日漫', bookType: this.bookType }).onClick(() => {
                this.bookType = '日漫'
              })
            } else if (this.currentIndex === 2) {
              BookType({ title: '广播', bookType: this.bookType }).onClick(() => {
                this.bookType = '广播'
              })
              BookType({ title: '深夜电台', bookType: this.bookType }).onClick(() => {
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
      }.margin({ left: 15,bottom:10})
    }
      Refresh({ refreshing: $$this.isRefreshing,builder:this.refreshComponent}) {
        Scroll(){
          Stack({alignContent:Alignment.Center}) {
            if (this.GROUP === '标签'){
              if (this.currentIndex === 0){
                novelPage({
                  searchValue:this.searchValue,
                  currentIndex:0,
                  isClear:this.isClear,
                  EXHIBIT:this.EXHIBIT
                })
                  .zIndex(0)
              } else if(this.currentIndex === 1) {
                cartoonPage({searchValue:this.searchValue,currentIndex:1,isClear:this.isClear,EXHIBIT:this.EXHIBIT}).zIndex(1)
              } else if(this.currentIndex === 2) {
                soundPage({searchValue:this.searchValue,currentIndex:2,isClear:this.isClear,EXHIBIT:this.EXHIBIT}).zIndex(2)
              }
            } else {
               BookFolder()
            }
          }
          .padding({left:10,right:10})
        }
        .align(Alignment.TopStart)
        .height(this.searchValue==='浏览历史'?'83%':'78%')
        .scrollBar(BarState.Off)
      }.onStateChange((refreshStatus: RefreshStatus) =>{
        if (refreshStatus === 1 || refreshStatus === 2) {
          this.RefreshingTitle = '松开刷新'
        } else{
          this.RefreshingTitle = '刷新中...'
        }
      })
      .onRefreshing(()=>{
        setTimeout(() => {
          this.counter++
          this.isRefreshing = false
        }, 1000)

      })
    }
  }

  @Builder ExhibitBuilder() {
    Row({space:10}){
      ForEach(this.EXHIBIT_NAMES, (item:string) => {
        if (item !== this.EXHIBIT) {
          IndexSearchType({ title: item, searchValue: this.searchValue })
            .onClick(() => {
              this.EXHIBIT = item
            })
          Divider()
            .vertical(true)
            .height(15)
            .color('#989797')
            .opacity(0.5)
            .strokeWidth(1)
        }
      })
    }
  }

  @Builder GroupBuilder() {
    Row({space:10}){
      ForEach(this.GROUP_NAMES, (item:string) => {
        if (item !== this.GROUP) {
          IndexSearchType({ title: item, searchValue: this.searchValue })
            .onClick(() => {
              this.GROUP = item
            })
          Divider()
            .vertical(true)
            .height(15)
            .color('#989797')
            .opacity(0.5)
            .strokeWidth(1)
        }
      })
    }
  }

  @Builder TabBuilderImage(index: number, name: string) {
    Column() {
      Image($r('app.media.SUB_theme'))
    }.width('100%')
  }

  @Builder
  refreshComponent()
  {
    Row()
    {
      if (this.RefreshingTitle !== '松开刷新'){
        LoadingProgress().height(30)
      }
      Text(this.RefreshingTitle).fontSize(16).margin({left:20})
    }
  }

  changeTheme(themeNum: number) {

  }
}