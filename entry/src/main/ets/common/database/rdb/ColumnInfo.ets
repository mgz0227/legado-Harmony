/**
 * Copyright (C), 2024-06-22
 * @author LinXun
 * @date 2024-06-22 10:08
 * @version 1.0
 * @description: 数据库列接口
 */
export interface ColumnInfo{
  // 实体属性名
  name: string
  // 数据库列名
  columnName: string
  // 列类型
  type: ColumnType
}
// 数据类型
export enum ColumnType{
  LONG,
  DOUBLE,
  STRING,
  BLOB
}