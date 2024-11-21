@CustomDialog
export struct AddDownloadDialog {
  controller?: CustomDialogController;

  build() {
    Row({ space: 8 }) {
      Image($r('app.media.ic_public_confirm'))
        .width(24)
        .height(24)
        .fillColor('#FFFFFF')
      Text('已加入下载列表')
        .fontSize(14)
        .fontWeight(400)
        .lineHeight(22)
        .fontColor('#FFFFFF')
      Blank(1)
      Text('查看')
        .fontSize(14)
        .fontWeight(400)
        .lineHeight(22)
        .fontColor('#FF9500')
    }
    .height(56)
    .width("100%")
    .padding({
      left: 20,
      right: 20,
      top: 16,
      bottom: 16
    })
    .backgroundColor('#333333')
  }
}