/**
 * Copyright (C), 2024-05-13
 * @author LinXun
 * @date 2024/5/13 15:31
 * @version 1.0
 * @description: 时间处理函数
 */
class DateUtil {
  /**
   * 格式化时间
   * @param num
   * @returns
   */
  formateDate(num: number): string {
    let date = new Date(num);
    let year = date.getFullYear();
    let month = date.getMonth() + 1;
    let day = date.getDate();
    let hour = date.getHours();
    let minute = date.getMinutes();
    let m = month  < 10 ? '0' + month : month;
    let d = day < 10 ? '0' + day : day;
    let h = hour < 10 ? '0' + hour : hour;
    let mi = minute < 10 ? '0' + minute : minute;
    return `${year}-${m}-${d} ${h}:${mi}`;
  }
}
let dateUtil = new DateUtil();
export default dateUtil as DateUtil;