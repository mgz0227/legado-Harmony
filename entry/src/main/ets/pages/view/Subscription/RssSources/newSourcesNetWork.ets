/**
 * @author 2008
 * @datetime 2024/7/16 18:13
 * @className: newSources
 * 新建/修改常规网站
 */
import FontConstants from '../../../../common/constants/FontConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import { ThemeStorageKey } from '../../../../common/constants/Theme'
import { ThemeItem } from '../../../../common/model/Theme'
import { isNetworkUrl } from '../../../../common/utils/utils'
import buttonCommon from '../../../../componets/common/buttonCommon'
import { showMessage } from '../../../../componets/common/promptShow'
import FormItem from '../../../../componets/Form/FormItem'
import SubscriptionDao from '../../../../database/dao/SubscriptionDao'
import { rssSources, SUBSCRIPTION_GROUP_TYPE } from '../../../../database/entities/rssSources'
import programDataPreferences from '../../../../preferences/programDataPreferences'
import PreviewEffectImage from '../components/PreviewEffectImage'
import RssSourceCheckImage from '../components/RssSourceCheckImage'

@Component
export default struct newSourcesNetWork{
  hideNewWork:Function = ()=>{}
  @Prop isEdit:boolean = false
  // 主题颜色
  @StorageProp(ThemeStorageKey.THEME) theme: ThemeItem = {} as ThemeItem
  build() {
    Column(){
      Column(){
        Text(`${this.isEdit?'编辑':'添加'}网站`)
          .fontSize(FontConstants.FONT_SIZE_16)
          .fontWeight(FontConstants.FONT_WEIGHT_500)
          .lineHeight(24)
          .fontColor($r('app.string.color_black_88'))
          .textAlign(TextAlign.Center)
        this.baseForm()
      }
      .layoutWeight(1)
      .padding(PaddingConstants.PADDING_20)
      Divider()
      buttonCommon({
        cancel: ()=>{
           this.hideNewWork()
        },
        confirm: async ()=>{
          if (!this.formModel.sourceName || !this.formModel.sourceUrl) {
            this.scroller.scrollEdge(Edge.Top)
            showMessage('红星标记的内容不能为空')
            return
          }
          if (this.formModel.sourceIconIsUrl){
            if (!isNetworkUrl(this.formModel.sourceIcon ?? '')) {
              showMessage('复制的链接不正确')
              return
            }
          }
          let isInsert = await SubscriptionDao.insert(this.formModel)
          if (isInsert) {
            showMessage('保存成功')
          } else {
            showMessage('保存失败')
          }
          setTimeout(() => {
            this.hideNewWork()
          },1000)
        },
      })
      Flex()
        .bindSheet(this.isShowPresetIcon,this.showPresetIcon(),{
          height: 400,
          dragBar: true,
          showClose:false,
          onDisappear:()=>{
            this.isShowPresetIcon = false
          }
        })
    }
  }
  private scroller: Scroller = new Scroller()
  @State formModel: rssSources = {
    sourceName: '',
    sourceUrl: '',
    sourceIcon: '',
    sourceType: 0,
    sourceIconIsUrl: false,
    enabledCookieJar: false,
    lastUpdateTime: new Date().getTime(),
    customOrder: 0,
    autoComplete: false,
    sourceGroup: SUBSCRIPTION_GROUP_TYPE[4],
    enabled: true,
    singleUrl: true,
    showRecentIcon: true,
    customizeTitle: ''
  }
  aboutToAppear(): void {
    this.getRssSourceList()
  }
  @State sourceGroupList:SelectOption[] = []
  getRssSourceList() {
    let list = programDataPreferences.getRssSourcesListData()
    //将list存放到sourceGroupList
    list.forEach((item) => {
      this.sourceGroupList.push({
        value: item
      })
    })
  }
  @Builder
  baseForm() {
    Scroll(this.scroller) {
      Column() {
        FormItem({
          value: this.formModel.sourceName,
          label: '名称',
          isLength: true,
          maxLength: 5,
          required: true,
          onChange: (value: string) => {
            if (value?.length >= 6) {
              this.formModel.sourceName = value.slice(0, -1)
              return
            }
            this.formModel.sourceName = value
          }
        });

        FormItem({
          value: this.formModel.sourceUrl,
          label: '网址',
          required: true,
          onChange: (value: string) => {
            this.formModel.sourceUrl = value
          }
        });

        Column() {
          Row() {
            Row() {
              Text('分组')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Select(this.sourceGroupList)
              .selected(this.sourceGroupList.findIndex((item) => {
                return item.value === this.formModel.sourceGroup
              }))
              .value(this.formModel.sourceGroup?this.formModel.sourceGroup:SUBSCRIPTION_GROUP_TYPE[4])
              .borderRadius(4)
              .fontColor(this.formModel.sourceGroup !== undefined ? '#E0000000' : '#73000000')
              .onSelect((index: number, text?: string | undefined) => {
                if (text) {
                  this.formModel.sourceGroup = text
                }
              })
              .backgroundColor($r('app.string.color_black_6'))
              .layoutWeight(1)
          }
          .margin({ top: 10, bottom: 10 })
        }
        .margin({ top: 12 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Flex({
            justifyContent:FlexAlign.SpaceBetween
          }) {
            Row() {
              Text('图标')
                .fontSize(16)
            }
            .alignItems(VerticalAlign.Center)

            Row(){
              this.sourceIconIsUrl(
                this.formModel.sourceIconIsUrl ?? false,
                (val:boolean) => {
                  this.formModel.sourceIconIsUrl = val
                })
            }
          }
          if (this.formModel.sourceIconIsUrl){
            FormItem({
              value: this.formModel.sourceIcon,
              label: '图标链接',
              showTitle:false,
              onChange: (value: string) => {
                this.formModel.sourceIcon = value
              }
            })
          } else {
            Flex({
              justifyContent:FlexAlign.SpaceBetween
            }) {
              Row() {
                Text('选择本地图片')
                  .textAlign(TextAlign.Center)
                  .fontSize(16)
                  .padding({ top: 8,bottom:8,right:12,left:12 })
              }
              .justifyContent(FlexAlign.Center)
              .width('48%')
              .backgroundColor($r('app.string.color_black_6'))

              Row() {
                Text('预设图标')
                  .textAlign(TextAlign.Center)
                  .fontSize(16)
                  .padding({ top: 8,bottom:8,right:12,left:12 })
              }
              .justifyContent(FlexAlign.Center)
              .width('48%')
              .backgroundColor($r('app.string.color_black_6'))
              .onClick(() => {
                this.isShowPresetIcon = true
              })
            }
            .margin({ top: 12 })
          }
          if (!this.formModel.sourceIconIsUrl && this.formModel.customizeTitle){
            PreviewEffectImage({
              customizeTitle:this.formModel.customizeTitle,
              sourceIcon:this.formModel.sourceIcon,
              sourceIconIsUrl:this.formModel.sourceIconIsUrl
            })
          }
        }
        .margin({ top: 12,left:20,right:20 })
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
    }
    .align(Alignment.Top)
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  sourceIconIsUrl(sourceIconIsUrl: boolean, onChange: (_val: boolean) => void) {
    Row() {
      Text('使用链接')

      Toggle({ type: ToggleType.Switch, isOn: sourceIconIsUrl })
        .selectedColor(this.theme.mainColor)
        .margin({ left: 8 })
        .onChange((val: boolean) => {
          onChange(val)
        })
    }
  }

  @State isShowPresetIcon:boolean = false
  @Builder
  showPresetIcon(){
    Grid(){
      GridItem(){
        RssSourceCheckImage({
          onCancel:()=>{
            this.isShowPresetIcon = false
          },
          onSubmit:(value:string, imageString:string)=>{
            this.formModel.customizeTitle = value
            this.formModel.sourceIcon = imageString
            this.isShowPresetIcon = false
          }
        })
      }
    }
  }
}