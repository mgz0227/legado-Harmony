/**
 * @author 2008
 * @datetime 2024/7/10 23:25
 * @className: ChaptersDataSource
 */
import { chaptersItem } from '../../componets/dataList/ReaderChaptersItem';
import BasicDataSource from './BasicDataSource';

export default class ChaptersDataSource extends BasicDataSource<chaptersItem>{
    private dataArray: chaptersItem[] =[]

    public totalCount(): number {
      return this.dataArray.length;
    }

    public getData(index: number): chaptersItem{
      return this.dataArray[index];
    }

    public getListData(): chaptersItem[] {
      console.log('getListData', JSON.stringify( this.dataArray))
      return this.dataArray;
    }

    public addData(index: number, data: chaptersItem): void {
      this.dataArray.splice(index, 0, data);
      this.notifyDataAdd(index);
    }

    public pushData(data: chaptersItem): void {
      this.dataArray.push(data);
      this.notifyDataAdd(this.dataArray.length - 1);
    }

    public pushAllData(data: chaptersItem[]): void {
      for (const d of data) {
        this.dataArray.push(d);
        this.notifyDataAdd(this.dataArray.length - 1);
      }
    }

    // 重新加载
    public reloadNewData(data: chaptersItem[]): void {
      this.dataArray = []
      for (const d of data) {
        this.dataArray.push(d);
        this.notifyDataAdd(this.dataArray.length - 1);
      }
      this.notifyDataReload()
    }


}