import { LayoutConst } from '../../const/LayoutConst';
import { JsonUtil, LogUtil } from '@study/common-func';

const TAG = 'JsonTestPage';

class B {
  n: number;
  b: boolean;
}

class A {
  n: number;
  b: boolean;
  s: string;
  arr: [B];
}

@Entry
@Component
export struct JsonTestPage {
  @State res: string = '';

  build(): void {
    Scroll() {
      Column({ space: 16 }) {
        Text(this.res)
        Button('float number')
          .onClick((event: ClickEvent) => {
            let res = JsonUtil.parseFloat('3.5');
            this.res = `parse: ${typeof res} ${JSON.stringify(res)}`;
            res = JsonUtil.parseFloat('true11');
            LogUtil.d(TAG, `parse: ${typeof res} ${JSON.stringify(res)}`);
          })
        Button('int number')
          .onClick((event: ClickEvent) => {
            let res = JsonUtil.parseInt('3');
            this.res = `parse: ${typeof res} ${JSON.stringify(res)}`;
          })
        Button('err number')
          .onClick((event: ClickEvent) => {
            let res = JsonUtil.parseFloat('true');
            this.res = `parse: ${typeof res} ${JSON.stringify(res)}`;
          })
        Button('boolean')
          .onClick((event: ClickEvent) => {
            let res = JsonUtil.parseBoolean('true');
            this.res = `parse: ${typeof res} ${JSON.stringify(res)}`;
            res = JsonUtil.parseBoolean('true11');
            LogUtil.d(TAG, `parse: ${typeof res} ${JSON.stringify(res)}`);
          })
        Button('object')
          .onClick((event: ClickEvent) => {
            let res = JsonUtil.parse<A>('{"n": 11, "b": true, "s": "string", "arr": "jjjj"}');
            LogUtil.d(TAG, `parse class A: ${typeof res.n} ${typeof res.b} ${typeof res.s} ${typeof res.arr} ${typeof res.arr[0]}`)
            this.res = `parse: ${typeof res} ${JSON.stringify(res)}`;

            let classA = JsonUtil.parse<A>('{"n": 11, "b": true, "s": "string", "arr": [{"n": 11, "b": "true"}, {"n": 22, "b": "false"}]}');
            LogUtil.d(TAG, `parse class A: ${typeof classA.n} ${typeof classA.b} ${typeof classA.s} ${typeof classA.arr} ${typeof classA.arr[0]}`)

            let classB = JsonUtil.parse<B>('{"n": 11, "b": "true"}');
            LogUtil.d(TAG, `parse: ${typeof classB} ${JSON.stringify(classB)}`);
          })
        Button('stringify')
          .onClick((event: ClickEvent) => {
            let a = new A();
            a.n = 1;
            a.b = null;
            a.s = undefined;
            this.res = `${JSON.stringify(a)}\n${JsonUtil.stringify(a)}`;
          })
      }
      .width(LayoutConst.MATCH_PARENT);
    }
  }
}