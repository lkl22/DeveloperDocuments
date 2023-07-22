import { LogUtil } from '../utils/LogUtil';

export abstract class BaseAsyncSingleton {
  public static async getInstance<T extends BaseAsyncSingleton>(this: new () => T): Promise<T> {
    if (!Object.getOwnPropertyDescriptor(<any> this, 'instance')) {
      let temp = new this();
      await temp.init();
      (<any> this).instance = temp;
    }
    return (<any> this).instance;
  }

  protected abstract init(): Promise<void>;
}

const TAG = BaseAsyncSingleton.name;