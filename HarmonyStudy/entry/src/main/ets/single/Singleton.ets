import { LogUtil } from '../utils/LogUtil';

const TAG = 'Singleton';

export default class Singleton {
  static getInstance<T extends {}>(this: new () => T): T {
    LogUtil.i(TAG, `${typeof this}`);
    if (!(<any> this).instance) {
      (<any> this).instance = new this();
    }
    return (<any> this).instance;
  }
}