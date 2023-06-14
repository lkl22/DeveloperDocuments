import { LayoutConst } from '../../const/LayoutConst';

const TAG = 'AppStoreTest2';

@Entry
@Component
struct AppStoreTest2 {
  @StorageLink("appStoreTest") appStoreTest: string = ''

  build(): void {
    Column() {
      Text(this.appStoreTest)
      Button('change app store')
        .margin({ top: 8 })
        .onClick((event?: ClickEvent) => {
          AppStorage.Set("appStoreTest", this.appStoreTest + '1');
        })
    }
    .width(LayoutConst.MATCH_PARENT)
    .justifyContent(FlexAlign.Center)
  }
}