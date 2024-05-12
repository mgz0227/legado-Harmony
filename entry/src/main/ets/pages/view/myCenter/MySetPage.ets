import MySetConstants from '../../../common/constants/MySetConstants'
import { Attribute } from '../../../common/utils/Attribute'
import { SetList, SetGroupList } from '../../../componets/dataList/SetListGroup'
import { SetHead } from '../../../componets/myset/SetHead'
import { SetListView } from '../../../componets/myset/SetListView'

@Entry
@Component
struct MySetPage{
  @State private isShowPreDon: boolean = false
  @State private isShowLanguage: boolean = false

  @StorageLink(MySetConstants.SET_REFRESH) setRefresh: boolean = true
  @StorageLink(MySetConstants.SET_JUMP) setJump: boolean = true
  @StorageLink(MySetConstants.SET_REPLACE) setReplace: boolean = true
  @StorageLink(MySetConstants.SET_TIP) setTip: boolean = true
  @StorageLink(MySetConstants.SET_IMG_ANTI) setImgAnti: boolean = true
  @StorageLink(MySetConstants.SET_AWAKEN) setAwaken: boolean = true
  @StorageLink(MySetConstants.SET_HEAD) setHead: boolean = true
  @StorageLink(MySetConstants.SET_SEARCH) setSearch: boolean = true
  @StorageLink(MySetConstants.SET_PRE_DOWNLOAD) select: number = 10
  @StorageLink(MySetConstants.SET_LANGUAGE) selectLanguage: string = '跟随系统'

  private tempNum: number = 10
  private preDow: string = '预先下载'+this.select+'章正文'
  private fruits: string[] = getRandomStringArray()

  @State languageList: string[] = ['跟随系统','简体中文','繁体中文','英文']



  @State bookSetList: SetList[]=[
    new SetList(false,'自动刷新',this.setRefresh,'','打开软件时自动更新书籍',MySetConstants.SET_REFRESH),
    new SetList(false,'自动跳转最近阅读',this.setJump,'','关闭将以底部弹窗形式提示',MySetConstants.SET_JUMP),
    new SetList(false,'默认启用替换净化',this.setReplace,'','新加入书架的书是否启用替换净化',MySetConstants.SET_REPLACE),
    new SetList(false,'返回时提示放入书架',this.setTip,'','',MySetConstants.SET_TIP)
  ]

  @State cacheSetList: SetList[]=[
    new SetList(true,'书籍保存位置',true,'','打开软件时自动更新书籍',MySetConstants.SET_BOOK_SAVE),
    new SetList(true,'预下载',true,this.preDow,'',MySetConstants.SET_PRE_DOWNLOAD),
    new SetList(true,'图片缓存',true,'当前最大缓存50MB','',MySetConstants.SET_IMG_CACHE),
    new SetList(false,'图片抗锯齿',this.setImgAnti,'','',MySetConstants.SET_IMG_ANTI)
  ]

  @State netWorkSetList: SetList[]=[
    new SetList(false,'Webservice唤醒锁',this.setAwaken,'','如遇杀后台可开启',MySetConstants.SET_AWAKEN),
    new SetList(true,'Web端口',true,'','当前端口1122',MySetConstants.SET_WEB_PORT),
    new SetList(true,'清除webview数据',true,'','清除内置浏览器所有数据',MySetConstants.SET_CLEAR_WEB),
    new SetList(true,'用户代理',true,'','',MySetConstants.SET_USER_AGENT)
  ]

  @State otherSetList: SetList[]=[
    new SetList(false,'全程响应耳机按键',this.setHead,'','即使退出也响应耳机按键',MySetConstants.SET_HEAD),
    new SetList(false,'文字操作显示搜索',this.setSearch,'','长按文字在操作菜单中显示阅读搜索',MySetConstants.SET_SEARCH),
    new SetList(true,'语言',true,'跟随系统','',MySetConstants.SET_LANGUAGE),
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
      .fontSize(12)
      .fontColor('#8C8C8C')
      .backgroundColor('#F5F5F5')
      .width('100%')
      .padding({left:40,right:40,top:16,bottom:8})
  }


