import { LayoutConst } from '@study/common-ui';
import { AsyncFuncTimeoutUtil, LogUtil } from '@study/common-func';
import { AsyncTest } from '../../async/AsyncTest';
import systemDateTime from '@ohos.systemDateTime';

@Entry
@Component
export struct AsyncTestPage {
  @State message: string = '';

  build() {
    Column({ space: 16 }) {
      Text(this.message)
      Button('start while async func.')
        .onClick(this.startWhileAsyncFunc.bind(this))
        .margin({ top: 12 });
      Button('test AsyncFuncTimeoutUtil')
        .onClick((event: ClickEvent) => {
          this.testAsyncFuncTimeoutUtil();
        })
        .margin({ top: 12 });
    }
    .width(LayoutConst.MATCH_PARENT)
    .padding({
      top: 16,
      bottom: 16
    })
  }

  private startWhileAsyncFunc() {
    AsyncTest.funcA();
  }

  private async func(execTime: number = 1000): Promise<string> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve('func');
      }, execTime);
    });
  }

  private async testAsyncFuncTimeoutUtil() {
    let curTime1 = await systemDateTime.getCurrentTime();
    await this.func(6000);
    let funcExecTime1 = await systemDateTime.getCurrentTime() - curTime1;

    curTime1 = await systemDateTime.getCurrentTime();
    await AsyncFuncTimeoutUtil.asyncFuncExec<string>(this.func(6000)).catch(err => {
      LogUtil.e(TAG, `err: ${err.message}`);
    });
    let asyncFuncExecTime1 = await systemDateTime.getCurrentTime() - curTime1;
    LogUtil.d(TAG, `funcExecTime: ${funcExecTime1} asyncFuncExecTime: ${asyncFuncExecTime1}\ndiff: ${asyncFuncExecTime1 - funcExecTime1}`);

    let curTime = await systemDateTime.getCurrentTime();
    await AsyncFuncTimeoutUtil.asyncFuncExec<string>(this.func());
    let asyncFuncExecTime = await systemDateTime.getCurrentTime() - curTime;

    curTime = await systemDateTime.getCurrentTime();
    await this.func();
    let funcExecTime = await systemDateTime.getCurrentTime() - curTime;
    LogUtil.d(TAG, `funcExecTime: ${funcExecTime} asyncFuncExecTime: ${asyncFuncExecTime}\ndiff: ${asyncFuncExecTime - funcExecTime}`);
  }
}

const TAG: string = AsyncTestPage.name;