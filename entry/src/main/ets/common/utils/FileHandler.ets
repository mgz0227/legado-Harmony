import { BusinessError } from '@ohos.base';
import fs, { Options } from '@ohos.file.fs';
import { common, Context } from '@kit.AbilityKit';
import { chaptersItem } from 'ets/componets/dataList/ReaderChaptersItem';
import { BookList } from '../../componets/dataList/bookList';
import { addShelfBook } from '../../storage/bookListData';
import { showMessage } from '../../componets/common/promptShow';
import { picker } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';

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

  static async pickerFile (context: Context) {
    try {
      const documentSelectOptions = new picker.DocumentSelectOptions();
      // 选择文档的最大数目（可选）
      documentSelectOptions.maxSelectNumber = 1;
      // 选择文件的后缀类型，若选择项存在多个后缀名，则每一个后缀名之间用英文逗号进行分隔（可选），后缀类型名不能超过100
      documentSelectOptions.fileSuffixFilters = ['.json'];
      let documentViewPicker = new picker.DocumentViewPicker(context);
      const documentSelectResult: Array<string> = await documentViewPicker.select(documentSelectOptions)
      const  pathUrl = documentSelectResult[0];
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
}