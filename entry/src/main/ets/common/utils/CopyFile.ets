import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { common } from '@kit.AbilityKit';

let context = getContext(this) as common.UIAbilityContext;
let filePath = context.filesDir + '/desTest.txt';

// 将picker选择的文件复制到沙箱路径
export function CopyFile(srcUrl: string): void {
  let dstPath = filePath;
  console.log("dstPath:" + dstPath)
  console.log("srcUrl:" + srcUrl)

  let file = fs.openSync(srcUrl, fs.OpenMode.READ_WRITE);

  fs.copyFile(file.fd, dstPath, 0).then(() => {
    console.info("copy file succeed");
  }).catch((err: BusinessError) => {
    console.error("copy file failed with error message: " + err.message + ", error code: " + err.code);
  });
}