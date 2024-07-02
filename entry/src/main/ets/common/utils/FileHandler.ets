import { BusinessError } from '@ohos.base';
import fs, { Options } from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { BookList } from '../../componets/dataList/bookList';
import { addShelfBook } from '../../storage/bookListData';
import { showMessage } from '../../componets/common/promptShow';

let context = getContext(this) as common.UIAbilityContext;
let filePath = context.filesDir;

let options: Options = {
  encoding: 'utf-8'
};

export class FileHandler {
  static CopyFile(srcUrl: string) {
    let file = fs.openSync(srcUrl, fs.OpenMode.READ_WRITE);
    let dstPath = filePath + '/' + file.name; // file.name:《幽影之冰》.txt
    addShelfBook(0,new BookList('',file.name,'会说话的肘子·未读过1','更新至·第340章 镇压',$r('app.media.cover_list'),'测试作者','未分组',dstPath))
    showMessage('添加到书架成功')
    fs.copyFile(file.fd, dstPath, 0).then(() => {
      showMessage('导入沙箱成功')
      console.info("copy file success");
    }).catch((err: BusinessError) => {
      showMessage('导入失败')
      console.error("copy file failed with error message: " + err.message + ", error code: " + err.code);
    });
  }

  static async readFile(readFileUrl: string) {
    let chapterNumber = 0
    const chapters: chaptersItem[] = [];
    console.info('readFileUrl:' + readFileUrl)
    //const regex = /===第(.*?)章 (.*?)===/g;
    const regex = /^[=|<]{0,4}((?:序章|楔子|番外|第\s{0,4})([\d〇零一二两三四五六七八九十百千万壹贰叁肆伍陆柒捌玖拾佰仟]+?\s{0,4})(?:章|回(?!合)|话(?!说)|节(?!课)|卷|篇(?!张)))(.{0,30})/g;
    await fs.readLines(readFileUrl, options).then((readerIterator: fs.ReaderIterator) => {
      for (let it = readerIterator.next();!it.done; it = readerIterator.next()) {
        const match = regex.exec(it.value);
        if (match) {
          const chapterTitleNumber = match[1]; // 书源内部章节
          const chapterTitle = match[3];
          chapterNumber++
          chapters.push(new chaptersItem(chapterNumber, chapterTitle, chapterTitleNumber, ''))
        } else {
          if (chapters.length > 0) {
            chapters[chapters.length - 1].content += it.value
          }
        }
      }
    }).catch((err: BusinessError) => {
      console.error("readLines failed with error message: " + err.message + ", error code: " + err.code);
    });
    return chapters
  }
}