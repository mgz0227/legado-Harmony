/**
 * @author 2008
 * @datetime 2024/7/14 00:46
 * @className: SubscriptionImport
 * 订阅源导入页面
 */
import SideBar from '../common/SideBar';
import { showMessage } from '../common/promptShow';
import Tag from '../common/Tag';
import subscriptionDao from '../../database/dao/SubscriptionDao';
import { rssGroupList, rssSources } from '../../database/entities/rssSources';
import SubscriptionDao from '../../database/dao/SubscriptionDao';
import FontConstants from '../../common/constants/FontConstants';
import CommonConstants from '../../common/constants/CommonConstants';
import programDataPreferences from '../../preferences/programDataPreferences'
import PaddingConstants from '../../common/constants/PaddingConstants';
import addBookTypeDialog from '../common/addBookTypeDialog';
import { ThemeItem } from '../../common/model/Theme';
import { ThemeStorageKey } from '../../common/constants/Theme';

@Component
export default struct SubscriptionImport {

  @State localSourceList: rssSources[] = []
  @Prop subscriptionList: rssSources[] = []
  @Link show: boolean;
  @State groupList: rssGroupList[] = []
  @State currentIndex: number = 0
  @State insertMap: Record<string, boolean> = {}
  @State alreadyNameMap: Record<string, boolean> = {}
  @State updateNameMap: Record<string, boolean> = {}
  @State fullActive: boolean = false
  @State waringActive: boolean = false
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()
  @State sourceGroup: string = ''
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem

  aboutToAppear() {
    subscriptionDao.search().then(data => {
      const rssSources = data ?? []
      this.localSourceList = rssSources
      this.getGroupList()
    }).catch(() => {
      this.getGroupList()
    })
  }

  getRssSourceList() {
   this.sourceGroupList = programDataPreferences.getRssSourcesListData()
  }

  getGroupList() {
    const groupMap: Record<string, rssGroupList> = {};
    this.subscriptionList.forEach((item: rssSources) => {
      const title = item.sourceGroup;
      item.sourceType = 1
      if (title) {
        // 如果groupMap中还没有这个group，则创建一个新的GroupList对象
        if (!groupMap[title]) {
          groupMap[title] = { title: title, list: [] };
        }
        // 向当前group的list中添加BookSource对象
        groupMap[title].list.push(item);
      } else {
        if (!groupMap['其他']) {
          groupMap['其他'] = { title: '其他', list: [] };
        }
        groupMap['其他'].list.push(item);
      }
      for (let i = 0; i < this.localSourceList.length; i++) {
        const localItem = this.localSourceList[i];
        if (localItem.sourceUrl === item.sourceUrl) {
          this.alreadyNameMap[item.sourceUrl] = true
          if (
            localItem.sourceName !== item.sourceName ||
            localItem.sourceUrl !== item.sourceUrl ||
            localItem.rssListRule?.ruleTitle !== item.rssListRule?.ruleTitle ||
            localItem.rssWebViewRule?.ruleContent !== item.rssWebViewRule?.ruleContent
          ) {
            this.insertMap[item.sourceUrl] = true
            this.updateNameMap[item.sourceUrl] = true
          }
          break;
        }
      }
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
    this.subscriptionList = []
    this.groupList = []
    this.currentIndex = 0
  }
  @State longCount: number = 0
  @State isBatch: boolean = false
  build() {
    Column() {
      Row({ space: 12 }) {
        SideBar({
          currentIndex: this.currentIndex,
          sideBarList: this.groupList.map(o => o.title),
          scroller: this.scroll,
          clickAction: (index: number) => {
            this.scrollChangeAction(index, true)
          }
        })
          .width(88)

        List({ scroller: this.secondScroll }) {
          ForEach(this.groupList, (item: rssGroupList, index: number) => {
            ListItemGroup({
              header: this.classifyHeader(`${item.title} (${item.list.length})`, index),
              space: 0
            }) {
              ForEach(item.list, (rssSource: rssSources, j: number) => {
                this.CourseItem(rssSource, index, j)
              })
            }
          })
        }
        .height('100%')
        .padding({ right: 20 })
        .sticky(StickyStyle.Header)
        .onScrollIndex((start) => {
          this.scrollChangeAction(start, false)
        })
        .layoutWeight(1)
        .gesture(
          LongPressGesture({ repeat: true, duration: 500 })
            .onAction((event: GestureEvent) => {
              if (event && event.repeat) {
                if (this.longCount >= 1) {
                  this.isBatch = true
                }
                this.longCount++
              }
            })
            .onActionEnd(() => {
              this.longCount = 0
            })
        )
      }
      .layoutWeight(1)

      Flex({
        justifyContent:FlexAlign.SpaceBetween
      }){
        Row() {
          Checkbox()
            .select(this.fullActive)
            .selectedColor(this.theme.mainColor)
            .onChange((val: boolean) => {
              this.fullActive = val
              this.subscriptionList.forEach((item: rssSources) => {
                this.insertMap[item.sourceUrl] = val
              })
            })

          Text() {
            Span('全选（')
            Span(Object.values(this.insertMap).filter(o => o).length + '')
              .fontColor(this.theme.mainColor)
            Span(`/${this.subscriptionList.length})`)
          }
          .margin({ left: 8 })
        }
        .height(40)

        Row({
          space:6
        }){
          if (this.sourceGroup.length > 0){
            Text(`订阅源分组:${this.sourceGroup}`)
              .font({
                size: 14,
                weight: FontConstants.FONT_WEIGHT_700
              })
              .textAlign(TextAlign.Center)
              .fontColor(this.theme.mainColor)
              .lineHeight(22)
          }
          Text('导入至').font({
            size: 14,
            weight: FontConstants.FONT_WEIGHT_400
          })
            .textAlign(TextAlign.Center)
            .fontColor(this.theme.mainColor)
            .lineHeight(22)
            .onClick(() => {
              this.getRssSourceList()
              this.isCatalogMove = true
            })
        }.height(40)
      }
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)


      Row({ space: 20 }) {
        Button('取消')
          .height(40)
          .fontColor(this.theme.mainColor)
          .backgroundColor(this.theme.secondColor)
          .layoutWeight(1)
          .onClick(() => {
            this.show = false;
          })

        Button('确认')
          .height(40)
          .fontColor(Color.White)
          .backgroundColor(this.theme.mainColor)
          .layoutWeight(1)
          .onClick(async  () => {
            if (this.sourceGroup.length === 0) {
              showMessage('请选择分组')
              return
            }
            const insertRssSources = this.subscriptionList.filter(item => this.insertMap[item.sourceUrl] ?? false)
            //将insertRssSources里面的分组改为sourceGroup
            insertRssSources.forEach((item: rssSources) => {
              item.sourceGroup = this.sourceGroup
              item.sourceIconIsUrl = true
            })
            await SubscriptionDao.batchInsert(insertRssSources)
            this.show = false;
            this.resetState()
            showMessage('添加成功')
          })
      }
      .backgroundColor(Color.White)
      .width('100%')
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
      Flex()
        .bindSheet($$this.isCatalogMove,this.catalogMove(), {
          height:330,
          showClose: false,
          dragBar: false,
          blurStyle:BlurStyle.COMPONENT_ULTRA_THIN,
          maskColor: 'rgba(0,0,0,0.6)'
        })
    }
    .padding({ top: 12, bottom: 12 })
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
        .selectedColor(this.theme.mainColor)
    }
    .padding({ right: 16 })
    .backgroundColor('#f5f5f5')
  }

