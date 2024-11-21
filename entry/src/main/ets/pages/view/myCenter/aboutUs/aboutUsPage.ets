import { dataItem } from 'ets/componets/dataList/dataItem';
import VersionUpdateCustomDialog from 'ets/componets/aboutUs/VersionUpdate';
import { router } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';
import { productViewManager } from '@kit.StoreKit';

@Entry
@Component
struct AboutUsPage {
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink('topRectHeight') topRectHeight: number = 0
  @State isShowQQ: boolean = false
  @State version: string = "V1.0.0.1"
  @State first_list: dataItem[] = [
    new dataItem("检查更新", 1),
    new dataItem("更新日志", 2),
    new dataItem("开发人员", 3),
  ];
  @State end_list: dataItem[] = [
    new dataItem("用户隐私与协议", 1),
    new dataItem("开源许可", 2),
    new dataItem("免责声明", 3),
    new dataItem("崩溃日志", 4),
  ]
  // 升级弹窗
  dialogController: CustomDialogController = new CustomDialogController({
    builder: VersionUpdateCustomDialog({}),
    cornerRadius: 16,
    gridCount: 3,
    alignment: DialogAlignment.Center,
  })
  @State qqList: Array<string> = [
    'Beta群:887615035'

  ]

  firstUrl_list(value: number | string) {
    switch (value) {
      case 0:
      // 升级弹窗
      //   this.dialogController.open()
      // 跳转到应用市场
        try {
          const request: Want = {
            parameters: {
              bundleName: 'com.legado.app'
            }
          };
          productViewManager.loadProduct(getContext(this) as common.UIAbilityContext, request, {
            onError: (error: BusinessError) => {
              hilog.info(0, 'TAG', `loadProduct onError. code is ${error.code}, message is ${error.message}`);
            }
          });
        } catch (err) {
          hilog.error(0, 'TAG', `loadProduct failed. code is ${err.code}, message is ${err.message}`);
        }
        break
      case 1:
      // 更新日志
        router.pushUrl({
          url: "pages/view/myCenter/aboutUs/versionLogPage"
        })
        break
      case 2:
      //todo 开发人员
        break
    }
  }

  endUrl_list(value: number | string) {
    switch (value) {
      case 0:
      //用户隐私与协议
        router.pushUrl({
          url: "pages/view/myCenter/aboutUs/PrivacyAgreementPage"
        })
        break
      case 1:
      //开源许可
        router.pushUrl({
          url: "pages/view/myCenter/aboutUs/OpenSourceLicensePage"
        })
        break
      case 2:
      //免责声明
        router.pushUrl({
          url: "pages/view/myCenter/aboutUs/DisclaimerPage"
        })
        break
      case 3:
      //todo 崩溃日志
        break
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Flex() {
          Column() {
            Image($r("app.media.return_left"))
              .size({ width: 24, height: 24 })
              .interpolation(ImageInterpolation.Medium)
              .onClick(() => {
                router.back()
              })
          }
          .alignItems(HorizontalAlign.Start)
          .width('33%')

          Column() {
            Text(`关于我们`)
              .lineHeight(24)
              .font({
                family: "PingFang SC",
                size: 16,
                weight: 500,
                style: FontStyle.Normal,
              })
          }.width('33%')
        }
        .padding({
          top: 12,
          bottom: 12,
        })
        .height(48)
        .width("100%")

        this.middleClick(this.first_list, "app.media.right", this.version, "first")

        Grid() {
          GridItem() {
            this.middleBox(0, "app.media.official_website", "官网")
          }

          GridItem() {
            this.middleBox(1, "app.media.wechat_public_account", "公众号")
          }

          GridItem() {
            this.middleBox(2, "app.media.channel", "QQ频道")
          }

          GridItem() {
            this.middleBox(3, "app.media.QQ", "QQ群")
          }
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(16)
        .height(80)
        // QQ群的半模态框 不知道绑定在哪里，鸿蒙官方怎么想的，非要绑定一个元素？
        .bindSheet($$this.isShowQQ, this.QQDialog(), {
          height: 300,
          showClose: false,
          dragBar: false,
          blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
          onDisappear: () => {
            // this.clickBookType = ''
          }
        })

        this.middleClick(this.end_list, "app.media.right", null, "end")
      }
      .padding({
        left: 20,
        right: 20,
        top: this.topRectHeight,
        bottom: this.bottomRectHeight
      })
      .height("100%")
      .backgroundColor("rgb(245, 245, 245)")
    }
  }

