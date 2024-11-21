import { ReaderChapterItem } from '../entity/ReaderChaptersItem';

export class NovelChapterOperateHelper {
  static nextPageIndex(chapterList: ReaderChapterItem[], chapterIndex: number, pageIndex: number): number[] | null {
    if (chapterIndex >= chapterList.length - 1) {
      if (pageIndex >= chapterList[chapterIndex].chapterPageList.length - 1) {
        return null;
      } else {
        return [chapterIndex, pageIndex + 1];
      }
    } else {
      if (pageIndex >= chapterList[chapterIndex].chapterPageList.length - 1) {
        if (chapterList[chapterIndex+1].chapterPageList.length === 0) {
          return null;
        }
        return [chapterIndex + 1, 0];
      } else {
        return [chapterIndex, pageIndex + 1];
      }
    }
  }

  static prePageIndex(chapterList: ReaderChapterItem[], chapterIndex: number, pageIndex: number): number[] | null {
    if (chapterIndex <= 0) {
      if (pageIndex <= 0) {
        return null;
      } else {
        return [chapterIndex, pageIndex - 1];
      }
    } else {
      if (pageIndex <= 0) {
        if (chapterList[chapterIndex-1].chapterPageList.length === 0) {
          return null;
        }
        return [chapterIndex - 1, chapterList[chapterIndex-1].chapterPageList.length - 1];
      } else {
        return [chapterIndex, pageIndex - 1];
      }
    }
  }
}