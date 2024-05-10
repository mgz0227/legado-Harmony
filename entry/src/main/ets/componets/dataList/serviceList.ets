

export class serviceList {

  name:string

  value:string

  img:ResourceStr

  background:Array<ResourceColor>

  constructor(name: string="", value: string="", img: ResourceStr="", background: Array<ResourceColor>=[]) {
    this.name = name
    this.value = value
    this.img = img
    this.background = background
  }
}