import { FieldsType } from './types/AppDatabaseType'
import { ColumnInfo, ColumnValue, ColumnType } from './types/ColumnInfo'
import AppDatabase from './AppDatabase'

class AppDatabaseUtil {
  getCreateSql(tableName: string) {
    const entities = AppDatabase.database.entities
    const tableInfo = entities.find(item => item.tableName === tableName)
    return tableInfo?.createSql.replace('${TABLE_NAME}', tableName)
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