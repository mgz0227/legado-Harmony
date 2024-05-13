/**
 * Copyright (C), 2024-05-13
 * @author LinXun
 * @date 2024/5/13 15:38
 * @version 1.0
 * @description: 笔记列表显示模型
 */
import { NoteVO } from './NoteVO';

export class NoteListVO {
  // id
  id: number;
  // 章节名称
  chapterName: string;
  // 笔记
  noteList: NoteVO[];
  /**
   * 构造方法
   * @param id
   * @param chapterName
   * @param noteList
   */
  constructor(id: number, chapterName: string, noteList: NoteVO[]) {
    this.id = id;
    this.chapterName = chapterName;
    this.noteList = noteList;
  }
}