/**
 * @author 2008
 * @datetime 2024/8/21 20:18
 * @className: ClickUtils
 * 防止重复点击
 */
class ClickUtils {
  private isClicking:boolean = false;
  preventClick(onClickFunction:Function=() => {}, delay:number=1000){
    if(!this.isClicking){
      this.isClicking = true;
      onClickFunction();
      setTimeout(()=>{
        this.isClicking = false;
      },delay)
    }
  }
}

const clickUtil = new ClickUtils();
export default clickUtil as ClickUtils;