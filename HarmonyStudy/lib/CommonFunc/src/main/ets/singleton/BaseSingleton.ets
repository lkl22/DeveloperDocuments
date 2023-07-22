import { LogUtil } from '../utils/LogUtil';

export abstract class BaseSingleton {
  public static getInstance<T extends {}>(this: new () => T): T {
    LogUtil.i(TAG, `${typeof this}`);
    if (!Object.getOwnPropertyDescriptor(<any> this, 'instance')) {
      (<any> this).instance = new this();
    }
    return (<any> this).instance;
  }
}

const TAG = BaseSingleton.name;