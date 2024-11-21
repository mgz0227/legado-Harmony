
@Observed
export class dataItem{

  title:string

  value:number|string

  icon:ResourceStr

  type:number|string|boolean

  status:boolean
  constructor(title:string='',value:number|string=0,icon:ResourceStr='',type:number|string|boolean=0,status:boolean=false){
    this.title=title;
    this.value=value;
    this.icon=icon;
    this.type=type
    this.status=status
  }
}