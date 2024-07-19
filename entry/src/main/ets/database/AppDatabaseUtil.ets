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

  // 检测表中的字段是否缺失，若是缺失则新增
  async existsTable(tableName: string) {
    try {
      const rowNames = await DbUtil.queryRowNames(tableName);
      const fields = this.getFields(tableName)
      if (!fields?.length) return
      for (let index = 0; index < fields.length; index++) {
        const element = fields[index];
        if (!rowNames.includes(element.columnName)) {
          console.info(`TagInfo 数据表【${tableName}】缺失字段，开始新增字段：`, element.columnName)
          let executeSql =  `ALTER TABLE '${tableName}' ADD COLUMN '${element.columnName}' ${element.affinity}`
          if (element.defaultValue) {
            executeSql += ` DEFAULT '${element.defaultValue}'`
          }
          await DbUtil.executeSql(executeSql)
          console.info('TagInfo', `数据表【${tableName}】新增字段【${element.columnName}】成功`)
        }
      }
    } catch (e) {
      console.info('TagInfo Error:', JSON.stringify(e))
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