import { ColumnKeys } from './ColumnInfo'

export interface FieldsType {
  fieldPath: string
  columnName: string
  affinity: ColumnKeys
  boolean?: boolean,
  notNull: boolean
  defaultValue?: string
}

export interface PrimaryKeyType {
  autoGenerate: boolean
  columnNames: string[]
}

export interface IndicesType {
  name: string
  unique: boolean
  columnNames: string[]
  orders: string[]
  createSql: string
}

export interface ForeignKeysType {
  table: string
  onDelete: string
  onUpdate: string
  columns: string[]
  referencedColumns: string[]
}

export interface EntitiesType {
  tableName: string
  createSql: string
  fields: FieldsType[]
  primaryKey: PrimaryKeyType
  indices: IndicesType[]
  foreignKeys: ForeignKeysType[]
}

export interface DatabaseType {
  version: number
  identityHash: string
  entities: EntitiesType[]
  views: string[]
  setupQueries: string[]
}

export interface AppDataBaseType {
  formatVersion: number
  database: DatabaseType
}