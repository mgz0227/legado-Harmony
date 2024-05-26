import { MyCenterTitle } from '../../../componets/myCenter/MyCenterTitle';
import MyCenterFileSearch from  '../../../componets/myCenter/MyCenterFileSearch';
import FolderFileDataSource from '../../../common/LazyIDataSource/FileListDataSource';
import FolderFileListItem from '../../../componets/myCenter/FolderFileListItem';
import FolderAndFileItem from '../../../componets/dataList/FolderAndFileItem';
import RenameDialog from '../dialog/RenameDialog';
import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * @author 惟草木之零落兮
 * @date 2024/5/22 14:33
 */

// 书架/更多/书籍导入/网盘导入/文件列表/开源阅读

PersistentStorage.persistProp('onSelect', 0);
PersistentStorage.persistProp('webDavTitle', "坚果云");

@Entry
@Component
struct FileManagement {
    @State title: string = AppStorage.get("webDavTitle") || "坚果云"

    @State fileList: FolderFileDataSource = new FolderFileDataSource()

    @StorageLink("onSelect") onSelect: number = 0

    dialogController: CustomDialogController | null = new CustomDialogController({
        builder: RenameDialog({
            oldName: "坚果云",
            confirm: this.confirm
        }),
        //autoCancel: true,
        alignment: DialogAlignment.Center,
        offset: { dx: 0, dy: 0 },
        customStyle: true
    })

    confirm(value: string){
        // 新名字
    }

    aboutToAppear(): void {
        for (let i=0; i < 20; i++){
            this.fileList.pushData({
                title: i < 3 ? `文件夹 ${i}` : `文件 ${i}`,
                icon: i < 3 ? $r("app.media.ic_folder") : $r("app.media.ic_zip") ,
                size: i < 3 ? "12项" : "30M",
                date: "2021/8/13",
                isFolder: i < 3 ? true: false
            })
        }
    }

    build() {
        Column(){

            // 标题栏
            MyCenterTitle({
                title: this.title,
                isShowEdit: true,
                isShowMore: true,
                onEditClickEvent: ()=>{
                    this.dialogController?.open()
                }
            })

            // 搜索栏
            MyCenterFileSearch({
                onResultCallBack: (value: string)=>{
                    // value 搜索框值发生变化和提交搜索会触发
                    // TODO 执行搜索，此处应做防抖处理
                }
            })

            // 目录层级栏
            Row(){
                Text("TODO 目录层级") //TODO 目录层级
            }
            .margin({top: 12, bottom: 12})

            // 文件+文件夹列表
            Column(){
                List({space: 20}){
                    LazyForEach(this.fileList, (item: FolderAndFileItem, index: number)=>{
                        ListItem(){
                            FolderFileListItem({
                                data: item
                            })
                        }
                    })
                }
                .width("100%")
                .height("100%")
            }
            .width("100%")
            .layoutWeight(1) // 占满屏幕剩余空间
        }
        .padding({left: 20, right: 20})
    }
}