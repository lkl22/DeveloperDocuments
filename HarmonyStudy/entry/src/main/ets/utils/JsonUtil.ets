import { LogUtil } from './LogUtil';

const TAG = 'JsonUtil';

export class JsonUtil {
  public static parse<T>(jsonStr: string): T {
    try {
      return JSON.parse(jsonStr) as T;
    } catch (error) {
      LogUtil.e(TAG, `[parse] ${error}`);
      return null;
    }
  }
}