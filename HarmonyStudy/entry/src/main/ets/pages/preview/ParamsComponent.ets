import { LayoutConst } from '@study/common-ui';

@Component
export struct ParamsComponent {
  @Prop content: string;

  build(): void {
    Column({ space: 16 }) {
      Text('Preview')
      Text(this.content)
    }
    .width(LayoutConst.MATCH_PARENT)
    .padding({
      top: 16,
      bottom: 16
    });
  }
}