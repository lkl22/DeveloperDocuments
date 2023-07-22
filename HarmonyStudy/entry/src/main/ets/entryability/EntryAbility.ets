import { LogUtil } from '@study/common-func';
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    LogUtil.i(TAG, 'Ability onCreate');
  }

  onDestroy() {
    LogUtil.i(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    LogUtil.i(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        LogUtil.e(TAG, `Failed to load the content. Cause: ${JSON.stringify(err) ?? ''}`);
        return;
      }
      LogUtil.i(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data) ?? ''}`);
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    LogUtil.i(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    LogUtil.i(TAG, 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    LogUtil.i(TAG, 'Ability onBackground');
  }
};
