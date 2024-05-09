

export class dataItem{

  title:string

  value:number

  icon:ResourceStr

  constructor(title:string='',value:number=0,icon:ResourceStr=''){
    this.title=title;
    this.value=value;
    this.icon=icon;
  }
}