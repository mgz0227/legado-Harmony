import { BusinessError } from '@ohos.base';
import fs, { Options } from '@ohos.file.fs';
import { common, Context } from '@kit.AbilityKit';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { showMessage } from '../../componets/common/promptShow';
import { picker } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { buffer } from '@kit.ArkTS'
import { Books } from '../../database/entities/Books';
import booksUtil from './booksUtils';

let context = getContext(this) as common.UIAbilityContext;
let filePath = context.filesDir;

let options: Options = {
  encoding: 'utf-8'
};

export class FileHandler {
  static CopyFile(srcUrl: string, currentIndex:number) {
    let file = fs.openSync(srcUrl, fs.OpenMode.READ_WRITE);
    let dstPath = filePath + '/' + file.name; // file.name:《幽影之冰》.txt
    let book:Books = {
      bookName: file.name,
      bookUrl: dstPath,
      author: '暂无',
      bookGroup: 4,
      latestChapterTime: 0,
      totalChapterNum: 0,
      durChapterIndex: 0,
      durChapterPos: 0,
      durChapterTime: 0,
      canUpdate: false,
      sort: 0,
      originOrder: 0,
      syncTime: 0,
      bookType: currentIndex,
      isTop: false,
      isJoin: true,
      isLocalBook: true
    }
    booksUtil.addBooks(book)
    showMessage('添加到书架成功')
    fs.copyFile(file.fd, dstPath, 0).then(() => {
      showMessage('导入沙箱成功')
      console.info("copy file success");
    }).catch((err: BusinessError) => {
      showMessage('导入失败')
      console.error("copy file failed with error message: " + err.message + ", error code: " + err.code);
    });
  }

  //动态获取文件大小
  static async ReadJSONFile(srcUrl: string) {
    try {
      let file = fs.openSync(srcUrl, fs.OpenMode.READ_WRITE);
      let stat = fs.statSync(file.path)
      let arrayBuffer = new ArrayBuffer(stat.size);
      let readLen: number = await fs.read(file.fd, arrayBuffer)
      let JSONString = buffer.from(arrayBuffer, 0, readLen).toString();
      return JSONString
    } catch (e){
      console.error(`读取失败：${e}`);
      return ''
    }
  }

  static async readFile(readFileUrl: string) {
    let chapterNumber = 0
    const chapters: chaptersItem[] = [];
    console.info('readFileUrl:' + readFileUrl)
    //const regex = /===第(.*?)章 (.*?)===/g;
    const regex =
      /^[=|<]{0,4}((?:序章|楔子|番外|第\s{0,4})([\d〇零一二两三四五六七八九十百千万壹贰叁肆伍陆柒捌玖拾佰仟]+?\s{0,4})(?:章|回(?!合)|话(?!说)|节(?!课)|卷|篇(?!张)))(.{0,30})/g;
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
    // 移除chapters中content内容字符不超过5个字符的删除
    for (let i = 0; i < chapters.length; i++) {
      if (chapters[i].content.length < 5) {
        chapters.splice(i, 1)
        i--
      }
    }
    return chapters
  }

  static async documentPickerFile(maxSelectNumber: number, fileSuffixFilters: Array<string>) {
    // 尝试写一个通用的picker
    try {
      const documentSelectOptions = new picker.DocumentSelectOptions();
      // 选择文档的最大数目（可选）
      documentSelectOptions.maxSelectNumber = maxSelectNumber;
      // 选择文件的后缀类型，若选择项存在多个后缀名，则每一个后缀名之间用英文逗号进行分隔（可选），后缀类型名不能超过100
      documentSelectOptions.fileSuffixFilters = fileSuffixFilters;
      let documentViewPicker = new picker.DocumentViewPicker(context);
      const documentSelectResult: Array<string> = await documentViewPicker.select(documentSelectOptions)
      return documentSelectResult
    } catch (err) {
      console.error(`读取失败：${err}`);
      return Promise.reject(err)
    }
  }

  static async pickerFile(context: Context) {
    try {
      const documentSelectOptions = new picker.DocumentSelectOptions();
      // 选择文档的最大数目（可选）
      documentSelectOptions.maxSelectNumber = 1;
      // 选择文件的后缀类型，若选择项存在多个后缀名，则每一个后缀名之间用英文逗号进行分隔（可选），后缀类型名不能超过100
      documentSelectOptions.fileSuffixFilters = ['.json'];
      let documentViewPicker = new picker.DocumentViewPicker(context);
      const documentSelectResult: Array<string> = await documentViewPicker.select(documentSelectOptions)
      const pathUrl = documentSelectResult[0];
      console.info('文件目录：' + pathUrl);
      let file = fs.openSync(pathUrl, fs.OpenMode.READ_WRITE);
      let buf = new ArrayBuffer(40960000);
      fs.readSync(file.fd, buf);
      fs.closeSync(file);
      let uint8View = new Uint8Array(buf);
      // 设置编码格式为“utf-8”
      let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      // 解码输后获取对应文本
      let readString = textDecoder.decodeWithStream(uint8View, { stream: false });
      console.log('读取的数据内容：' + readString);
      return JSON.parse(readString)
    } catch (err) {
      console.error(`读取失败：${err}`);
      return Promise.reject(err)
    }
  }

  static async readJsonFile<T>(pathUrl: string): Promise<T | undefined> {
    console.info('TagInfo', '文件路径：' + pathUrl);
    try {
      const readString = await fs.readText(pathUrl);
      console.info('TagInfo', '读取的数据内容：' + readString);
      const data: T = JSON.parse(readString)
      return data
    } catch (err) {
      console.error('TagInfo', `未读取到：${err}`);
      return undefined
    }
  }

  static writeJsonFile(pathUrl: string, context: ArrayBuffer | string) {
    console.info('TagInfo', '文件地址：' + pathUrl);
    try {
      // 创建文件，并且写入内容，若是存在则重写内容
      let res = fs.accessSync(pathUrl);
      let file: fs.File
      if (res) {
        file = fs.openSync(pathUrl, fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
      } else {
        file = fs.openSync(pathUrl, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      }
      fs.writeSync(file.fd, context)
      fs.close(file);
      return '写入成功'
    } catch (e) {
      console.error('TagInfo', '写入失败' + JSON.stringify(e))
      return '写入失败' + JSON.stringify(e)
    }
  }

  static deleteJsonFile(pathUrl: string) {
    try {
      fs.unlinkSync(pathUrl);
      return '删除成功'
    } catch (e) {
      console.error('TagError', '删除失败' + JSON.stringify(e))
      return '删除失败'
    }
  }
}