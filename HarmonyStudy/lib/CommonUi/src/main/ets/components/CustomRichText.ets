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
        let regex = /%\d+\$s|%s/gi;
        // 提取占位符
        let phCharList = originalString.match(regex);
        let phCharLen = phCharList.length;

        // 根据占位符拆分原始字符串
        let arrStr = originalString.split(regex);

        let spans: TextInfo[] = [];
        let placeholderLen = this.placeholderStrings.length;
        arrStr.forEach((val: string, index: number, arr) => {
          if (index > 0 && index <= phCharLen) {
            // 获取占位符
            let phChar = phCharList[index - 1];
            let pos = index;
            if (phChar.length > 2) {
              // 长度大于2的按正则匹配出来的结果里肯定有了数字了，这里直接取第一个并转为数字
              pos = parseInt(phChar.match(/\d+/)[0]);
            }
            // 占位符中从数字1开始
            if (pos > 0 && pos <= placeholderLen) {
              spans.push(this.placeholderStrings[pos - 1]);
            } else {
              spans.push({ ...this.originalString, placeholderText: phChar });
            }
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