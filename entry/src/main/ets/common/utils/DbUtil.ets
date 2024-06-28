/**
 * Copyright (C), 2024-06-24
 * @author LinXun
 * @date 2024-06-24 11:47
 * @version 1.0
 * @description: 数据库工具类封装
 */
import { relationalStore, ValuesBucket, ValueType } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import CommonConstants from '../constants/CommonConstants';
import Logger from './Logger';
import { ColumnInfo, ColumnType } from '../database/rdb/ColumnInfo';

class DbUtil {
  // 数据库实例
  rdbStore: relationalStore.RdbStore | undefined = undefined;
  /**
   * 初始化数据库
   * @param context 上下文
   * @returns
   */
  initDB(context: common.UIAbilityContext): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, CommonConstants.STORE_CONFIG)
        .then(rdbStore => {
          this.rdbStore = rdbStore;
          Logger.debug(`[${CommonConstants.RDB_TAG}]`, 'rdbStore 初始化成功');
          resolve();
        })
        .catch((reason: string) => {
          Logger.error(`[${CommonConstants.RDB_TAG}]`, 'rdbStore 初始化失败', JSON.stringify(reason));
          reject(reason);
        })
    });
  }
  /**
   * 删除数据库
   * @param context
   * @returns
   */
  deleteDB(context: common.UIAbilityContext): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      if (this.rdbStore === undefined) {
        resolve();
      }
      relationalStore.deleteRdbStore(context, CommonConstants.STORE_CONFIG, (error) => {
        if (error) {
          Logger.error(`[${CommonConstants.RDB_TAG}]`, 'rdbStore 删除失败', JSON.stringify(error));
          reject(error);
        }
        this.rdbStore = undefined;
        resolve();
      })
    });
  }
  /**
   * 创建表
   * @param createSQL 创建表语句
   * @returns
   */
  createTable(createSQL: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      this.rdbStore?.executeSql(createSQL)
        .then(() => {
          Logger.debug(`[${CommonConstants.RDB_TAG}]`,'创建表成功');
          resolve();
        })
        .catch((reason: string) => {
          Logger.error(`[${CommonConstants.RDB_TAG}]`,'创建表失败', JSON.stringify(reason));
          reject(reason);
        })
    });
  }
  /**
   * 插入数据
   * @param tableName 表名
   * @param obj
   * @param columns
   * @returns
   */
  insert(tableName: string, obj: object, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建新增数据
      let value = this.buildValueBucket(obj, columns);
      // 2.新增
      this.rdbStore?.insert(tableName, value, (err, id) => {
        if (err) {
          Logger.error(`[${CommonConstants.RDB_TAG}]`,'新增失败！', JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(`[${CommonConstants.RDB_TAG}]`,'新增成功！新增id：', id.toString());
          resolve(id);
        }
      })
    });
  }
  /**
   * 删除数据
   * @param predicates 条件
   * @returns
   */
  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.delete(predicates, (err, rows) => {
        if (err) {
          Logger.error(`[${CommonConstants.RDB_TAG}]`,'删除失败!,', JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(`[${CommonConstants.RDB_TAG}]`,'删除成功！删除行数：', rows.toString());
          resolve(rows);
        }
      })
    });
  }
  /**
   * 查询数据
   * @param predicates 条件
   * @param columns
   * @returns
   */
  queryForList<T> (predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if (err) {
          Logger.error(`[${CommonConstants.RDB_TAG}]`,'查询失败!',JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(`[${CommonConstants.RDB_TAG}]`,'查询成功！查询行数：', result.rowCount.toString());
          resolve(this.parseResultSet(result, columns));
          result.close();
        }
      })
    });
  }
  /**
   * 查询数据个数
   * @param predicates
   * @param columns
   * @returns
   */
  queryForCount (predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if (err) {
          Logger.error(`[${CommonConstants.RDB_TAG}]`,'查询失败!',JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(`[${CommonConstants.RDB_TAG}]`,'查询成功！查询行数：', result.rowCount.toString());
          resolve(result.rowCount);
        }
      })
    });
  }
  /**
   * 更新数据
   * @param predicates
   * @param obj
   * @param columns
   * @returns
   */
  update(predicates: relationalStore.RdbPredicates, obj: object, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建更新数据
      let value = this.buildValueBucket(obj, columns);
      // 2.更新
      this.rdbStore?.update(value, predicates, (err, result) => {
        if (err) {
          Logger.error(`[${CommonConstants.RDB_TAG}]`, '更新失败！', JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(`[${CommonConstants.RDB_TAG}]`, '更新成功！更新行数：', result.toString());
          resolve(result);
        }
      })
    });
  }
  /**
   * 解析结果集
   * @param result
   * @param columns
   * @returns
   */
  parseResultSet<T> (result: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    // 1.声明最终返回的结果
    let arr: T[] = [];
    // 2.判断是否有结果
    if (result.rowCount <= 0) {
      Logger.debug('无结果');
      return arr;
    }
    // 3.处理结果
    while (!result.isAtLastRow) {
      // 3.1 去下一行
      result.goToNextRow();
      // 3.2 解析这行数据，转为对象
      let obj: ValuesBucket = {};
      columns.forEach(info => {
        let val: ValueType | Uint8Array | null = null;
        switch (info.type) {
          case ColumnType.LONG:
            val = result.getLong(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.DOUBLE:
            val = result.getDouble(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.BLOB:
            val = result.getBlob(result.getColumnIndex(info.columnName));
            break;
        }
        obj[info.name] = val;
      })
      // 3.3 将对象填入结果数组
      arr.push(obj as T);
    }
    return arr;
  }
  /**
   * 构建值集
   * @param obj
   * @param columns
   * @returns
   */
  buildValueBucket(obj: object, columns: ColumnInfo[]): ValuesBucket {
    let value: ValuesBucket = {};
    columns.forEach(info => {
      if (typeof obj[info.name] !== 'undefined') {
        value[info.columnName] = obj[info.columnName];
      }
    });
    return value;
  }
}
// 导出
let dbUtil: DbUtil = new DbUtil();
export default dbUtil as DbUtil;