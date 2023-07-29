import { LogUtil } from '@study/common-func';
import { CustomRichText, LayoutConst, SpanStyle, Toast } from '@study/common-ui';

@Entry
@Component
export struct RichTextTestPage {
  build(): void {
    Column({ space: LayoutConst.SPACE }) {
      CustomRichText({
        originalString: {
          originalText: $r('app.string.test_rich_text_1')
        },
        placeholderStrings: [{
          placeholderText: $r('app.string.user'),
          style: SpanStyle.BOLD
        }, {
          placeholderText: $r('app.string.use_help'),
          style: SpanStyle.HIGHLIGHT,
          clickEvent: () => {
            LogUtil.d(TAG, 'RichTextTestPage HIGHLIGHT text click.');
            Toast.showToast('RichTextTestPage HIGHLIGHT text click.', Toast.ToastConst.LENGTH_SHORT);
          }
        }]
      })
      CustomRichText({
        originalString: {
          originalText: $r('app.string.test_rich_text_2')
        },
        placeholderStrings: [{
          placeholderText: $r('app.string.user'),
          style: SpanStyle.BOLD
        }, {
          placeholderText: $r('app.string.use_help'),
          style: SpanStyle.HIGHLIGHT,
          clickEvent: () => {
            LogUtil.d(TAG, 'RichTextTestPage HIGHLIGHT text click.');
            Toast.showToast('RichTextTestPage HIGHLIGHT text click.', Toast.ToastConst.LENGTH_SHORT);
          }
        }]
      })
      CustomRichText({
        originalString: {
          originalText: $r('app.string.test_rich_text_3')
        },
        placeholderStrings: [{
          placeholderText: $r('app.string.user'),
          style: SpanStyle.BOLD
        }, {
          placeholderText: $r('app.string.use_help'),
          style: SpanStyle.HIGHLIGHT,
          clickEvent: () => {
            LogUtil.d(TAG, 'RichTextTestPage HIGHLIGHT text click.');
            Toast.showToast('RichTextTestPage HIGHLIGHT text click.', Toast.ToastConst.LENGTH_SHORT);
          }
        }]
      })
      CustomRichText({
        originalString: {
          originalText: $r('app.string.test_rich_text_4')
        },
        placeholderStrings: [{
          placeholderText: $r('app.string.user'),
          style: SpanStyle.BOLD
        }, {
          placeholderText: $r('app.string.use_help'),
          style: SpanStyle.HIGHLIGHT,
          clickEvent: () => {
            LogUtil.d(TAG, 'RichTextTestPage HIGHLIGHT text click.');
            Toast.showToast('RichTextTestPage HIGHLIGHT text click.', Toast.ToastConst.LENGTH_SHORT);
          }
        }]
      })
    }
    .margin({
      top: $r('sys.float.ohos_id_default_padding_top'),
      left: $r('sys.float.ohos_id_default_padding_start'),
      bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed'),
      right: $r('sys.float.ohos_id_default_padding_end')
    })
  }
}

const TAG: string = RichTextTestPage.name;