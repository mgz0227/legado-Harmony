import Header from '../../../../componets/common/Header';
import { showMessage } from '../../../../componets/common/promptShow';
import { dataItem } from '../../../../componets/dataList/dataItem';
import Help from '../../../../componets/dialog/help';
import { sourceTabs } from '../../../../componets/source/sourceTabs';
import { router } from '@kit.ArkUI';
import { BookSource } from '../../../../componets/dataList/BookSource';
import FormItem from '../../../../componets/Form/FormItem';


@Entry
@Component
@Preview
struct AddSourcePage {
  titleArray: string[] = ['小说', '漫画', '有声书']
  dialogRightData: string[] = ['搜索源码', '书籍源码', '目录源码', '正文源码', '帮助']
  @State isShowHelp: boolean = false
  @State sourceList: dataItem[] = [
    new dataItem("编辑", 1),
    new dataItem("调试", 2)
  ]
  @State readIndex: number = 0
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  @State formModel: Partial<BookSource> = {}

  build() {
    Column() {
      Header({
        customTitleBuilder: () => {
          this.titleBuilder()
        },
        rightIcon: $r('app.media.more_vertical'),
        dialogRightData: this.dialogRightData,
        dialogRightChange: (index: number) => {
          switch (index) {
            case 0:
            case 1:
            case 2:
            case 3:
              showMessage(this.dialogRightData[index]);
              break;
            case 4:
              this.isShowHelp = true;
              break;
          }
        }
      })


      Column() {
        Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
          TabContent() {
            this.form()
          }
          .tabBar(this.tabBuilder(0, '基本'))

          TabContent() {
            this.form()
          }.tabBar(this.tabBuilder(1, '搜索'))

          TabContent() {
            this.form()
          }.tabBar(this.tabBuilder(2, '发现'))

          TabContent() {
            this.form()
          }.tabBar(this.tabBuilder(3, '详情'))

          TabContent() {
            this.form()
          }.tabBar(this.tabBuilder(4, '目录'))

          TabContent() {
            this.form()
          }.tabBar(this.tabBuilder(5, '正文'))
        }
        .padding({ left: 20, right: 20 })
        .vertical(false)
        .barMode(BarMode.Fixed)
        .barGridAlign({
          gutter: 100
        })
        .barHeight(48)
        .animationDuration(400)
        .onChange((index: number) => {
          this.currentIndex = index
        })
      }
      .layoutWeight(1)

      Divider()
      Row({ space: 20 }) {
        Button('取消')
          .height(40)
          .fontColor(0xff6600)
          .backgroundColor('rgba(255, 102, 0, 0.12)')
          .layoutWeight(1)
          .onClick(() => {
            router.back()
          })
          .opacity(1)

        Button('确认')
          .height(40)
          .fontColor(Color.White)
          .backgroundColor(0xff6600)
          .layoutWeight(1)
          .onClick(() => {
            console.log('保存')
          })
          .opacity(1)
      }
      .height(64 + this.bottomRectHeight)
      .padding({ left: 20, right: 20 })

      Flex()
        .bindSheet(this.isShowHelp, this.dialogHelpFuction(), {
          height: '50%',
          showClose: false,
          dragBar: false,
          onDisappear: () => {
            this.isShowHelp = false
          }
        })
    }
  }

  @Builder form () {
    Scroll() {
      Column() {
        FormItem({
          value: this.formModel.bookSourceName,
          label: '名称',
          isLength: true,
          maxLength: 5,
          required: true
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '源URL',
          required: true
        });

        Column() {
          Row() {
            Row() {
              Text('源类型及分组')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Select([
              { value: '小说' },
              { value: '漫画' },
              { value: '有声' }
            ])
              .value(this.formModel.bookSourceGroup ?? '小说')
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceGroup ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
              })
              .layoutWeight(1)
            Row().width(16)
            Select([
              { value: '男频' },
              { value: '女频' },
              { value: '综合' },
              { value: '出版' },
              { value: '下载' },
              { value: '正版' },
              { value: '轻文' },
              { value: '网络' },
              { value: '其他' }
            ])
              .value(this.formModel.bookSourceGroup ?? '男频')
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceGroup ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
              })
              .layoutWeight(1)
          }
          .margin({ top: 10, bottom: 10 })
        }
        .margin({ top: 12 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Row() {
            Row() {
              Text('满等级及评分')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Select([
              { value: '精品' },
              { value: '优质' },
              { value: '常规' }
            ])
              .value(this.formModel.bookSourceGroup ?? '精品')
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceGroup ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
              })
              .layoutWeight(1)
            Row().width(16)
            Select([
              { value: '5.0分' },
              { value: '4.0分' },
              { value: '3.0分' },
              { value: '2.0分' },
              { value: '1.0分' },
            ])
              .value(this.formModel.bookSourceGroup ?? '5.0分')
              .borderRadius(4)
              .fontColor(this.formModel.bookSourceGroup ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
              })
              .layoutWeight(1)
          }
          .margin({ top: 10, bottom: 10 })
        }
        .margin({ top: 12 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '源注释'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '登录URL'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '登录UI'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '登录检测JS'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '封面解密'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '书籍URL正则'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '请求头'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '变量说明'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: '并发率'
        });

        FormItem({
          value: this.formModel.bookSourceUrl,
          label: 'jsLib'
        });
      }.width('100%')
    }.height('100%').scrollBar(BarState.Off)
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 700 : 400)
        .lineHeight(24)
        .backgroundImage(this.currentIndex === index ? $r('app.media.underline') : '')
        .backgroundImageSize(this.currentIndex === index ? { width: '100%', height: 15 } : {})
        .backgroundImagePosition({ y: 16 })
    }
  }

  @Builder
  titleBuilder() {
    sourceTabs({
      sourceList: this.sourceList,
      read_index: this.readIndex,
      marginY: 0
    })
      .width('50%')
  }

  @Builder
  dialogHelpFuction() {
    Flex() {
      Help({
        title: '新增帮助',
        btnClick: () => {
          this.isShowHelp = false
        }
      })
    }
  }
}