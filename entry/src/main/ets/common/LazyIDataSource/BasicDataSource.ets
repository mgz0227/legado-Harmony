/**
 * @author 惟草木之零落兮
 * @date 2024/5/22 20:10
 */

export default class BasicDataSource<T> implements IDataSource {
    private listeners: DataChangeListener[] = [];
    private originDataArray: T[] = [];

    //获取数据源总长度
    public totalCount(): number {
        return this.originDataArray.length??0;
    }
    //根据下标获取数据
    public getData(index: number): T {
        return this.originDataArray[index];
    }

    // 获取数据源
    public getOriginDataArray(): T[] {
        return this.originDataArray;
    }

    //清空数据
    public clear(){
        this.originDataArray = [];
        this.notifyDataReload();
    }

    //插入指定位置数据
    public addSpecifyIndexData(index: number, data: T): void {
        if (index < 0 || index > this.originDataArray.length) {
            throw new Error("Index out of bounds");
        }
        this.originDataArray.splice(index, 0, data);
        this.notifyDataAdd(index);
    }

    // 全量数据添加
    public pushAllData(data: T[]): void {
        for (const d of data) {
            this.originDataArray.push(d);
            this.notifyDataAdd(this.originDataArray.length - 1);
        }
    }
    // 追加数据
    public appendData(data: T): void {
        this.originDataArray.push(data);
        this.notifyDataAdd(this.originDataArray.length - 1);
    }

    // 删除指定index的数据
    public deleteData(index: number): void {
        if (index < 0 || index >= this.originDataArray.length) {
            throw new Error("Index out of bounds");
        }
        this.originDataArray.splice(index, 1);
        this.notifyDataDelete(index);
    }

    // 移动数据到指定index
    public moveData(from: number, to: number): void {
        if (from < 0 || from >= this.originDataArray.length || to < 0 || to >= this.originDataArray.length) {
            throw new Error("Index out of bounds");
        }
        const data = this.originDataArray[from];
        this.originDataArray.splice(from, 1);
        this.originDataArray.splice(to, 0, data);
        this.notifyDataMoveOperation(from, to);
    }

    public moveDataUpdate(from: number, to: number,newData:T): void {
        if (from < 0 || from >= this.originDataArray.length || to < 0 || to >= this.originDataArray.length) {
            throw new Error("Index out of bounds");
        }
        const data = this.originDataArray[from];
        this.originDataArray.splice(from, 1);
        this.originDataArray.splice(to, 0, newData);
        this.notifyDataMoveOperation(from, to);
    }

    // 向数组第一个位置插入数据
    public unshiftData(data: T): void {
        this.originDataArray.unshift(data);
        this.notifyDataAdd(0);
    }

    // 翻转数组
    public reverseData(): void {
        this.originDataArray.reverse();
        this.notifyDataReload();
    }

    // 数组按照指定的规则排序
    public sortData(compareFn: (a: T, b: T) => number): void {
        this.originDataArray.sort(compareFn);
        this.notifyDataReload();
    }

    // 追加多条数据
    public appendDataList(dataList: T[]): void {
        dataList.forEach(data => {
            this.appendData(data)
        })
        this.notifyDataReload();
    }

    // 插入多条数据
    public insertDataList(index: number, dataList: T[]): void {
        if (index < 0 || index > this.originDataArray.length) {
            throw new Error("Index out of bounds");
        }
        dataList.forEach(data => {
            this.addSpecifyIndexData(index, data)
        })
    }

    // 第 index的元素发生了改变
    public changeData(index: number, data: T): void {
        this.originDataArray[index] = data;
        this.notifyDataChange(index);
    }

    //获取数据下标
    public getIndex(data: T): number {
        return this.originDataArray.findIndex((item) => {
            return JSON.stringify(item) === JSON.stringify(data);
        });
    }

    // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
    registerDataChangeListener(listener: DataChangeListener): void {
        if (this.listeners.indexOf(listener) < 0) {
            console.info('add listener');
            this.listeners.push(listener);
        }
    }

    // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
    unregisterDataChangeListener(listener: DataChangeListener): void {
        const pos = this.listeners.indexOf(listener);
        if (pos >= 0) {
            console.info('remove listener');
            this.listeners.splice(pos, 1);
        }
    }

    // 通知LazyForEach组件需要重载所有子组件
    notifyDataReload(): void {
        this.listeners.forEach(listener => {
            listener.onDatasetChange([{type: DataOperationType.RELOAD}]);
        })
    }

    // 通知LazyForEach组件需要在index对应索引处添加子组件
    notifyDataAdd(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
        })
    }

    // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
    notifyDataChange(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDatasetChange([{type: DataOperationType.CHANGE,index:index}])
            // listener.onDataChange(index);
        })
    }


    // 通知LazyForEach组件需要在index对应索引处删除该子组件
    notifyDataDelete(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDatasetChange([{type: DataOperationType.DELETE,index:index}])
            // listener.onDataDelete(index);
        })
    }

    //移动位置
    notifyDataMoveOperation(oldIndex: number, newIndex:number): void {
        this.listeners.forEach(listener => {
            listener.onDatasetChange([{type: DataOperationType.MOVE,index:{from:oldIndex,to:newIndex}}])
        })
    }
}
