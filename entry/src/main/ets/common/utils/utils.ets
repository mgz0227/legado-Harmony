import { unifiedDataChannel } from '@kit.ArkData';
import { pasteboard } from '@kit.BasicServicesKit'

// 获取粘贴类型
export const getPasteDataSync = () => {
  try {
    const data = pasteboard.getSystemPasteboard().getUnifiedDataSync()
    let records = data.getRecords();
    let record = records[0] as unifiedDataChannel.PlainText;
    return record.textContent
  } catch (e) {
    console.error(`获取失败：${e}`);
    return undefined
  }
}

// 校验链接是否是http/https等网络协议请求
export const isNetworkUrl = (url: string) => {
  return url.startsWith('http://') ||
  url.startsWith('https://');
}

// 延迟多少毫秒
export const sleep = (duration: number = 1000): Promise<void> => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve()
    }, duration)
  })
}
