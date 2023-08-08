import * as EmptyUtil from './EmptyUtil';
import { LogUtil } from './LogUtil';

const TAG: string = 'StringUtil';

export function parseToInt(data: string, defaultValue: number): number {
  if (EmptyUtil.isStringBlank(data)) {
    return defaultValue;
  }
  try {
    return parseInt(data);
  } catch (err) {
    LogUtil.e(TAG, `parseToInt err: ${err.message}`);
    return defaultValue;
  }
}