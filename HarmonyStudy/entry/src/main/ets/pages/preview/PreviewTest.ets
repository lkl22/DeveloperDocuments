import { LayoutConst } from '../../const/LayoutConst';
import { ParamsComponent } from './ParamsComponent'

@Preview
@Component
export struct PreviewPage {
  @Prop content: string;

  build(): void {
    Column({ space: 16 }) {
      ParamsComponent({
        content: 'dddd'
      })
    }
    .width(LayoutConst.MATCH_PARENT)
    .padding({
      top: 16,
      bottom: 16
    });
  }
}