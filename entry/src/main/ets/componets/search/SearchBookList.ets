import { SearchBook } from '../dataList/SearchBook'
import { common } from '@kit.AbilityKit'
import { util } from '@kit.ArkTS'
import { SearchBookItem } from './SearchBookItem'

@Component
export struct SearchBookList {

  @Prop SearchValue:string
  @State titleLists:string[]=[]
  @State isRefreshing: boolean = false
  @State counter: number = 0

  @State bookList:SearchBook[]=[
    new SearchBook("轮回乐园",
      "机遇与危险共存，只要豁出性命，在轮回乐园中就能得到一切。　　被轮回乐园选中成为‘猎杀者’的那一刻，苏晓就明白，他将与所有人为敌。　　乐园虽然残酷，但无所不能……。\n",
      "",
      "那一只蚊子",
      ["玄幻"],
      15,
      2731594,
      false
    ),
    new SearchBook("轮回乐园",
      " 机遇与危险共存，只要豁出性命，在轮回乐园中就能得到一切。被轮回乐园选中成为‘猎杀者’的那一刻，苏晓就明白，他将与所有人为敌。　　乐园虽然残酷，但无所不能……。\n",
      "",
      "那一只蚊子",
      [],
      8,
      1567932,
      true
    )
  ]

  build() {
    Column({space:10}){
      ForEach(this.bookList,(item:SearchBook)=>{
        SearchBookItem({book:item,SearchValue:this.SearchValue,list:this.subKeyword(this.SearchValue,item.title)})
      })
    }.width("100%").padding({left:20,right:20}).height("100%")
  }





  subKeyword(key:string,str:string):string[]{
    let start=str.indexOf(key)
    if(start<0){
      return [str]
    }
    let end=start+key.length
    let key_start=str.substring(0,start)
    let key_end=str.substring(end,str.length)
    console.log(key_start+"---"+key_end);
    return [key_start,key,key_end]
  }
  //获取rawfile目录文件
  getBookList(){
    let context=getContext() as common.UIAbilityContext;
    let resourceManager=context.resourceManager
    let values:string=""
    resourceManager.getRawFileContent("book.json", (error, value) => {
      if (error != null) {
        console.log("error is " + error);
      } else {
        let decoder = util.TextDecoder.create('utf-8',{ignoreBOM : true })
        values = decoder.decodeWithStream(value,{stream:false});
        this.bookList=JSON.parse(values)
      }
    });
  }
}

