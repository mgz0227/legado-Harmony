/**
 * @author 2008
 * @datetime 2024/7/29 12:44
 * @className: ToolsUtils
 * 工具类方法
 */
export class ToolsUtils {
  //数字转换数组
  numberArrays(ids:number|number[]){
    let Ids:number[] = []
    if (typeof ids === 'number'){
      Ids.push(ids)
    } else {
      Ids = ids
    }
    return Ids
  }
  //字符串转换数组
  stringArrays(ids:string|string[]){
    let Ids:string[] = []
    if (typeof ids === 'string'){
      Ids.push(ids)
    } else {
      Ids = ids
    }
    return Ids
  }
}

const toolsUtils = new ToolsUtils();
export default toolsUtils as ToolsUtils;