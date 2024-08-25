/**
 * @author 2008
 * @datetime 2024/8/16 20:16
 * @className: taskSearchBook
 */
import taskPool from '@ohos.taskpool';
import { BookSource } from '../../database/entities/BookSource';
import bookSourceDao from '../../database/dao/BookSourceDao';
import { showMessage } from '../../componets/common/promptShow';
import searchUtil from '../utils/searchUtils';
import { SearchBook } from '../../database/entities/SearchBook';


class taskSearchBook{
  private bookSourceParts:BookSource[] = []
  MAX_THREADS:number = 5;
  tasks:taskPool.Task[] = [];
  taskSearchBookNumber:number = 0
  dataStart:number = 0;
  async search(searchKey: string, returnBook: (newUrls: SearchBook[]) => void, cancel: () => void,source?:BookSource[]): Promise<void> {
    this.dataStart = Date.now();
    this.tasks = [];
    this.taskSearchBookNumber = 0
    this.bookSourceParts = []
    if (!searchKey) {
      return;
    }

    if (!source) {
      this.bookSourceParts = await bookSourceDao.getEnabledPartByGroup();
    } else {
      this.bookSourceParts.push(...source)
    }

    if (!this.bookSourceParts || this.bookSourceParts.length === 0) {
      showMessage('启用书源为空');
      cancel()
      return;
    }

    const numBookSources = this.bookSourceParts.length;
    const numThreads = Math.min(Math.ceil(numBookSources / 20), this.MAX_THREADS);
    // 创建一个回调函数
    const callback = (newUrls: SearchBook[]) => {
      this.taskSearchBookNumber += newUrls.length
      returnBook(newUrls)
    };

    console.log(`${this.bookSourceParts}`)

    for (let i = 0; i < numThreads; i++) {
      const sourcesSlice = this.bookSourceParts.slice(
        (i * numBookSources) / numThreads,
        ((i + 1) * numBookSources) / numThreads
      );

      const task = new taskPool.Task(
        `搜索${i}`,
        searchTask,
        searchKey, sourcesSlice
      );
      task.onReceiveData(callback)
      this.tasks.push(task);
    }

    try {
      if (this.tasks.length > 0) {
        const results = await Promise.all(this.tasks.map(async (task, index) => {
          console.log(`任务执行中... ${task.name} ${task.isDone()}`);
          try {
            return await taskPool.execute(task, index % 3);
          } catch (e) {
            console.log(e.message);
            return [];
          }
        }));
        const searchBooks = results.flat();
        let dataEnd = Date.now();
        if(this.tasks.length > 0){
          showMessage(`搜索中止,共搜索到${this.taskSearchBookNumber}个结果` + `用时${(dataEnd - this.dataStart) / 1000}秒`);
        }
        cancel()
      }
    } catch (error) {
      console.error('Error during search:', error);
      cancel()
      showMessage('搜索中止');
    }
  }

  cancelAllTasks() {
    if (this.tasks.length > 0) {
      this.tasks.forEach((task) => {
        console.log(`任务执行中 ${task.name} ${task.isDone()}`)
        if (task.isDone()) {
          return
        }
        taskPool.cancel(task)
        console.log(`任务已取消 ${task.name} ${task.isDone()}`)
      })
    }
    let dataEnd = Date.now();
    showMessage(`搜索中止,共搜索到${this.taskSearchBookNumber}个结果` + `用时${(dataEnd - this.dataStart) / 1000}秒`);
    this.tasks = [];
    this.taskSearchBookNumber = 0
    this.bookSourceParts = []
  }

}

@Concurrent
async function searchTask(searchKey: string, bookSource: BookSource[]): Promise<SearchBook[]> {
  let searchBook:SearchBook[] = []
  try {
    for (const source of bookSource) {
      if (taskPool.Task.isCanceled()) {
        console.log('任务已取消')
        return []
      }
      const newUrls = await searchUtil.searchData(searchKey, Date.now(), source);
      if (newUrls.length > 0) {
        searchBook.push(...newUrls)
      }
      taskPool.Task.sendData(newUrls)
    }
    return searchBook;
  } catch (e) {
    console.log(e.message);
    return []
  }
}
const taskSearchBooks = new taskSearchBook();
export default taskSearchBooks as taskSearchBook;