import { LayoutConst } from '../../const/LayoutConst';
import { LogUtil } from '../../utils/LogUtil';
import { AsyncTest } from '../../async/AsyncTest';

const TAG = 'AsyncTestPage';

@Entry
@Component
export struct AsyncTestPage {
  @State message: string = '';

  build() {
    Column() {
      Text(this.message)
        .fontSize(50)
      Button('start while async func.')
        .onClick(this.startWhileAsyncFunc.bind(this))
        .margin({ top: 12 });
      Button('test inherit singleton')
        .onClick(this.updateText.bind(this))
        .margin({ top: 12 });
    }.justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .width(LayoutConst.MATCH_PARENT)
  }

  private startWhileAsyncFunc() {
    AsyncTest.funcA();
  }

  private updateText() {
    this.message += '1';
    LogUtil.i(TAG, this.message);
  }
}