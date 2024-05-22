/**
 * @author 惟草木之零落兮
 * @date 2024/5/22 20:17
 */
import BasicDataSource from './BasicDataSource';
import FolderAndFileItem from '../../componets/dataList/FolderAndFileItem';

/**
 * 文件夹 文件列表 数据懒加载对象
 * */
export default class FolderFileDataSource extends BasicDataSource {
    private dataArray: FolderAndFileItem[] = [];

    public totalCount(): number {
        return this.dataArray.length;
    }

    public getData(index: number): FolderAndFileItem{
        return this.dataArray[index];
    }

    public addData(index: number, data: FolderAndFileItem): void {
        this.dataArray.splice(index, 0, data);
        this.notifyDataAdd(index);
    }

    public pushData(data: FolderAndFileItem): void {
        this.dataArray.push(data);
        this.notifyDataAdd(this.dataArray.length - 1);
    }

    public pushAllData(data: FolderAndFileItem[]): void {
        for (const d of data) {
            this.dataArray.push(d);
            this.notifyDataAdd(this.dataArray.length - 1);
        }
    }

    // 重新加载
    public reloadNewData(data: FolderAndFileItem[]): void {
        this.dataArray = []
        for (const d of data) {
            this.dataArray.push(d);
            this.notifyDataAdd(this.dataArray.length - 1);
        }
        this.notifyDataReload()
    }
}