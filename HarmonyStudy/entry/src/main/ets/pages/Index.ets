import { LayoutConst } from '../const/LayoutConst';
import { LogUtil } from '@study/common-func';
import testNapi from 'libentry.so'
import router from '@ohos.router'

const TAG = 'indexPage';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 16 }) {
      Button('UI Test')
        .onClick(() => {
          router.pushUrl({ url: "pages/ui/UiTestPage" }).then(() => {
            LogUtil.i(TAG, "router to UiTestPage success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
      Button('State Test')
        .onClick(() => {
          router.pushUrl({ url: "pages/statetest/StateTestPage" }).then(() => {
            LogUtil.i(TAG, "router to StateTestPage success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
          LogUtil.i(TAG, `Test NAPI 2 + 3 = ${testNapi.add(2, 3)}`);
        })
      Button('Singleton Test')
        .onClick(() => {
          router.pushUrl({ url: "pages/singletonTest/SingletonTestPage" }).then(() => {
            LogUtil.i(TAG, "router to SingletonTestPage success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
      Button('Async Test')
        .onClick(() => {
          router.pushUrl({ url: "pages/asyncTest/AsyncTestPage" }).then(() => {
            LogUtil.i(TAG, "router to AsyncTestPage success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
      Button('App store Test')
        .onClick(() => {
          router.pushUrl({ url: "pages/appStoreTest/AppStoreTest" }).then(() => {
            LogUtil.i(TAG, "router to AppStoreTest success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
      Button('Json Test')
        .onClick(() => {
          router.pushUrl({ url: "pages/jsonTest/JsonTestPage" }).then(() => {
            LogUtil.i(TAG, "router to JsonTestPage success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
      Button('Dialog Test')
        .onClick(() => {
          router.pushUrl({ url: "pages/dialog/DialogTestPage" }).then(() => {
            LogUtil.i(TAG, "router to DialogTestPage success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
    }
    .width(LayoutConst.MATCH_PARENT)
    .margin({
      top: 16,
      bottom: 16
    })
  }
}
