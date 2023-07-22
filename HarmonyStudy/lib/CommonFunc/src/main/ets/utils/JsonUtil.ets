import { LogUtil } from './LogUtil';

const TAG = 'JsonUtil';

export class JsonUtil {
  /**
   * 解析字符串为指定类型的对象
   *
   * @param jsonStr 待解析的Json字符串
   * @returns 解析结果
   */
  public static parse<T extends Object>(jsonStr: string): T {
    try {
      return JSON.parse(jsonStr) as T;
    } catch (error) {
      LogUtil.e(TAG, `[parse] ${error}`);
      return null;
    }
  }

  /**
   * 解析字符串为int类型的数字
   *
   * @param s 待解析的字符串
   * @param radix A value between 2 and 36 that specifies the base of the number in numString.
   * @param defaultValue 解析失败时的默认值
   * @returns 解析结果
   */
  public static parseInt(s: string, radix?: number, defaultValue: number = null): number {
    try {
      return parseInt(s, radix);
    } catch (error) {
      LogUtil.e(TAG, `[parseInt] ${error}`);
      return defaultValue;
    }
  }

  /**
   * 解析字符串为float类型的数字
   *
   * @param s 待解析的字符串
   * @param defaultValue 解析失败时的默认值
   * @returns 解析结果
   */
  public static parseFloat(s: string, defaultValue: number = null): number {
    try {
      return parseFloat(s);
    } catch (error) {
      LogUtil.e(TAG, `[parseFloat] ${error}`);
      return defaultValue;
    }
  }

  /**
   * 解析字符串为boolean类型，只有为 'true' 时才为true
   *
   * @param s 待解析的字符串
   * @returns 解析结果
   */
  public static parseBoolean(s: string): boolean {
    return s === 'true';
  }
}