import { BusinessError } from '@ohos.base';
import fs, { Options } from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';
import { chaptersItem } from 'ets/storage/ReaderFile';

let context = getContext(this) as common.UIAbilityContext;
let filePath = context.filesDir + '/desTest.txt';

let options: Options = {
  encoding: 'utf-8'
};

let chapterNumber = 0
const chapters: chaptersItem[] = [];

export class TxtFileHandler {
  static async readFile(readFileUrl?: string) {
    console.info('filePath:' + filePath)
    const regex = /===第(.*?)章 (.*?)===/g;
    await fs.readLines(filePath, options).then((readerIterator: fs.ReaderIterator) => {
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