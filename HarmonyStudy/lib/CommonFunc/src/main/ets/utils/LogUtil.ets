import hilog from '@ohos.hilog';

const DOMAIN = 0x6666;
const TAG_PRE = 'ohosStudy_';
const SINGLE_ROW_MAX_LOG_SIZE = 900;

export class LogUtil {
  public static d(tag: string, message: string): void {
    LogUtil.printLongLog(tag, message, hilog.debug);
  }

  public static i(tag: string, message: string): void {
    LogUtil.printLongLog(tag, message, hilog.info);
  }

  public static w(tag: string, message: string): void {
    LogUtil.printLongLog(tag, message, hilog.warn);
  }

  public static e(tag: string, message: string): void {
    LogUtil.printLongLog(tag, message, hilog.error);
  }

  private static printLongLog(tag: string, message: string, printFunc: (domain: number, tag: string, format: string, message: string) => void): void {
    let finalTag = `${TAG_PRE}${tag}`;
    if (message.length < SINGLE_ROW_MAX_LOG_SIZE) {
      printFunc(DOMAIN, finalTag, '%{public}s', message);
      return
    }
    let segment = Math.ceil(message.length / SINGLE_ROW_MAX_LOG_SIZE);
    for (let i = 0; i < segment; i++) {
      printFunc(DOMAIN, finalTag, '%{public}s', `segment data[${i}]: ${message.substring(i * SINGLE_ROW_MAX_LOG_SIZE, (i + 1) * SINGLE_ROW_MAX_LOG_SIZE)}}`);
    }
  }
}