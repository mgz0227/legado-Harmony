/**
 * @author 2008
 * @datetime 2024/5/23 22:21
 * @className: shareShelfBook
 */
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { buttonList } from '../../../componets/dataList/buttonList'
import componentSnapshot from '@ohos.arkui.componentSnapshot'
import image from '@ohos.multimedia.image'
import fs from '@ohos.file.fs';
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { showMessage } from '../../../componets/common/promptShow'
import { abilityAccessCtrl, common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { WorksLists } from '../../../database/entities/WorksLists'
import worksListsUtils from '../../../common/utils/WorksListsUtils'
import BooksDao from '../../../database/dao/BooksDao'
import { Books } from '../../../database/entities/Books'
import PaddingConstants from '../../../common/constants/PaddingConstants'

@CustomDialog
@Preview
@Component
export default struct shareWorksBook {
  controller?: CustomDialogController
  @Prop works:WorksLists
  @State buttonListInfo: buttonList[] = [
    new buttonList(1, '微信', $r('app.media.wechat')),
    new buttonList(2, 'QQ', $r('app.media.QQ_blue')),
    new buttonList(3, '朋友圈', $r('app.media.circle_friends')),
    new buttonList(4, 'QQ空间', $r('app.media.QQ_space')),
    new buttonList(5, '导出本地', $r('app.media.export')),
    new buttonList(6, '复制链接', $r('app.media.copy_link')),
    new buttonList(7, '保存图片', $r('app.media.save_img')),
    new buttonList(8, '系统分享', $r('app.media.more'))
  ]
  @State bookList:Books[] = []

  async aboutToAppear(): Promise<void> {
    if (this.works.worksBookList) {
      let bookIds = worksListsUtils.getBookIds(this.works.worksBookList)
      if (bookIds.length > 0) {
        this.getBookIds(bookIds)
      }
    }
  }
  private appContext: common.Context = getContext(this);
  private atManager = abilityAccessCtrl.createAtManager();
  getBookIds(ids:number[]){
    BooksDao.getBookByIds(ids).then((val)=>{
      this.bookList = val
    })
  }

  build() {
    Stack() {
      Rect()
        .height('100%')
        .width('100%')
        .backgroundColor(Color.Black)
        .onClick(() => {
          this.controller?.close()
        })
        .opacity(0.15)
        .zIndex(1)
      Flex({
        direction:FlexDirection.Column,
        justifyContent:FlexAlign.SpaceBetween
      }){
        Column({
          space:PaddingConstants.PADDING_10
        }){
          Text(this.works.worksName)
            .textAlign(TextAlign.Center)
            .fontSize(16).fontWeight(500).lineHeight(24).fontColor($r('app.string.color_black_88'))
          Text(this.works.worksDescribe)
            .textAlign(TextAlign.Center)
            .fontSize(12).fontWeight(400).lineHeight(20).fontColor($r('app.string.color_black_88'))
          Column({
            space:PaddingConstants.PADDING_15
          }){
            ForEach(this.bookList,(item:Books,index)=>{
              this.BookShelfInfo(item,index)
            })
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin(40)
      .padding({ top: 24, left: 20, right: 20, bottom: 24 })
      .backgroundColor(Color.White)
      .zIndex(2)
      //用于图片保存不做显示
      Column(){
        Column({
          space:10
        }){
          Text(this.works.worksName)
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontWeight(500)
            .lineHeight(24)
            .fontColor($r('app.string.color_black_88'))
          Text(this.works.worksDescribe)
            .textAlign(TextAlign.Center)
            .fontSize(12)
            .fontWeight(400)
            .lineHeight(20)
            .fontColor($r('app.string.color_black_88'))

          Column({
            space:PaddingConstants.PADDING_15
          }){
            ForEach(this.bookList.slice(0, 4),(item:Books,index)=>{
              this.BookShelfInfo(item,index)
            })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .padding({ top: 24, left: 20, right: 20, bottom: 24 })
        .backgroundColor('#FFF7EC')
        this.footerSaveImage()
      }
      .id('shareBook')
      .margin(40)
      .position({y: 0})
      .visibility(Visibility.Hidden)

      Column() {
        Column() {
          Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
        }
        .padding({ top: 12, bottom: 28 })

        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Start
        }) {

        }
        GridRow({
          columns:4
        }){
          ForEach(this.buttonListInfo, (item: buttonList) => {
            GridCol(){
              InsideCircleIcon({
                icon: item.icon,
                title:item.title
              }).onClick(() => {
                switch (item.id) {
                  case 1:
                    showMessage('跳转微信');
                    break;
                  case 2:
                    showMessage('跳转QQ');
                    break;
                  case 3:
                    showMessage('跳转朋友圈');
                    break;
                  case 4:
                    showMessage('跳转QQ空间');
                    break;
                  case 5:
                    showMessage('导出本地成功');
                    break;
                  case 6:
                    showMessage('已复制链接');
                    break;
                  case 7:
                    this.requestPermissionSaveImage();
                    break;
                  case 8:
                    showMessage('系统分享');
                    break;
                }
              })
            }
          })
        }

        Column() {
          this.footerTitle()
        }
        .borderRadius(8)
        .margin({ left: 20, right: 20, bottom: 20 })
        .backgroundColor($r('app.color.share_shelf_book_background'))
      }
      .zIndex(3)
      .borderRadius({ topLeft: 20, topRight: 20 })
      .backgroundColor(Color.White)
    }
    .align(Alignment.Bottom)
  }
  @State pixmap: image.PixelMap | undefined = undefined
  //申请权限,保存图片
  async requestPermissionSaveImage() {
    try {
      this.atManager.requestPermissionsFromUser(this.appContext,['ohos.permission.WRITE_IMAGEVIDEO']).then(async ()=>{
       componentSnapshot.get('shareBook').then((pixmap: image.PixelMap)=>{
          this.pixmap = pixmap
          const imagePackerApi = image.createImagePacker();
          let packOpts : image.PackingOption = { format:"image/jpeg", quality:98 };

          imagePackerApi.packing(pixmap, packOpts).then(async (data : ArrayBuffer) => {
            let context = getContext();
            let helper = photoAccessHelper.getPhotoAccessHelper(context);
            let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
            let file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            await fs.write(file.fd, data);
            await fs.close(file.fd);
            showMessage('保存成功');
          }).catch((error : BusinessError) => {
            showMessage('保存失败,未获取权限');
            console.error('Failed to pack the image. And the error is: ' + error);
          })
        });
      })
    } catch (e) {
      showMessage('保存失败,未获取权限');
    }
  }

  @State validDate:string = '7天有效'
  @State footerDialogShow:boolean = false
  @Builder footerTitle(){
    Flex({
      direction:FlexDirection.Row,
      justifyContent:FlexAlign.SpaceBetween
    }){
      Text('链接有效期').fontColor($r('app.string.color_black_88')).fontSize(12).fontWeight(400).lineHeight(20).textAlign(TextAlign.Center)
      Row({
        space:8
      }){
        Text(this.validDate).fontColor($r('app.string.color_black_45')).fontSize(12).fontWeight(400)
        Image($r('app.media.icon_right')).width(24).height(24).fillColor(($r('app.string.color_black_45')))
      }
    }
    .onClick(()=>{
      this.footerDialogShow = true
    })
    .bindSheet($$this.footerDialogShow,this.footerDialog(), {
      height:200,
      showClose: false,
      blurStyle:BlurStyle.COMPONENT_ULTRA_THIN,
      maskColor: 'rgba(0,0,0,0.6)',
      onDisappear:()=>{
        this.footerDialogShow = false
      }
    })
    .padding(16)
  }

  @Builder footerSaveImage(){
    Flex({
      justifyContent:FlexAlign.SpaceBetween,
      direction:FlexDirection.Row,
      alignItems:ItemAlign.Center
    }
    ){
      Column(){
        Row({
          space:5
        }){
          Image($r('app.media.legado_icon')).width(32).height(20)
          Image($r('app.media.legado')).width(65).height(15)
        }
        Text('扫描二维码下载 开源阅读').fontSize(10).fontWeight(400).lineHeight(18).textAlign(TextAlign.Center)
      }
      Image($r('app.media.QR_Code')).width(46).height(46)
    }
    .backgroundColor(Color.White)
    .padding({ top: 24,bottom:24, left: 20, right: 20 })
  }


  @Builder footerDialog(){
    Column(){
      Text('链接有效日期')
        .fontColor($r('app.string.color_black_88'))
        .textAlign(TextAlign.Center)
        .padding({top:12,bottom:12})
        .lineHeight(24)
        .fontWeight(500)
    }
    Column(){
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }
      ){
        Text('7天')
          .fontColor($r('app.string.color_black_88'))
          .textAlign(TextAlign.Center)
          .padding({top:12,bottom:12})
          .lineHeight(24)
          .fontWeight(500)

        Image(this.validDate === '7天有效'?$r('app.media.hook'):'').width(24).height(24)
      }
      .onClick(()=>{
        this.validDate = '7天有效'
        this.footerDialogShow = false
        showMessage('修改成功')
      })
      Flex({
        justifyContent:FlexAlign.SpaceBetween,
        alignItems:ItemAlign.Center
      }
      ){
        Text('永久有效')
          .fontColor($r('app.string.color_black_88'))
          .textAlign(TextAlign.Center)
          .padding({top:12,bottom:12})
          .lineHeight(24)
          .fontWeight(500)
        Image(this.validDate === '永久有效'?$r('app.media.hook'):'').width(24).height(24)
      }
      .onClick(()=>{
        this.validDate = '永久有效'
        this.footerDialogShow = false
        showMessage('修改成功')
      })
    }.padding({left:20,right:20})

    Column(){
      Text('取消').fontSize($r('app.string.color_black_88')).textAlign(TextAlign.Center).fontSize(16).fontWeight(400).lineHeight(24)
    }.padding({left:32,right:32,top:16,bottom:16})
    .onClick(()=>{
      this.footerDialogShow = false
    })

  }

  @Builder BookShelfInfo(book:Books,index:number){
    Column(){
      Row({
        space:PaddingConstants.PADDING_10
      }){
        Image(book.coverUrl)
          .draggable(false)
          .alt($r('app.media.icon_book_default_cover_one'))
          .width(69)
          .height(92)

        Column({
          space:10
        }) {
          Text(book.bookName).fontSize(16).fontWeight(500).lineHeight(24)
            .textOverflow({
              overflow:TextOverflow.Ellipsis
            })
            .ellipsisMode(EllipsisMode.END)
            .maxLines(2)
            .position({y: 0})
          Text(book.intro)
            .fontSize(12)
            .lineHeight(20)
            .fontColor('rgba(0, 0, 0, 0.45)')
            .textOverflow({
              overflow:TextOverflow.Ellipsis
            })
            .height(50)
            .ellipsisMode(EllipsisMode.END)
            .maxLines(2)
          Row(){
            Text('卖报小郎君·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('玄幻·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('完本·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('380万字').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
          }
        }
      }

      if (this.works.worksBookList && this.works.worksBookList[index].recommend){
        Column(){
          Text(this.works.worksBookList[index].recommend ?? '')
            .padding({
              top:PaddingConstants.PADDING_8,
              bottom:PaddingConstants.PADDING_8,
              left:PaddingConstants.PADDING_12,
              right:PaddingConstants.PADDING_12
            })
        }
        .borderRadius(8)
        .margin({
          top:PaddingConstants.PADDING_16
        })
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .backgroundColor($r('app.string.color_black_4'))
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}