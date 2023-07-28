import { Student } from '../../bean/Student';
import { LayoutConst } from '@study/common-ui';
import router from '@ohos.router';
import { LogUtil } from '@study/common-func';

const TAG = 'AppStoreTest1';

@Entry
@Component
struct AppStoreTest1 {
  @StorageLink("appStoreTest") @Watch('appStoreTestChange') appStoreTest: string = ''
  @StorageLink("appStoreTest1") @Watch('appStoreTestChange') appStoreTest1: Student = new Student('lisi', 18);

  build(): void {
    Column() {
      Text(this.appStoreTest)
        .margin({ top: 8 })
      Text(JSON.stringify(this.appStoreTest1))
        .margin({ top: 8 })
      Button('goto next')
        .margin({ top: 8 })
        .onClick((event?: ClickEvent) => {
          router.pushUrl({ url: "pages/appStoreTest/AppStoreTest2" }).then(() => {
            LogUtil.i(TAG, "router to AppStoreTest2 success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
    }
    .width(LayoutConst.MATCH_PARENT)
    .justifyContent(FlexAlign.Center)
  }

  private appStoreTestChange(propName: string): void {
    LogUtil.i(TAG, `[appStoreTestChange] ${propName} changed. ${JSON.stringify(this[propName])}`);
  }
}