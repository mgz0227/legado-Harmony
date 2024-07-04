/**
 * @author Andy
 * @datetime 2024/7/3 19:56
 * @className: ImportCommon
 * 通用导入页
 */
import { BookSource, GroupList } from '../dataList/BookSource';

@Component
@Preview
export default struct ImportCommon{
  @Prop sourceList: BookSource[] = []
  @Link show: boolean;
  @State groupList: GroupList[] = []
  @State currentIndex:number = 0
  @State activeNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State waringActive: boolean = false
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()

  aboutToAppear() {
    const groupMap: Record<string, GroupList> = {};
    this.sourceList.forEach((item: BookSource) => {
      const title = item.bookSourceGroup;

      // 如果groupMap中还没有这个group，则创建一个新的GroupList对象
      if (!groupMap[title]) {
        groupMap[title] = { title: title, list: [] };
      }

      // 向当前group的list中添加BookSource对象
      groupMap[title].list.push(item);
    })

    this.groupList = Object.values(groupMap);
  }

  scrollChangeAction(start: number, flg: Boolean) {
    if (this.currentIndex !== start) {
      this.currentIndex = start;
      if (!flg) {
        this.scroll.scrollToIndex(start);
      } else {
        this.secondScroll.scrollToIndex(start);
      }
    }
  }

  resetState() {
    this.sourceList = []
    this.groupList = []
    this.currentIndex = 0
  }

  build() {
    Column() {
      Row({space: 12}){
        List({ scroller: this.scroll }) {
          ForEach(this.groupList, (item: GroupList, index: number) => {
            ListItem() {
              Stack({alignContent: Alignment.TopStart}) {
                Column() {
                  Text(item.title)
                    .width('100vp')
                    .height('48vp')
                    .textAlign(TextAlign.Center)
                    .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
                }
                .backgroundColor(this.currentIndex === index ? 0xF5F5F5 : Color.White)
                .borderRadius({
                  topRight: this.currentIndex + 1 === index ? 12 : 0,
                  bottomRight: this.currentIndex - 1 === index || this.groupList.length === index + 1 ? 12 : 0
                })
                .animation({
                  duration: 100,
                  curve:Curve.Linear
                })
                .onClick(() => {
                  this.scrollChangeAction(index, true)
                })
                if (this.currentIndex === index) {
                  Row()
                    .width(3)
                    .height(16)
                    .backgroundColor('#FF6600')
                    .borderRadius(12)
                    .position({
                      top: 16
                    })
                }
              }
            }
          })
        }
        .height('100%')
        .width(88)
        .scrollBar(BarState.Off)
        .borderRadius({
          topRight: 12,
          bottomRight: 12
        })

        List({ scroller: this.secondScroll }) {
            ForEach(this.groupList, (item: GroupList,index:number)=>{
              ListItemGroup({
                header: this.classifyHeader(`${item.title} (${item.list.length})`, index),
                space: 0
              }) {
                ForEach(item.list, (bookSource: BookSource, j: number) => {
                  this.CourseItem(bookSource, index, j)
                })
              }
            })
        }
        .padding({right: 20})
        .sticky(StickyStyle.Header)
        .onScrollIndex((start) => {
          this.scrollChangeAction(start, false)
        })
        .layoutWeight(1)
      }
      .layoutWeight(1)

      Row() {
        Checkbox()
          .select(this.fullActive)
          .selectedColor(0xff6600)
          .onChange((val: boolean)=>{
            this.fullActive = val
            this.sourceList.forEach((item: BookSource) => {
              this.activeNameMap[item.bookSourceName] = val
            })
          })

        Text(){
          Span('全选（')
          Span(Object.values(this.activeNameMap).filter(o=>o).length+'')
            .fontColor(0xff6600)
          Span(`/${this.sourceList.length})`)
        }
        .margin({left: 8})
      }
      .width('100%')
      .height(40)
      .padding({left: 20, right: 20})
      .backgroundColor(Color.White)

      Row() {
        Image($r('app.media.warning'))
          .width(20)
          .fillColor(0xff6600)

        Text('允许对书架中正在使用的书源进行更新')
          .fontSize(14)
          .fontColor('#EF4444')
          .padding({left:8})

        Blank()

        Checkbox()
          .select(this.waringActive)
          .selectedColor(0xff6600)
          .onChange((val: boolean)=>{
            this.waringActive = val
          })
      }
      .width('100%')
      .height(48)
      .padding({left: 20, right: 20})
      .backgroundColor('rgba(239, 68, 68, 0.12)')

      Row({space: 20}) {
        Button('取消')
          .height(40)
          .fontColor(0xff6600)
          .backgroundColor('rgba(255, 102, 0, 0.12)')
          .layoutWeight(1)
          .onClick(() => {
            this.show = false;
          })

        Button('确认')
          .height(40)
          .fontColor(Color.White)
          .backgroundColor(0xff6600)
          .layoutWeight(1)
          .onClick(() => {
            this.show = false;
            this.resetState()
            console.log('确定')
          })
      }
      .width('100%')
      .padding({left:20,right:20,top: 12, bottom: 12})
    }
    .padding({top:12,bottom:12})
    .backgroundColor(0xF5F5F5)
  }

  @Builder
  classifyHeader(title: string, index: number) {
    Row() {
      Text(title)
        .textAlign(TextAlign.Start)
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      CheckboxGroup({ group: 'checkboxGroup' + index })
        .checkboxShape(CheckBoxShape.CIRCLE)
        .selectedColor(0xff6600)
    }
    .padding({ right: 16})
    .backgroundColor('#f5f5f5')
  }

  @Builder
  CourseItem(item: BookSource, i: number, j: number) {
    Column() {
      Row() {
        Text(item.bookSourceName)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)

        if (i%2===0){

          Column() {
            Text('正在使用')
              .fontSize(10)
              .fontColor('#24B277')
          }
          .height(16)
          .margin({ left: 8 })
          .padding({left: 6, right: 6})
          .borderRadius(4)
          .backgroundColor('rgba(36, 178, 119, 0.12)')
          .justifyContent(FlexAlign.Center)
        }

        Blank()

        Checkbox({ name: 'checkbox' + j, group: 'checkboxGroup' + i })
          .select(this.activeNameMap[item.bookSourceName] ?? false)
          .selectedColor(0xff6600)
          .onChange((val: boolean)=>{
            this.activeNameMap[item.bookSourceName] = val
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Blank()

      Row() {
        Row() {
          Row() {
            Stack(){
              Image($r('app.media.rectangle_icon'))
                .borderRadius({
                  topLeft: 4,
                  bottomLeft: 4
                })
                .width(28)
                .height(16)

              Text('精品')
                .fontSize(9)
                .fontColor('#FFE5D4')
            }

            Text('5.0')
              .fontSize(12)
              .fontColor('#854D00')
          }
          .width(47)
          .height(16)
          .borderRadius(4)
          .backgroundColor('#FFE5D4')

          Rating({ rating: j, indicator: true })
            .size({
              width: 90,
              height: 20
            })
            .stars(5)
            .stepSize(0.5)
            .margin({left:8})
        }

        Text('更新')
          .fontSize(12)
          .fontColor('rgba(0, 0, 0, 0.45)')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100vp')
    .margin({
      bottom: 12
    })
    .borderRadius(12)
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
  }
}

