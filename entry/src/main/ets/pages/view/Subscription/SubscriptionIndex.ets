/**
 * @author 2008
 * @datetime 2024/7/11 21:33
 * @className: Subscription
 * 新版订阅页面
 */
import CommonConstants from '../../../common/constants/CommonConstants'
import FontConstants from '../../../common/constants/FontConstants'
import ImageConstants from '../../../common/constants/ImageConstants'
import PaddingConstants from '../../../common/constants/PaddingConstants'
import { IconTitleVo } from '../../../componetsmodel/IconTitleVo'
import { router } from '@kit.ArkUI'
import SubscriptionContent from './components/SubscriptionContent'
import { showMessage } from '../../../componets/common/promptShow'
import { getPasteDataSync, sleep } from '../../../common/utils/utils'
import axios, { AxiosResponse } from '@ohos/axios'
import { rssGroupList, rssSources } from '../../../database/entities/rssSources'
import SubscriptionImport from '../../../componets/import/SubscriptionImport'
import subscriptionDao from '../../../database/dao/SubscriptionDao'
import dialogNewSources from './RssSources/dialogNewSources'

@Component
export default struct SubscriptionIndex {
  @State isShowImport: boolean = false
  @State isShowNewSources:boolean = false
  @Prop @Watch('currentTabIndexChange')currentTabIndex: number
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State
  moreList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_rule_paste'), '粘贴导入'),
    new IconTitleVo($r('app.media.icon_rule_export'), '本地导入'),
    new IconTitleVo($r('app.media.icon_rule_add'), '新建订阅'),
    new IconTitleVo($r('app.media.icon_rule_batch'), '批量管理'),
  ]

  @State loading: boolean = false
  //刷新
  refresh = ()=>{
    this.resetState()
    this.getList()
  }

  @State subscriptionList:rssSources[]=[]


  @State rssSourcesList:rssSources[] = []
  @State groupList: rssGroupList[] =[]
  currentTabIndexChange(){
    this.refresh()
  }

  // aboutToAppear() {
  //   showMessage('显示了')
  //   this.getList()
  // }

  resetState() {
    this.subscriptionList = []
    this.groupList = []
  }

  getList() {
    subscriptionDao.search().then(data => {
      const rssSources = data ?? []
      console.info('TagInfo', JSON.stringify(rssSources.slice(0, 3)))
      this.rssSourcesList = rssSources
      this.getGroupList()
    }).catch(() => {

    })
  }

  getGroupList() {
    const groupMap: Record<string, rssGroupList> = {};
    this.rssSourcesList.forEach((item: rssSources) => {
      const title = item.sourceGroup;
      if (title) {
        // 如果groupMap中还没有这个group，则创建一个新的GroupList对象
        if (!groupMap[title]) {
          groupMap[title] = { title: title, list: [] };
        }
        // 向当前group的list中添加BookSource对象
        groupMap[title].list.push(item);
      }

    })
    this.groupList = Object.values(groupMap)
  }



  build() {
    Column(){
      //搜索Start
      Flex(
        {
          direction:FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }
      ) {
        Row({
          space:CommonConstants.SPACE_20
        }) {
          Image($r('app.media.icon_subscription_index')).width(CommonConstants.COMMON_WIDTH_45_36).height(CommonConstants.COMMON_HEIGHT_21_6)
          Search({ placeholder: '搜索订阅', icon: "/common/images/search.svg" })
            .layoutWeight(1)
            .height(CommonConstants.COMMON_HEIGHT_40)
            .backgroundColor(Color.White)
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/view/Subscription/components/SubscriptionSearch'
              })
            })
            .focusOnTouch(false) //不可获取焦点
        }
        .padding({right: PaddingConstants.PADDING_16})
        Image($r('app.media.addSubscription')).width(ImageConstants.IMG_WIDTH_24).height(ImageConstants.IMG_HEIGHT_24).bindMenu(this.MenuBuilder)
      }
      .height('8%')
      //搜索End
      //最近使用Start
      if (this.RecentlyUsed.length !== 0){
        Column(){
          Flex({
            justifyContent:FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Text('最近使用')
              .font({
                size:12,
                weight:FontConstants.FONT_WEIGHT_500,
                family: CommonConstants.FAMILY_PingFANG
              })
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(20)
              .padding({
                top: PaddingConstants.PADDING_12,
                bottom: PaddingConstants.PADDING_12
              })

            Text('清空')
              .font({
                size:12,
                weight:FontConstants.FONT_WEIGHT_400,
                family: CommonConstants.FAMILY_PingFANG
              })
              .fontColor($r('app.string.color_black_45'))
              .lineHeight(20)
              .padding({
                top: PaddingConstants.PADDING_12,
                bottom: PaddingConstants.PADDING_12
              })
              .onClick(()=>{
                this.RecentlyUsed = []
                showMessage('已清空最近使用')
              })
          }
          this.RecentlyUsedBuilder()
        }
      }
      if (this.loading) {
        Column() {
          LoadingProgress()
            .color(0xff6600)
            .width('50%')
          Text('加载中...')
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else if (!this.groupList.length) {
        Column() {
          Image($r('app.media.find_empty'))
            .width(124)
            .height(120)

          Text(`暂无订阅源，点击右上角加号添加吧~`)
            .fontSize(14)
            .fontColor('#73000000')
            .margin({ top: 32 })
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      } else {
        Scroll(){
          Column(){
            ForEach(this.groupList,(item:rssGroupList)=>{
              SubscriptionContent({
                subscriptionTitle: item.title,
                contentList: item.list,
                refresh:this.refresh
              })
            })
          }
        }
        .align(Alignment.Top)
        .padding({bottom:20})
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
      }

      Flex()
        .bindSheet($$this.isShowImport,this.dialogImportFunction(),{
          detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE, 200],
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowImport = false
          }
        })

      Flex()
        .bindSheet($$this.isShowNewSources,this.dialogNewSourcesFunction(),{
          height: 200,
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowNewSources = false
          }
        })
    }
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      colors: [["rgb(254, 203, 169)", 0], ["RGB(245, 245, 245)", 0.2]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .padding({
      top: this.topRectHeight,
      left: PaddingConstants.PADDING_20,
      right: PaddingConstants.PADDING_20
    }
    )
    .height('100%')
  }

  //最近使用列
  @State
  RecentlyUsed: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_subscription_lazy'), '懒人听书'),
    new IconTitleVo($r('app.media.icon_subscription_inn'), '漫客栈'),
    new IconTitleVo($r('app.media.icon_subscription_start'), '起点中文'),
    new IconTitleVo($r('app.media.icon_subscription_tencent'), '腾讯动漫'),
    new IconTitleVo($r('app.media.icon_subscription_college'), '潇湘书院'),
  ]

  @Builder
  RecentlyUsedBuilder(){
    GridRow({
      columns: 5
    }){
      ForEach(this.RecentlyUsed,(item:IconTitleVo)=>{
        GridCol(){
          Column({
            space: CommonConstants.SPACE_6
          }){
            Image(item.icon)
              .width(ImageConstants.IMG_WIDTH_40)
              .height(ImageConstants.IMG_HEIGHT_40)
              .borderRadius(50)

            Text(`${item.title}`).fontSize(10)
              .fontColor($r('app.string.color_black_88'))
              .lineHeight(18)
              .fontFamily(CommonConstants.FAMILY_PingFANG)
              .fontWeight(FontConstants.FONT_WEIGHT_400)
          }
        }
      })

    }
  }


  //漫画列
  @State
  cartoonList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_subscription_quick_see'), '快看漫画'),
    new IconTitleVo($r('app.media.icon_subscription_dongman'), '咚漫漫画'),
    new IconTitleVo($r('app.media.icon_subscription_inn'), '漫客栈'),
    new IconTitleVo($r('app.media.icon_subscription_bosom_friend'), '知音漫客'),
    new IconTitleVo($r('app.media.icon_subscription_podo'), 'PODO'),
  ]

  @Builder dialogImportFunction() {
    Flex() {
      SubscriptionImport({
      subscriptionList:this.subscriptionList
      ,show: this.isShowImport
      }).onDisAppear(()=>{
        this.refresh()
      })
    }
  }

  @Builder dialogNewSourcesFunction() {
    Column(){
      dialogNewSources({
        btnClick:()=>{
          this.isShowNewSources = false
        }
      }).onDisAppear(()=>{
        this.refresh()
      })

    }
  }


  //小说列
  @State
  novelList: IconTitleVo[] = [
    new IconTitleVo($r('app.media.icon_subscription_qq'), 'QQ阅读'),
    new IconTitleVo($r('app.media.icon_subscription_red'), '红袖读书'),
    new IconTitleVo($r('app.media.icon_subscription_zongheng'), '纵横小说'),
    new IconTitleVo($r('app.media.icon_subscription_17k'), '17K小说'),
    new IconTitleVo($r('app.media.icon_subscription_college'), '潇湘书院'),
    new IconTitleVo($r('app.media.icon_subscription_xigua'), '番茄小说'),
    new IconTitleVo($r('app.media.icon_subscription_shuqi'), '书旗小说'),
    new IconTitleVo($r('app.media.icon_subscription_motie'), '磨铁阅读'),
    new IconTitleVo($r('app.media.icon_subscription_feilu'), '飞卢小说'),
    new IconTitleVo($r('app.media.icon_subscription_yanyan'), '盐言故事'),
  ]

  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column }) {
      ForEach(this.moreList, (item: IconTitleVo, index) => {
        Column() {
          Row() {
            Image(item.icon)
              .width(24)
              .height(24)
              .margin({
                right: 5
              })
            Text(`${item.title}`).fontSize(14)
          }
          .height(40)
          .justifyContent(FlexAlign.Center)
          .align(Alignment.Center)
          .onClick(() => {
            this.MenuOnclick(index)
          })

          if(index !== 5){
            Divider()
          }
        }
        .padding(5)
        .height(40)
        .margin({ bottom: 20 })
      })
    }
    .width(100)
  }



  MenuOnclick(value:number|string){
    switch (value){
      case 0:
        this.pasteAnalyze();
        break;
      case 1:

        break
      case 2:
        this.isShowNewSources =true
        break;
      case 3:
        break
      case 4:

        break

    }
  }

  async pasteAnalyze() {
    try {
      const url = getPasteDataSync()
      if (!url) {
        showMessage('未获取到粘贴信息，请求默认数据')
        await sleep()
        // return
      }
      showMessage('订阅加载中')
      // if (!isNetworkUrl(url ?? '')) {
      //   showMessage('复制的链接不正确')
      //   return
      // }
      const res: AxiosResponse = await axios
        .get(url ?? 'http://yuedu.miaogongzi.net/shuyuan/miaogongziDY.json');
      console.log('res', JSON.stringify(res))
      this.subscriptionList = res.data;
      this.isShowImport = true;
    } catch (err) {
      console.error('错误 ' + err);
    }
  }
}