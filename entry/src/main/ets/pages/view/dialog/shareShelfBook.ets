/**
 * @author 2008
 * @datetime 2024/5/23 22:21
 * @className: shareShelfBook
 */
import InsideCircleIcon from '../../../componets/common/InsideCircleIcon'
import { BookList } from '../../../componets/dataList/bookList'
import { buttonList } from '../../../componets/dataList/buttonList'
import { shelfList } from '../../../componets/dataList/shelfList'
import componentSnapshot from '@ohos.arkui.componentSnapshot'
import image from '@ohos.multimedia.image'
import fs from '@ohos.file.fs';
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { showMessage } from '../../../componets/common/promptShow'
import fileIo from '@ohos.file.fs'
import { picker } from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'

@CustomDialog
@Preview
@Component
export default struct shareShelfBook {
  controller?: CustomDialogController
  @Prop shelf: shelfList = new shelfList(1,'测试书单','测试书单描述','测试书单描述理由',[
    new BookList('1','仙人消失之后','会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'玄幻')])
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
        Column(){
          Text(this.shelf.title)
            .textAlign(TextAlign.Center)
            .fontSize(16).fontWeight(500).lineHeight(24).fontColor($r('app.string.color_black_88'))
          Text(this.shelf.describe)
            .textAlign(TextAlign.Center)
            .fontSize(12).fontWeight(400).lineHeight(20).fontColor($r('app.string.color_black_88'))
            .margin({top:12})
          Column(){
            ForEach(this.shelf.bookList,(item:BookList,index:number)=>{
              this.BookShelfInfo(item,index)
            })
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin(40)
      .padding({top:24,left:20,right:20})
      .width('80%')
      .backgroundColor(Color.White)
      .zIndex(2)
      //用于图片保存不做显示
      Column(){
        Column() {
          Text(this.shelf.title)
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontWeight(500)
            .lineHeight(24)
            .fontColor($r('app.string.color_black_88'))
          Text(this.shelf.describe)
            .textAlign(TextAlign.Center)
            .fontSize(12)
            .fontWeight(400)
            .lineHeight(20)
            .fontColor($r('app.string.color_black_88'))
            .margin({ top: 12 })
          ForEach(this.shelf.bookList, (item: BookList, index: number) => {
            this.BookShelfInfo(item, index)
          })
        }
        .alignItems(HorizontalAlign.Start)
        .padding({ top: 24, left: 20, right: 20,bottom:12 })
        .backgroundColor('#FFF7EC')
        this.footerSaveImage()
      }
      .id('shareBook')
      .margin(40)
      .position({y: 0})
      .zIndex(0)

      Column() {
        Column() {
          Row().width(36).height(4).backgroundColor($r('app.string.color_black_15')).borderRadius(12)
        }
        .padding({ top: 12, bottom: 28 })

        Flex({
          direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Start
        }) {
          ForEach(this.buttonListInfo, (item: buttonList) => {
            InsideCircleIcon({
              item: item
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
                  showMessage('保存成功');
                  // this.saveSnapshot();
                  break;
                case 8:
                  showMessage('系统分享');
                  break;
              }
            })
          })

          // SaveButton().onClick((e: ClickEvent, result: SaveButtonOnClickResult) => {
          //   this.saveSnapshot()
          // })
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

  saveSnapshot() {
    componentSnapshot.get('shareBook', async (error: Error, pixmap: image.PixelMap) => {
      if (error) {
        console.log("error: " + JSON.stringify(error))
        return;
      }
      this.pixmap = pixmap
      const imagePackerApi = image.createImagePacker();
      let packOpts : image.PackingOption = { format:"image/jpeg", quality:98 };

      imagePackerApi.packing(pixmap, packOpts).then( (data : ArrayBuffer) => {
        this.saveImage(data)
      }).catch((error : BusinessError) => {
        console.error('Failed to pack the image. And the error is: ' + error);
      })
    })
  }

  async saveImage(buffer: ArrayBuffer | string): Promise<void> {
    let context = getContext(this) as common.UIAbilityContext;
    let helper = photoAccessHelper.getPhotoAccessHelper(context);
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
    let file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    await fs.write(file.fd, buffer);
    await fs.close(file.fd);
  }

  @State validDate:string = '7天有效'
  @State pixmap: image.PixelMap | undefined = undefined
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

  @Builder BookShelfInfo(book:BookList,index:number){
    Column(){
      Row({
        space: 12
      }) {
        Image($r('app.media.shelf_book'))
          .width(69)
          .height(92)

        Column({
          space:5
        }) {
          Row(){
            Text(book.title).fontSize(16).fontWeight(500).lineHeight(24)
              .textOverflow({
                overflow:TextOverflow.Ellipsis
              })
              .ellipsisMode(EllipsisMode.END)
              .maxLines(2)
          }
          Text(book.describe)
            .fontSize(12)
            .lineHeight(20)
            .fontColor('rgba(0, 0, 0, 0.45)')
            .textOverflow({
              overflow:TextOverflow.Ellipsis
            })
            .height(50)
            .ellipsisMode(EllipsisMode.END)
            .maxLines(2)
          Row({
            space:2
          }){
            Text('卖报小郎君·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('玄幻·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('完本·').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
            Text('380万字').fontSize(10).fontWeight(400).fontColor($r('app.string.color_black_45'))
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      Column(){
        TextArea({placeholder:'添加推荐理由',text:book.describe})
          .padding(10).borderRadius(8)
      }.padding({top:12,bottom:5})
    }
    .align(Alignment.Start)
    .padding({top:16})
  }
}
@Styles function fontStyles() {
  .padding({left:6,right:6,top:5,bottom:5})
  .backgroundColor('rgba(0, 0, 0, 0.06)')
  .borderRadius(10)
}