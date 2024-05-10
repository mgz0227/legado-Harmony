import { SetList, SetGroupList } from '../../../componets/dataList/SetListGroup'
import { SetHead } from '../../../componets/myset/SetHead'
import { SetListView } from '../../../componets/myset/SetListView'

@Entry
@Component
struct MySetPage{

  @State bookSetList: SetList[]=[
    new SetList(false,'自动刷新',true,'','打开软件时自动更新书籍'),
    new SetList(false,'自动跳转最近阅读',true,'','关闭将以底部弹窗形式提示'),
    new SetList(false,'默认启用替换净化',true,'','新加入书架的书是否启用替换净化'),
    new SetList(false,'返回时提示放入书架',true,'','')
  ]

  @State cacheSetList: SetList[]=[
    new SetList(true,'书籍保存位置',true,'','打开软件时自动更新书籍'),
    new SetList(true,'预下载',true,'预先下载10章正文',''),
    new SetList(true,'图片缓存',true,'当前最大缓存50MB',''),
    new SetList(false,'图片抗锯齿',true,'','')
  ]

  @State netWorkSetList: SetList[]=[
    new SetList(false,'Webservice唤醒锁',true,'','如遇杀后台可开启'),
    new SetList(true,'Web端口',true,'','当前端口1122'),
    new SetList(true,'清除webview数据',true,'','清除内置浏览器所有数据'),
    new SetList(true,'用户代理',true,'','')
  ]

  @State otherSetList: SetList[]=[
    new SetList(false,'全程响应耳机按键',true,'','即使退出也响应耳机按键'),
    new SetList(false,'文字操作显示搜索',true,'','长按文字在操作菜单中显示阅读搜索'),
    new SetList(true,'语言',true,'跟随系统',''),
  ]

  @State setGroupList: SetGroupList[] = [
    new SetGroupList('书架',this.bookSetList),
    new SetGroupList('缓存下载',this.cacheSetList),
    new SetGroupList('网络',this.netWorkSetList),
    new SetGroupList('其他',this.otherSetList)
  ]

  // 定义分组设置头部
  @Builder itemHead(text: string) {
    // 分组设置头部组件
    Text(text)
      .fontSize(14)
      .fontColor('#8C8C8C')
      .backgroundColor('#F5F5F5')
      .width('100%')
      .padding({left:40,right:40,top:10,bottom:10})
  }


  build() {
    Column(){
      SetHead({titleName:'我的设置'}).height('5%').margin({top:10})

      List({space:10}){

        ForEach(this.setGroupList,(group:SetGroupList)=>{
          //分组头部
          ListItemGroup({header:this.itemHead(group.groupValue)}){

            if(group.setList){
              ForEach(group.setList,(item:SetList)=>{
                ListItem(){//设置内容，首尾裁剪
                  if (group.setList.indexOf(item) == 0){
                    SetListView({setList:item,topLeft:20,topRight:20})
                  }else if (group.setList.indexOf(item) == group.setList.length - 1){
                    SetListView({setList:item,bottomLeft:20,bottomRight:20})
                  }else {
                    SetListView({setList:item})
                  }
                }.padding({left:20,right:20})
              })
            }

          }
        })

      }.width('100%')
      .height('100%')
      .padding({bottom:40})
    }.backgroundColor('#F5F5F5')

  }
}