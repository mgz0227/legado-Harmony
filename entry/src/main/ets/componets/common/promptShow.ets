import { promptAction } from '@kit.ArkUI'

/**
 * 自定义提示
 * @param message
 */
export function showMessage(message:string ,showDuration:number = 1000){
  promptAction.showToast({
    message: message,
    duration: showDuration,
  })
}