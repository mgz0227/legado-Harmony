/**
 * @author 2008
 * @datetime 2024/8/13 22:04
 * @className: SystemUtils
 */
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

class SystemUtils {
  //浏览器打开
  async startBrowsableAbility(context: common.UIAbilityContext, uri: string): Promise<void> {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: uri
    };
    context.startAbility(want)
      .then(() => {
        console.error('Start browsableAbility successfully.');
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
      });
  }
}

const systemUtil = new SystemUtils();
export default systemUtil as SystemUtils;