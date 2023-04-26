import hilog from '@ohos.hilog';
import testNapi from 'libentry.so'
import router from '@ohos.router'

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
            router.pushUrl({url:"pages/statetest/StateTestPage"}).then(()=>{
              hilog.error(0x0000, 'testTag', "router success.");
            }).catch(err => {
              hilog.error(0x0000, 'testTag', err);
              console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
            })
            hilog.info(0x0000, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
