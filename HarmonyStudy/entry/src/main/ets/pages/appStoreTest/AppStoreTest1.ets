import { LayoutConst } from '../../const/LayoutConst';
import router from '@ohos.router';
import { LogUtil } from '../../utils/LogUtil';

const TAG = 'AppStoreTest1';

@Entry
@Component
struct AppStoreTest1 {
  @StorageLink("appStoreTest") @Watch('appStoreTestChange') appStoreTest: string = ''

  build(): void {
    Column() {
      Text(this.appStoreTest)
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
    LogUtil.i(TAG, `[appStoreTestChange] ${propName} changed. ${this.appStoreTest}`);
  }
}