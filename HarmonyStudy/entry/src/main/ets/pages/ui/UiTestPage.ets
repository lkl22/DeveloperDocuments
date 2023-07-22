import router from '@ohos.router'
import { LayoutConst } from '../../const/LayoutConst'
import { LogUtil } from '@study/common-func'

const TAG = 'UiTestPage'

@Entry
@Component
export struct UiTestPage {
  build(): void {
    Column({ space: 10 }) {
      Button('Row')
        .onClick((event: ClickEvent) => {
          router.pushUrl({ url: "pages/ui/RowTestPage" }).then(() => {
            LogUtil.i(TAG, "router to RowTestPage success.");
          }).catch(err => {
            LogUtil.e(TAG, err);
          })
        })
      Button('Progress')
        .onClick((event: ClickEvent) => {

        })
    }
    .width(LayoutConst.MATCH_PARENT)
    .justifyContent(FlexAlign.Center)
    .margin(16)
  }
}