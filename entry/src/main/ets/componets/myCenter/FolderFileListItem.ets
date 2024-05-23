/**
 * @author 惟草木之零落兮
 * @date 2024/5/22 20:51
 */
import CommonConstants from '../../common/constants/CommonConstants'
import FolderAndFileItem from '../dataList/FolderAndFileItem'

@Preview
@Component
export default struct FolderFileListItem{
    data: FolderAndFileItem = {
        title: "MATE 40 PRO 备份",
        icon: $r("app.media.ic_folder"),
        size: "12项",
        date: "2021/8/13",
        isFolder: true
    }

    build() {
        Row(){
            // 文件夹、 文件图标
            Image(this.data.icon)
                .size({width: 40,height: 40})
                .margin({right: 12})

            Column(){
                // 标题，名称
                Text(this.data.title)
                    .height(22)
                    .width("100%")
                    .maxLines(1)
                    .fontSize(14)
                    .fontWeight(500)
                    .textAlign(TextAlign.Start)
                    .fontColor("rgba(0, 0, 0, 0.88)")

                // 大小，数量、最后修改事件
                Text(`${this.data.size} ${this.data.date}`)
                    .height(18)
                    .width("100%")
                    .maxLines(1)
                    .fontSize(10)
                    .fontWeight(500)
                    .textAlign(TextAlign.Start)
                    .fontColor("rgba(0, 0, 0, 0.45)")
            }
            .height(40)
            .layoutWeight(1)  // 占满剩余空间
        }
        .height(40)
        .width("100%")
    }
}