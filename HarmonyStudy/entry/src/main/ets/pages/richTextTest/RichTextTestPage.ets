import { LogUtil } from '@study/common-func';
import { CustomRichText, SpanStyle, Toast } from '@study/common-ui';

@Entry
@Component
export struct RichTextTestPage {
  build(): void {
    Column() {
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
  }
}

const TAG: string = RichTextTestPage.name;