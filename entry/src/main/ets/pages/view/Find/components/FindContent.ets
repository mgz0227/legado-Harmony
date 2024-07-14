/**
 * @author 2008
 * @datetime 2024/7/14 19:54
 * @className: FindContent
 */

import { router } from '@kit.ArkUI';
import BodyContent from './BodyContent';

@Component
export default struct FindContent{
  @Prop currentIndex:number
  build() {
    Column(){
      Search({
        placeholder:'搜索书名或作者'
      })
        .focusOnTouch(false)
        .margin({
          top:8,bottom:8,
          left:20,right:20
        })
        .backgroundColor(Color.White)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/view/search/SearchBook'
          });
        })
      BodyContent({
        currentIndex:this.currentIndex
      })
    }
  }

}