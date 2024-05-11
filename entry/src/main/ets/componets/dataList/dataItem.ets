

export class dataItem{

  title:string

  value:number

  icon:ResourceStr

  type:number|string|boolean

  constructor(title:string='',value:number=0,icon:ResourceStr='',type:number|string|boolean=0){
    this.title=title;
    this.value=value;
    this.icon=icon;
    this.type=type
  }
}