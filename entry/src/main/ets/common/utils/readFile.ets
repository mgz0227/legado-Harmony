import { BusinessError } from '@ohos.base';
import fs, { Options } from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';

let context = getContext(this) as common.UIAbilityContext;
let filePath = context.filesDir + '/desTest.txt';
// let filePath ='/data/storage/el2/base/haps/entry/files/desTest.txt';

let options: Options = {
  encoding: 'utf-8'
};

export function readFile(readFileUrl?: string): void {
  console.info(filePath)
  fs.readLines(filePath, options).then((readerIterator: fs.ReaderIterator) => {
    for (let it = readerIterator.next();!it.done; it = readerIterator.next()) {
      console.info("content: " + it.value);
    }
  }).catch((err: BusinessError) => {
    console.error("readLines failed with error message: " + err.message + ", error code: " + err.code);
  });

  // let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
  // let arrayBuffer = new ArrayBuffer(4096);
  // fs.read(file.fd, arrayBuffer).then((readLen: number) => {
  //   console.info("read file data succeed");
  //   let buf = buffer.from(arrayBuffer, 0, readLen);
  //   console.info(`The content of file: ${buf.toString()}`);
  // })
}