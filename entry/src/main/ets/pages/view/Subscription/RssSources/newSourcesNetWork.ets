/**
 * @author 2008
 * @datetime 2024/7/16 18:13
 * @className: newSources
 * 新建/修改常规网站
 */
import FontConstants from '../../../../common/constants/FontConstants'
import PaddingConstants from '../../../../common/constants/PaddingConstants'
import buttonCommon from '../../../../componets/common/buttonCommon'
import { showMessage } from '../../../../componets/common/promptShow'
import FormItem from '../../../../componets/Form/FormItem'
import SubscriptionDao from '../../../../database/dao/SubscriptionDao'
import { rssSources, SUBSCRIPTION_GROUP_TYPE } from '../../../../database/entities/rssSources'

@Component
export default struct newSourcesNetWork{
  hideNewWork:Function = ()=>{}
  @Prop isEdit:boolean = false
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
          if(this.formModel.sourceIcon === ''){
            this.formModel.sourceIcon = 'app.media.icon'
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
    sourceGroup: SUBSCRIPTION_GROUP_TYPE[0],
    enabled: true,
    singleUrl: true,
    showRecentIcon: true
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
            Select([
              { value: '小说' },
              { value: '漫画' },
              { value: '影视' },
              { value: '咨询' },
              { value: '收藏夹' }
            ])
              .value(this.formModel.sourceGroup.length === 0?SUBSCRIPTION_GROUP_TYPE[0]:this.formModel.sourceGroup)
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
                (val) => {
                  this.formModel.sourceIconIsUrl = val
                })
            }
          }
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
        .selectedColor(0xff6600)
        .margin({ left: 8 })
        .onChange((val: boolean) => {
          onChange(val)
        })
    }
  }
}