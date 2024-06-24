/**
 * @author 惟草木之零落兮
 * @date 2024/5/22 20:10
 */

export default class BasicDataSource implements IDataSource {
    private listeners: DataChangeListener[] = [];
    private originDataArray: Array<ESObject> = [];

    public totalCount(): number {
        return 0;
    }

    public getData(index: number): ESObject {
        return this.originDataArray[index];
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
            listener.onDataReloaded();
        })
    }

    // 通知LazyForEach组件需要在index对应索引处添加子组件
    notifyDataAdd(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDataAdd(index);
        })
    }

    // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
    notifyDataChange(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDataChange(index);
        })
    }

    // 通知LazyForEach组件需要在index对应索引处删除该子组件
    notifyDataDelete(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDataDelete(index);
        })
    }
}
