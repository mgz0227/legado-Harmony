import fs from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';

let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;

// 将picker选择的文件复制到沙箱路径
export function CopyFile(srcUrl: string): void {
  let dstPath = filesDir + '/desTest.txt';
  // let dstPath = '/data/storage/el2/base/haps/entry/files/desTest.txt';
  console.log("dstPath:" + dstPath)
  console.log("srcUrl:" + srcUrl)

  let file = fs.openSync(srcUrl, fs.OpenMode.READ_WRITE);

  fs.copyFile(file.fd, dstPath, 0).then(() => {
    console.info("copy file succeed");
  }).catch((err: BusinessError) => {
    console.error("copy file failed with error message: " + err.message + ", error code: " + err.code);
  });
}