import { ResourceUtil } from '@study/common-func';

export const enum SpanStyle {
  /**
   * 正常
   */
  NORMAL,

  /**
   * 加粗字体
   */
  BOLD,

  /**
   * 高亮
   */
  HIGHLIGHT
}

export class TextInfo {
  /**
   * 原始文本
   */
  originalText?: Resource;

  /**
   * 占位文本
   */
  placeholderText?: ResourceStr;

  /**
   * 字体样式
   */
  style?: SpanStyle;

  /**
   * 字体大小
   */
  fontSize?: Resource;

  /**
   * 字体颜色
   */
  color?: ResourceColor;

  /**
   * 点击事件
   */
  clickEvent?: () => void;
}


@Extend(Span) function normalSpan(fontSize: Resource = $r('sys.float.ohos_id_text_size_body2'),
                                  color: ResourceColor = Color.Black) {
  .fontColor(color)
  .fontSize(fontSize)
  .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
}

@Extend(Span) function boldSpan(fontSize: Resource = $r('sys.float.ohos_id_text_size_body2'),
                                color: ResourceColor = Color.Black) {
  .fontColor(color)
  .fontSize(fontSize)
  .fontWeight(FontWeight.Bold)
  .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
}

@Extend(Span) function highlightSpan(fontSize: Resource = $r('sys.float.ohos_id_text_size_body2'),
                                     color: ResourceColor = Color.Blue) {
  .fontColor(color)
  .fontSize(fontSize)
  .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
}

@Component
export struct CustomRichText {
  originalString: TextInfo;
  placeholderStrings: TextInfo[];
  @State spans: TextInfo[] = undefined

  aboutToAppear(): void {
    ResourceUtil.getString(getContext(), this.originalString.originalText)
      .then((originalString: string) => {
        if (!originalString) {
          return;
        }
        this.originalString.originalText = undefined;
        let spans: TextInfo[] = [];
        let arrStr = originalString.split(`%s`);
        let placeholderLen = this.placeholderStrings.length;
        arrStr.forEach((val: string, idx: number, arr) => {
          if (idx > 0 && idx <= placeholderLen) {
            spans.push(this.placeholderStrings[idx-1]);
          }
          spans.push({ ...this.originalString, placeholderText: val });
        });

        this.spans = spans;
      });
  }

  build(): void {
    if (this.spans) {
      Text() {
        ForEach(this.spans, (item: TextInfo) => {
          if (item.style === SpanStyle.BOLD) {
            Span(item.placeholderText).boldSpan(item.fontSize, item.color)
          } else if (item.style === SpanStyle.HIGHLIGHT) {
            Span(item.placeholderText).highlightSpan(item.fontSize, item.color)
              .onClick((event: ClickEvent) => {
                item.clickEvent();
              })
          } else {
            Span(item.placeholderText).normalSpan(item.fontSize, item.color)
          }
        })
      }
    }
  }
}