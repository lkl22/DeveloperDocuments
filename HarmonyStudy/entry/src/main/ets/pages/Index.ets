import hilog from '@ohos.hilog';
import { LogUtil } from '../utils/LogUtil';
import testNapi from 'libentry.so'
import router from '@ohos.router'

const TAG = 'indexPage';

@Entry
@Component
struct Index {
  @State message: string = 'State Test'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({ url: "pages/statetest/StateTestPage" }).then(() => {
              LogUtil.i(TAG, "router to StateTestPage success.");
            }).catch(err => {
              LogUtil.e(TAG, err);
            })
            LogUtil.i(TAG, `Test NAPI 2 + 3 = ${testNapi.add(2, 3)}`);
          })
        Text('Singleton Test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({ url: "pages/singletonTest/SingletonTestPage" }).then(() => {
              LogUtil.i(TAG, "router to SingletonTestPage success.");
            }).catch(err => {
              LogUtil.e(TAG, err);
            })
          })
        Text('Async Test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({ url: "pages/asyncTest/AsyncTestPage" }).then(() => {
              LogUtil.i(TAG, "router to AsyncTestPage success.");
            }).catch(err => {
              LogUtil.e(TAG, err);
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
