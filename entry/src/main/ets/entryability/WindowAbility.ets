import { window } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'WindowAbility';

export class WindowAbility {
  private static readonly INSTANCE: WindowAbility = new WindowAbility();
  private context: common.UIAbilityContext | null = null;
  private windowStage: window.WindowStage | null = null;
  private windowClass: window.Window | null = null;
  private windowType: window.WindowStatusType | null = null;

  private constructor() {
  }

  public static getInstance(): WindowAbility {
    return WindowAbility.INSTANCE;
  }

  initContext(context: common.UIAbilityContext) {
    this.context = context;
  }

  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
  }

  getWindowStage(): window.WindowStage | null {
    return this.windowStage;
  }

  /**
   * 初始化避开区域参数
   * @param - mainWindow windows
   * @returns void
   */
  async initAvoidArea(mainWindow: window.Window): Promise<void> {
    hilog.info(0x0000, TAG, 'initAvoidArea start');
    // Initialize default values
    AppStorage.setOrCreate<number>('statusBarHeight', 36);
    AppStorage.setOrCreate<number>('navigationAiBarHeight', 28);
    const defaultDisplay = display.getDefaultDisplaySync();
    let scaledDensity = (defaultDisplay.scaledDensity > 0) ? defaultDisplay.scaledDensity : 1;
    const systemArea: window.AvoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    const navArea: window.AvoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    if (systemArea) {
      const statusBarHeight = systemArea.topRect.height / scaledDensity;
      hilog.info(0x0000, TAG, "initAvoidArea statusBarHeight: " + statusBarHeight);
      AppStorage.setOrCreate<number>('statusBarHeight', statusBarHeight);

      if (deviceInfo.deviceType === 'tablet') {
        AppStorage.setOrCreate<number>("Paf.TopHeight", 56);
      } else if (deviceInfo.deviceType === '2in1') {
        AppStorage.setOrCreate<number>("Paf.TopHeight", 0);
      } else {
        AppStorage.setOrCreate<number>("Paf.TopHeight", systemArea.topRect.height);
      }
    }
    if (navArea) {
      const navigationAiBarHeight = navArea.bottomRect.height / scaledDensity;
      hilog.info(0x0000, TAG, "initAvoidArea navigationAiBarHeight: " + navigationAiBarHeight);
      AppStorage.setOrCreate<number>('navigationAiBarHeight', navigationAiBarHeight);

      if (deviceInfo.deviceType === 'tablet') {
        AppStorage.setOrCreate<number>("NavigationBarHeight", navArea.bottomRect.height);
      } else if (deviceInfo.deviceType === '2in1') {
        AppStorage.setOrCreate<number>("NavigationBarHeight", 0);
      } else {
        AppStorage.setOrCreate<number>("NavigationBarHeight", navArea.bottomRect.height);
      }
    }
    hilog.info(0x0000, TAG, 'initAvoidArea end');
  }

  initWindowSize(): void {
    window.getLastWindow(this.context, (err, windowClass) => {
      if (err.code) {
        hilog.error(0x0000, TAG, 'setWindowWidth getLastWindow failed, error is: ' + JSON.stringify(err));
        return;
      }
      let windowProperty = windowClass.getWindowProperties();
      AppStorage.setOrCreate<number>('windowWidth', windowProperty.windowRect.width);
      AppStorage.setOrCreate<number>('windowHeight', windowProperty.windowRect.height);
      this.windowClass = windowClass;
      this.onWindowSizeChange();
      // this.onWindowStatusChange();
      this.onWindowRectChange();
    });
  }

  private onWindowStatusChange(): void {
    if (!this.windowClass) {
      return;
    }
    this.windowClass.on('windowStatusChange', (type: window.WindowStatusType) => {
      this.windowType = type;
      hilog.info(0x0000, TAG, 'onWindowStatusChange type: ', JSON.stringify(type));
      this.initAvoidArea(this.windowClass!);
      if (type === window.WindowStatusType.FLOATING) {
        AppStorage.setOrCreate<number>("NavigationBarHeight", 0);
      }
    })
  }

  private onWindowRectChange(): void {
    if (!this.windowClass) {
      return;
    }
    this.windowClass.on('windowRectChange', (option) => {
      if (this.windowType === window.WindowStatusType.SPLIT_SCREEN ||
        this.windowType === window.WindowStatusType.FULL_SCREEN) {
        // 重新获取导航栏高度
        this.setNavigationBar();
      }
    })
  }

  private setNavigationBar(): void {
    if (!this.windowClass) {
      return;
    }
    const nav: window.AvoidArea = this.windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    hilog.info(0x0000, TAG, 'setNavigationBar avoidArea: ', JSON.stringify(nav));
    if (nav) {
      AppStorage.setOrCreate<number>("NavigationBarHeight", nav.bottomRect.height);
    }
  }

  async setWindowLayoutFullScreen(isFullScreen: boolean): Promise<void> {
    if (deviceInfo.deviceType === '2in1') {
      return;
    }
    window.getLastWindow(this.context).then(async (wnd: window.Window) => {
      await wnd.setWindowLayoutFullScreen(isFullScreen);
    });
  }

  onWindowSizeChange(callback?: () => void): void {
    if (!this.windowClass) {
      return;
    }
    try {
      this.windowClass.on('windowSizeChange', (size) => {
        hilog.info(0x0000, TAG,
          'onWindowSizeChange windowSizeChange size is: ' + JSON.stringify(size));
        AppStorage.setOrCreate<number>('windowWidth', size.width);
        AppStorage.setOrCreate<number>('windowHeight', size.height);
        callback && callback();
      });
    } catch (exception) {
      hilog.error(0x0000, TAG,
        'onWindowSizeChange failed, error is ' + JSON.stringify(exception));
    }
  }

  setOrientation(windowStage: window.WindowStage, orientation: window.Orientation): void {
    windowStage.getMainWindow().then((win) => {
      win.setPreferredOrientation(orientation).then((data) => {
        hilog.info(0x0000, TAG, 'setOrientation succeeded, error is: ' + JSON.stringify(data));
      }).catch((err: Error) => {
        hilog.error(0x0000, TAG, 'setOrientation setPreferredOrientation failed. error is: ' + JSON.stringify(err));
      });
    }).catch((err: Error) => {
      hilog.error(0x0000, TAG, 'setOrientation getMainWindow failed, error is ' + JSON.stringify(err));
    });
  }

  /**
   * 将系统栏设置为可见。
   *
   * @param { Array<'status' | 'navigation'> } names - 系统栏的设置
   * @param context - 当前应用程序上下文
   */
  toggleWindowSystemBar(names: Array<'status' | 'navigation'>, windowContext: Context | undefined): void {
    window.getLastWindow(windowContext, (err, data) => {
      try {
        if (err.code) {
          return;
        }
        let windowClass = data;
        if (names.length === 0) {
          AppStorage.setOrCreate('Grid.tabPro.enableAvoidAreaListener', false);
        }
        windowClass.setWindowSystemBarEnable(names).then(() => {
          hilog.info(0x0000, TAG, 'toggleWindowSystemBar setWindowSystemBarEnable succeeded');
        }, (error: Error) => {
          if (error) {
            hilog.error(0x0000, TAG,
              'toggleWindowSystemBar setWindowSystemBarEnable failed, error is:' + JSON.stringify(error));
          }
        })
        if (names.length > 0) {
          AppStorage.setOrCreate('Grid.tabPro.enableAvoidAreaListener', true);
        }
        hilog.info(0x0000, TAG, 'toggleWindowSystemBar Succeeded in setting the system bar to be invisible.');
      } catch (exception) {
        hilog.error(0x0000, TAG,
          'toggleWindowSystemBar Failed to set the system bar to be invisible. Cause:' + JSON.stringify(exception));
      }
    });
  }
}