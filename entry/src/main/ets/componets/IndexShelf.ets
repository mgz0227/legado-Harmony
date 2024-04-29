import cartoonPage from '../pages/view/bookShelf/cartoonPage'
import novelPage from '../pages/view/bookShelf/novelPage'
import BookMark from './head/BookMark'
import BookType from './head/BookType'

import soundPage from '../pages/view/bookShelf/soundPage'
import IndexSearchType from './head/IndexSearchType'
import router from '@ohos.router'; // 引入路由管理器
import delDialogExample from './common/delDialog'

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
  }
  onCancel() {
    console.info('取消')
  }
  exitApp() {
    console.info('点外围取消')
  }

  @State currentIndex: number = 0
  THEME_NAMES: string[] = ['书籍导入', '下载管理', '导入书单','批量管理']
  @State searchValue:string = '浏览历史'
  @State bookType:string = '全部'
  @State title:string = '最近阅读'
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
          Row({space:16}){
            IndexSearchType({title:this.title,searchValue:this.searchValue})
            IndexSearchType({title:'浏览历史',searchValue:this.searchValue})
              .onClick(()=> {
                this.searchValue = '浏览历史'
              })
            if (this.searchValue !== '浏览历史') {
              IndexSearchType({ title: '文件夹', searchValue: this.searchValue })
                .onClick(() => {
                  this.searchValue = '文件夹'
                })
              IndexSearchType({ title: '宫格', searchValue: this.searchValue })
                .onClick(() => {
                  this.searchValue = '宫格'
                })
              Divider()
                .vertical(true)
                .height(15)
                .color('#989797')
                .opacity(0.5)
                .strokeWidth(1)
              IndexSearchType({ title: '管理', searchValue: this.searchValue })
                .onClick(() => {
                  this.searchValue = '管理'
                })
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
        .padding({left:10,right:10})
      }
      .height(this.searchValue==='浏览历史'?'80%':'75%')
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