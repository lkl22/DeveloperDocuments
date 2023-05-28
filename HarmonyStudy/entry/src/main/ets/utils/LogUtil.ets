import hilog from '@ohos.hilog';

const DOMAIN = 0x6666;
const TAG_PRE = 'ohosStudy_';

export class LogUtil {
  public static d(tag: string, message: string): void {
    let finalTag = `${TAG_PRE}${tag}`
    hilog.debug(DOMAIN, finalTag, '%{public}s', message);
  }

  public static i(tag: string, message: string): void {
    let finalTag = `${TAG_PRE}${tag}`
    hilog.info(DOMAIN, finalTag, '%{public}s', message);
  }

  public static w(tag: string, message: string): void {
    let finalTag = `${TAG_PRE}${tag}`
    hilog.warn(DOMAIN, finalTag, '%{public}s', message);
  }

  public static e(tag: string, message: string): void {
    let finalTag = `${TAG_PRE}${tag}`
    hilog.error(DOMAIN, finalTag, '%{public}s', message);
  }
}