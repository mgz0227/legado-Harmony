import { router } from '@kit.ArkUI';
import { Attribute } from '../../common/utils/Attribute';

@Component
export struct SearchHead{
  @Consume SearchValue: string
  @Consume SearchStatus: number
  build() {
    Flex({
      alignItems:ItemAlign.End,
      justifyContent:FlexAlign.SpaceBetween
    }){
      Row({ space: 15 }) {
        Image($r('app.media.return_left'))
          .width(25)
          .height(25)
          .onClick(()=>{
            router.back()
          })
        Search({ value: this.SearchValue, placeholder: '搜索书名或作者', icon: "/common/images/search.svg" })
          .width("70%")
          .height(40)
          .onChange(this.onChange)
          .onSubmit(this.onSubmit);
        Text(this.SearchValue.length>0?"取消":"搜索").width("10%").height(40).fontWeight(600)
      }.margin({left:5}).width("100%")
    }
    .borderRadius({ bottomRight:5 ,bottomLeft:5})
    .backgroundImage($r('app.media.backgroundimage'))
    .backgroundImageSize({width:'100%'})
    .height('11%')
  }

  onChange=(value: string)=> {
    this.SearchValue=value;
  }
  onSubmit=(value: string)=>{
    this.SearchValue=value;
    this.SearchStatus=1;
    console.log(this.SearchStatus.toString());
  }
  aboutToAppear(): void {
    console.log(this.SearchStatus.toString());
  }
}