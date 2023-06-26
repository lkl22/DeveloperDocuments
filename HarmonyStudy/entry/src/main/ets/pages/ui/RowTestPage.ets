import { LayoutConst } from '../../const/LayoutConst'

@Entry
@Component
export struct RowTestPage {
  build(): void {
    Column({ space: 16 }) {
      Row({ space: 8 }) {
        Checkbox()
        Text('abcdefghigklnmopqrstuvwxyzabcdefghigklnmopqrstuvwxyzabcdefghigklnmopqrstuvwxyzabcdefghigklnmopqrstuvwxyzabcdefghigklnmopqrstuvwxyzabcdefghigklnmopqrstuvwxyz')
      }
    }
    .width(LayoutConst.MATCH_PARENT)
    .margin({
      top: 16,
      bottom: 16
    })
  }
}