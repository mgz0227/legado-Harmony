import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { BusinessError } from '@kit.BasicServicesKit';
import { AbilityConstant, Want } from '@kit.AbilityKit';
import display from '@ohos.display';

export default class EntryAbility extends UIAbility {

  private curBp: string = ''

  // 根据当前窗口尺寸更新断点
  private updateBreakpoint(windowWidth: number) :void{
    // 将长度的单位由px换算为vp
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels
    let newBp: string = ''
    if (windowWidthVp < 320) {
      newBp = 'xs'
    } else if (windowWidthVp < 600) {
      newBp = 'sm'
    } else if (windowWidthVp < 840) {
      newBp = 'md'
    } else {
      newBp = 'lg'
    }
    if (this.curBp !== newBp) {
      this.curBp = newBp
      // 使用状态变量记录当前断点值
      AppStorage.setOrCreate('currentBreakpoint', this.curBp)
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // 全屏
    windowStage.getMainWindow((err, windowClass) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return
      }
      //全屏
      windowClass.setWindowLayoutFullScreen(true)
        .then(() => {
          console.info('Succeeded in setting the window layout to full-screen mode.');
        })
        .catch((err: BusinessError) => {
          console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
        });
      //获取上下遮挡区域
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; //导航栏
      let avoidArea = windowClass.getWindowAvoidArea(type);
      let bottomRectHeight = avoidArea.bottomRect.height;
      AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight));

      // 2. 获取导航栏避让遮挡的区域
      type = window.AvoidAreaType.TYPE_SYSTEM; // 状态栏
      avoidArea = windowClass.getWindowAvoidArea(type);
      let topRectHeight = avoidArea.topRect.height;
      AppStorage.setOrCreate('topRectHeight', px2vp(topRectHeight));

      //手机屏幕高度和宽度
      let defaultDisplay = display.getDefaultDisplaySync()
      let WindowHeight = defaultDisplay.height
      let WindowWidth = defaultDisplay.width


      AppStorage.setOrCreate('WindowHeight', px2vp(WindowHeight));
      AppStorage.setOrCreate('WindowWidth', px2vp(WindowWidth));

    })
    windowStage.loadContent('pages/welcomePage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