  build() {
    Column(){

      Blank(40)

      SetHead({titleName:'我的设置'}).height(48).padding({left:20})

      List(){

        ForEach(this.setGroupList,(group:SetGroupList)=>{
          //分组头部
          ListItemGroup({header:this.itemHead(group.groupValue)}){

            if(group.setList){
              ForEach(group.setList,(item:SetList)=>{
                ListItem(){//设置内容，首尾裁剪
                  if (group.setList.indexOf(item) == 0){
                    SetListView({setList:item,topLeft:20,topRight:20})
                      .onClick(()=>{this.itemOnclick(item.storageName)})

                  }else if (group.setList.indexOf(item) == group.setList.length - 1){
                    SetListView({setList:item,bottomLeft:20,bottomRight:20})
                      .onClick(()=>{this.itemOnclick(item.storageName)})
                  }else {
                    SetListView({setList:item})
                      .onClick(()=>{this.itemOnclick(item.storageName)})
                  }
                }.padding({left:20,right:20})
              })
            }

          }
        })

      }.width('100%')
      .height('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }.backgroundColor('#F5F5F5')
    .bindSheet($$this.isShowLanguage, this.languageSheet(), {
      height: 288,
      dragBar: false,
      showClose: false,
    })
    // 通过选定的半模态接口，绑定模态展示界面，style中包含两个参数，一个是设置半模态的高度，不设置时默认高度是Large，一个是是否显示控制条DragBar，默认是true显示控制条
    .bindSheet($$this.isShowPreDon, this.preDowSheet(), {
      height: 288,
      dragBar: false,
      showClose: false,
    })


  }



  // 通过@Builder构建预下载半模态展示界面
  @Builder preDowSheet() {
    Column() {
      Row(){
        // 分组设置头部组件
        Text('取消')
          .fontSize(14)
          .padding({left:20})
          .onClick(()=>{this.isShowPreDon = false})

        Text('预下载')
          .fontSize(16)

        Text('确定')
          .fontSize(14)
          .padding({right:20})
          .onClick(()=>{
            this.isShowPreDon = false
            this.select = this.tempNum
            this.preDow = '预先下载'+this.select+'章正文'
            this.cacheSetList[1].rightText = this.preDow
          })
      }.width('100%').height(56).justifyContent(FlexAlign.SpaceBetween)
      Column() {
        TextPicker({ range: this.fruits, selected: this.select })
          .onChange((value: string | string[], index: number | number[]) => {
            if (typeof index === "number") {
              this.tempNum = index
            }
          })
          .disappearTextStyle({color: Color.Black, font: {size: 14, weight: FontWeight.Normal}})
          .textStyle({color: Color.Black, font: {size: 14, weight: FontWeight.Normal}})
          .selectedTextStyle({color: Color.Red, font: {size: 16, weight: FontWeight.Bolder}})
      }.width('100%').height('100%')
    }
    .width('100%')
    .height(288)
    .backgroundColor(Color.White)
  }

  // 通过@Builder构建半模态展示界面
  @Builder languageSheet() {
    Column() {
      Text('预下载')
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .width('100%').height(56)
      ForEach(this.languageList,(value:string)=>{
        Text(value)
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .width('100%').height(56)
      })

    }
    .width('100%')
    .height(288)
    .backgroundColor(Color.White)
  }

  /**
   * 设置列表点击事件
   * @param value
   */
  itemOnclick(value:string){
    switch (value){
      case MySetConstants.SET_REFRESH:
        this.setRefresh = !this.setRefresh
        this.bookSetList[0].toggleStatus = this.setRefresh;
        break;
      case MySetConstants.SET_JUMP:
        this.setJump = !this.setJump
        this.bookSetList[1].toggleStatus = this.setJump;
        break;
      case MySetConstants.SET_REPLACE:
        this.setReplace = !this.setReplace
        this.bookSetList[2].toggleStatus = this.setReplace;
        break;
      case MySetConstants.SET_TIP:
        this.setTip = !this.setTip
        this.bookSetList[3].toggleStatus = this.setTip;
        break;
      case MySetConstants.SET_IMG_ANTI:
        this.setImgAnti = !this.setImgAnti
        this.cacheSetList[3].toggleStatus = this.setImgAnti;
        break;
      case MySetConstants.SET_AWAKEN:
        this.setAwaken = !this.setAwaken
        this.netWorkSetList[0].toggleStatus = this.setAwaken;
        break;
      case MySetConstants.SET_HEAD:
        this.setHead = !this.setHead
        this.otherSetList[0].toggleStatus = this.setHead;
        break;
      case MySetConstants.SET_SEARCH:
        this.setSearch = !this.setSearch
        this.otherSetList[1].toggleStatus = this.setSearch;
        break;
      case MySetConstants.SET_BOOK_SAVE:
        break;
      case MySetConstants.SET_PRE_DOWNLOAD:
        this.isShowPreDon = !this.isShowPreDon;
        break;
      case MySetConstants.SET_IMG_CACHE:
        break;
      case MySetConstants.SET_WEB_PORT:
        break;
      case MySetConstants.SET_CLEAR_WEB:
        break;
      case MySetConstants.SET_USER_AGENT:
        break;
      case MySetConstants.SET_LANGUAGE:
        this.isShowLanguage = !this.isShowLanguage;
        break;
    }
  }
}

function getRandomStringArray():string[]{
  let list: string[] = []
  for (let i = 0; i < 100; i++) {
    list.push(i.toString())
  }
  return list;
}
