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

// 去除对象数组中重复的内容
export const deduplicateObjects = <T>(list: T[]): T[] => {
  const uniqueSet = new Set(list.map(item => JSON.stringify(item)));
  return Array.from(uniqueSet).map(strItem => JSON.parse(strItem) as T);
};

// 判断是否是json
export const isJson = (json: string): boolean => {
  try {
    JSON.parse(json);
    return true;
  } catch (e) {
    return false;
  }
}
// 判断是否为空
export const isNullOrBlank = (value: string | null | undefined): boolean => {
  return value == null || value.trim().length === 0;
}
// 判断是否为网页链接
export const isAbsUrl = (url:string): boolean => {
  return url.startsWith('http://') || url.startsWith('https://');
}

class Gson {
  toString<T>(info?: T): string | undefined {
    if (!info) {
      return undefined;
    }
    return JSON.stringify(info)
  }

  toJson<T>(json?: string): T | undefined {
    if (!json) {
      return undefined;
    }
    try {
      return JSON.parse(json) as T;
    } catch (error) {
      return undefined;
    }
  }
}
export const GSON = new Gson();
