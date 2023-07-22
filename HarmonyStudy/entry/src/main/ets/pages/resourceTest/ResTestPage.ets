import { ResourceUtil, LogUtil } from '@study/common-func';
import { LayoutConst } from '../../const/LayoutConst'

@Entry
@Component
export struct ResTestPage {
  @State res: string = '';

  build(): void {
    Column({ space: LayoutConst.SPACE }) {
      Text(this.res)
      Button('getStringRes')
        .onClick(this.getString.bind(this))
    }
    .width(LayoutConst.MATCH_PARENT)
    .padding({
      top: LayoutConst.PADDING_TOP,
      bottom: LayoutConst.PADDING_BOTTOM
    });
  }

  private async getString(): Promise<void> {
    this.res = await ResourceUtil.getString(getContext(), $r('app.string.page_show'));
    LogUtil.i(TAG, `getString: ${this.res}`);
  }
}

const TAG: string = ResTestPage.name;