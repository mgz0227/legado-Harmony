import { FieldsType } from './types/AppDatabaseType'
import { ColumnInfo, ColumnValue, ColumnType } from './types/ColumnInfo'
import AppDatabase from './AppDatabase'
import DbUtil from '../common/utils/DbUtil'

class AppDatabaseUtil {
  getCreateSql(tableName: string) {
    const entities = AppDatabase.database.entities
    const tableInfo = entities.find(item => item.tableName === tableName)
    return tableInfo?.createSql.replace('${TABLE_NAME}', tableName)
  }

  getFields(tableName: string): FieldsType[] | undefined {
    const entities = AppDatabase.database.entities
    const tableInfo = entities.find(item => item.tableName === tableName)
    return tableInfo?.fields
  }

  existsTable(tableName: string) {
    const fields = this.getFields(tableName)
    if (fields?.length) {
      for (let index = 0; index < fields.length; index++) {
        const element = fields[index];
        const sql = `IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '${tableName}' AND column_name = '${element.columnName}')
BEGIN
    -- 如果不存在，则添加新字段
    ALTER TABLE ${tableName} ADD ${element.columnName} ${element.affinity};
END;`
        DbUtil.createTable(sql);
      }
    }
  }

  getColumn(tableName: string) {
    const entities = AppDatabase.database.entities
    const tableInfo = entities.find(item => item.tableName === tableName)
    return this.fieldsToColumnInfo(tableInfo?.fields || [])
  }

  getAssignColumn(tableName: string, assignColumn: string[]) {
    const columns = this.getColumn(tableName)
    return columns.filter(item => assignColumn.includes(item.columnName))
  }

  fieldsToColumnInfo(fields: FieldsType[]): ColumnInfo[] {
    return fields.map(item => {
      const columnInfo: ColumnInfo = {
        name: item.fieldPath,
        // 数据库列名
        columnName: item.columnName,
        // 列类型
        type: item.boolean ? ColumnType.BOOLEAN : ColumnValue[item.affinity],
        defaultValue: item.defaultValue
      }
      return columnInfo
    })
  }
}

const appDatabaseUtil = new AppDatabaseUtil();
export default appDatabaseUtil as AppDatabaseUtil;