  @Builder
  CourseItem(item: rssSources, i: number, j: number) {
    Column() {
      Row() {
        Text(item.sourceName)
          .fontSize(16)
          .lineHeight(24)
          .fontWeight(FontWeight.Medium)

        if (i % 2 === 0) {
          Tag({ text: '正在使用', color: '#24B277', bgColor: '#1F24B277' })
        }

        Blank()

        Checkbox({ name: 'checkbox' + j, group: 'checkboxGroup' + i })
          .select(this.insertMap[item.sourceUrl] ?? false)
          .selectedColor(this.theme.mainColor)
          .onChange((val: boolean) => {
            this.insertMap[item.sourceUrl] = val
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Blank()

      Row() {
        Text(this.updateNameMap[item.sourceUrl] ?? false ?
          '更新' : (this.alreadyNameMap[item.sourceUrl] ?? false ? '已有' : '新增'))
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
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .backgroundColor(Color.White)
  }

  @State isCatalogMove:boolean = false
  @State sourceGroupList:string[] = []


  @Builder catalogMove() {
    Column() {
      Column(){
        Text('导入至').fontSize(16).fontWeight(700).lineHeight(24)

      }.padding({right:20,left:20,top:12,bottom:12})

      Divider().strokeWidth(0.5)
      Scroll(){
        GridRow({
          columns:3,
        }){
          GridCol(){
            this.titleBuilder('')
          }
          ForEach(this.sourceGroupList, (item: string, index: number) => {
            GridCol(){
              this.titleBuilder(item)
            }

          })
        }
      }
      .padding(PaddingConstants.PADDING_20)
      .align(Alignment.Top)
      .height('65%')
      .scrollBar(BarState.Off)
      Divider().strokeWidth(0.5)
      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(()=>{
        this.isCatalogMove = false
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 32,
        right:32,
        top: 16
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
  }

  @Builder titleBuilder(title:string) {
    Column() {
      if (title === ''){
        Image($r('app.media.add')).width(24)
      } else {
        Text(title).fontSize(14).textOverflow({
          overflow:TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END).maxLines(1)
      }
    }
    .onClick(()=>{
      if(title === ''){
        this.addNewGroupType?.open()
        return
      } else {
        showMessage(title)
        this.sourceGroup = title
        this.isCatalogMove = false;
      }
    })
    .width(96).height(36)
    .margin({bottom:PaddingConstants.PADDING_16})
    .backgroundColor($r('app.string.color_black_6'))
    .padding({
      left:16,
      right:16,
      top:8,
      bottom:8
    })
  }
  @State newGroupType:string = ''
  addNewGroupType: CustomDialogController | null = new CustomDialogController({
    builder: addBookTypeDialog({
      cancel: ()=> { this.addNewGroupType?.close() },
      confirm: ()=> {
        this.addGroupType()
      },
      bookType: this.newGroupType
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 25
  })
  @State isInsert:boolean = false
  addGroupType(){
    programDataPreferences.getRssSourcesListData().map((data:string)=>{
      if(data === this.newGroupType){
        this.isInsert = true
      }
    })
    if (this.isInsert) {
      showMessage('分组名称重复')
      this.isInsert = false
    } else {
      programDataPreferences.updateRssSourcesData(this.newGroupType)
      //添加分组后再次刷新分组列表
      this.getRssSourceList()
      showMessage(`添加分组${this.newGroupType}成功!`)
    }
    this.newGroupType = ''
  }
}

