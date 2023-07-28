import promptAction from '@ohos.promptAction';
import { LogUtil } from '@study/common-func';

const TAG: string = 'Toast';

export const enum ToastConst {
  LENGTH_SHORT = 3000,
  LENGTH_LONG = 7000,
  BOTTOM = 16
}

export function showToast(message: ResourceStr, duration: number = ToastConst.LENGTH_SHORT,
                          bottom: string | number = ToastConst.BOTTOM) {
  try {
    promptAction.showToast({
      message: message,
      duration: duration,
      bottom: bottom
    });
  } catch (err) {
    LogUtil.e(TAG, `showToast err: ${err.message}`);
  }
}


