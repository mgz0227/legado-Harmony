/**
 * Copyright (C), 2024-05-13
 * @author LinXun
 * @date 2024/5/13 15:25
 * @version 1.0
 * @description: 笔记显示模型
 */
export class NoteVO {
  // id
  id: number;
  // 笔记引用内容
  noteContent: string;
  // 笔记内容
  note?: string;
  // 创建时间
  createTime: string;
  /**
   * 构造方法
   * @param noteContent
   * @param note
   * @param createTime
   */
  constructor(id: number, noteContent: string, createTime: string, note?: string) {
    this.id = id;
    this.noteContent = noteContent;
    this.note = note;
    this.createTime = createTime;
  }
}