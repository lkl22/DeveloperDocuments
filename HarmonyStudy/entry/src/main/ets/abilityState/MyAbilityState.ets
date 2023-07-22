import { LogUtil } from '@study/common-func';
import AbilityState from '@ohos.app.ability.AbilityStage';

const TAG = 'MyAbilityState';

export class MyAbilityState extends AbilityState {
  onCreate(): void {
    LogUtil.i(TAG, '[onCreate]');
    AppStorage.SetOrCreate('appStoreTest', 'MyAbilityState onCreate');
  }
}