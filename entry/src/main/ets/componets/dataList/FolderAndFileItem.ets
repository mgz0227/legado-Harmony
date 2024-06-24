/**
 * @author 惟草木之零落兮
 * @date 2024/5/22 20:21
 */
// 网盘 本地目录 文件夹 文件信息
export default interface FolderAndFileItem {
    title: string, // 文件夹文件标题
    icon: PixelMap | ResourceStr | DrawableDescriptor, // 文件夹文件图标
    size: string, // 文件夹里文件数量，或者文件的大小
    date: string, // 最后修改日期
    isFolder: boolean // 是否为文件夹，用于排序，文件夹在最上面
}