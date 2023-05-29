import { LogUtil } from '../utils/LogUtil';

const TAG = 'AsyncTest';

export class AsyncTest {
  public static async funcA() {
    while (true) {
      let c = 1 + 2;
      let d = c * 7;
      let e = d - c;
      LogUtil.i(TAG, `e = ${e}`);
    }
  }
}