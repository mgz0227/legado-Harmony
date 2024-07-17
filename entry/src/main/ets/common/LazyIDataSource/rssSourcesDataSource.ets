/**
 * @author 2008
 * @datetime 2024/7/16 00:36
 * @className: rssSourcesDataSource
 * 懒加载
 */
import { rssGroupList } from '../../database/entities/rssSources';
import BasicDataSource from './BasicDataSource';

export default class rssSourcesDataSource extends BasicDataSource{
    private dataArray: rssGroupList[] =[]

    public totalCount(): number {
      return this.dataArray.length;
    }

    public getData(index: number): rssGroupList{
      return this.dataArray[index];
    }

    public getListData(): rssGroupList[] {
      console.log('getListData', JSON.stringify( this.dataArray))
      return this.dataArray;
    }

    public addData(index: number, data: rssGroupList): void {
      this.dataArray.splice(index, 0, data);
      this.notifyDataAdd(index);
    }

    public pushData(data: rssGroupList): void {
      this.dataArray.push(data);
      this.notifyDataAdd(this.dataArray.length - 1);
    }

    public pushAllData(data: rssGroupList[]): void {
      for (const d of data) {
        this.dataArray.push(d);
        this.notifyDataAdd(this.dataArray.length - 1);
      }
    }

    // 重新加载
    public reloadNewData(data: rssGroupList[]): void {
      this.dataArray = []
      for (const d of data) {
        this.dataArray.push(d);
        this.notifyDataAdd(this.dataArray.length - 1);
      }
      this.notifyDataReload()
    }


}