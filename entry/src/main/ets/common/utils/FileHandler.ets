import { BusinessError } from '@ohos.base';
import fs, { Options } from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';
import { chaptersItem } from 'ets/storage/ReaderChaptersItem';
import promptAction from '@ohos.promptAction';

let context = getContext(this) as common.UIAbilityContext;
let filePath = context.filesDir;

let dstPath = filePath + '/desTest' // 暂时替代

let options: Options = {
  encoding: 'utf-8'
};

export class FileHandler {
  static async CopyFile(srcUrl?: string) {
    let file = fs.openSync(srcUrl, fs.OpenMode.READ_WRITE);
    // let dstPath = filePath + '/' + file.name; // file.name:《幽影之冰》.txt
    await fs.copyFile(file.fd, dstPath, 0).then(() => {
      promptAction.showToast({
        message: '导入沙箱成功',
        duration: 2000
      })
      console.info("copy file success");
    }).catch((err: BusinessError) => {
      promptAction.showToast({
        message: '导入失败',
        duration: 2000
      })
      console.error("copy file failed with error message: " + err.message + ", error code: " + err.code);
    });
  }

  static async readFile(readFileUrl?: string) {
    let chapterNumber = 0
    const chapters: chaptersItem[] = [];
    console.info('readFileUrl:' + readFileUrl)
    const regex = /===第(.*?)章 (.*?)===/g;
    await fs.readLines(dstPath, options).then((readerIterator: fs.ReaderIterator) => {
      for (let it = readerIterator.next();!it.done; it = readerIterator.next()) {
        const match = regex.exec(it.value);
        if (match) {
          const chapterTitleNumber = match[1]; // 书源内部章节
          const chapterTitle = match[2];
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