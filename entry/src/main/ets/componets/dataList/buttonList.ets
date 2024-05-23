/**
 * @author 2008
 * @datetime 2024/5/23 22:26
 * @className: buttonList
 */
export class buttonList {
  id:number
  title:string
  icon:Resource
  constructor(id:number,title:string,icon:Resource){
    this.id = id
    this.title = title
    this.icon = icon
  }
}