  @Builder
  middleBox(index: number, image: string, text: string) {
    Column({ space: 2 }) {
      Image($r(`${image}`)).size({ width: 24, height: 24 })
      Text(text)
        .maxLines(1)
        .lineHeight(20)
        .font({
          // family: "PingFang SC",
          size: 12,
          weight: 400,
          style: FontStyle.Normal,
        })
        .opacity(0.45)
    }
    .padding({
      top: 12,
      bottom: 12
    })
    .width("100%")
    .height(70)
    .borderRadius(12)
    .backgroundColor(Color.White)
    .onClick(() => {
      switch (index) {
        case 0:
          break
        case 1:
          break
        case 2:
          break
        case 3:
          this.isShowQQ = true
          break
      }
    })
  }

  @Builder
  middleClick(list: Array<dataItem>, image: string, version: string | null, urlList: string) {
    Column() {
      ForEach(list, (item: dataItem, index) => {
        Row() {
          Text(item.title)
            .lineHeight(22)
            .font({
              // family: "PingFang SC",
              size: 16,
              weight: 400,
              style: FontStyle.Normal,
            })
          Blank(20)
          if (version && index === 0) {
            Text(version)
              .lineHeight(20)
              .font({
                // family: "PingFang SC",
                size: 12,
                weight: 400,
                style: FontStyle.Normal,
              })
              .baselineOffset(4)
              .opacity(0.45)
              .margin({
                right: 4
              })
          }
          Image($r(`${image}`)).size({ width: 24, height: 24 })
        }
        .width("100%")
        .height(48)
        .onClick(() => {
          switch (urlList) {
            case 'first':
              this.firstUrl_list(index)
              break
            case 'end':
              this.endUrl_list(index)
              break
          }
        })
      })
    }

    .padding({
      top: 12,
      bottom: 12,
      left: 20,
      right: 20
    })
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  @Builder
  QQDialog() {
    Column() {
      Column() {
        Row() {
          Text("QQ群")
            .lineHeight(24)
            .font({
              family: "PingFang SC",
              size: 16,
              style: FontStyle.Normal,
              weight: 500,
            })
        }
        .justifyContent(FlexAlign.Center)
        .height(48)
        .width("100%")

        Scroll() {
          Column() {
            ForEach(this.qqList, (item: string) => {
              Row() {
                Text(item)
                  .lineHeight(22)
                  .fontColor("#000000")
                  .font({
                    family: "PingFang SC",
                    size: 14,
                    style: FontStyle.Normal,
                    weight: 400,
                  })
                Blank(20)
                Image($r('app.media.right'))
                  .width(24)
                  .height(24)
                  .margin({
                    right: 5
                  })
              }
              .margin({
                top: 12,
                bottom: 12
              })
              .width('100%')
            })
          }
        }
        .height('60%')
        .scrollBar(BarState.Off)
      }
      .padding({
        left: 20,
        right: 20
      })


      Divider()

      Column() {
        Text('取消').fontSize(16).fontWeight(400)
          .lineHeight(24)
      }
      .onClick(() => {
        this.isShowQQ = true
      })
      .alignItems(HorizontalAlign.Center)
      .padding({
        left: 32,
        right: 32,
        top: 16
      })
    }

    // .width(CommonConstants.FULL_WIDTH)
    // .height(CommonConstants.FULL_HEIGHT)
  }
}
