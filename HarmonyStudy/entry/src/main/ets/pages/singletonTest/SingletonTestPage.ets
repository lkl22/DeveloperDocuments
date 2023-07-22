import { LayoutConst } from '../../const/LayoutConst';
import { BSingleton } from '../../single/BSingleton';
import { ASingleton } from '../../single/ASingleton';
import { LogUtil } from '@study/common-func';
import { UserManager } from '../../single/UserManager';
import { ClassManager } from '../../single/ClassManager';

const TAG = 'SingletonTestPage';

@Entry
@Component
export struct SingletonTestPage {
  build() {
    Column() {
      Button('test singleton')
        .onClick(this.testSingleton.bind(this))
        .margin({ top: 12 });
      Button('test inherit singleton')
        .onClick(this.testInheritSingleton.bind(this))
        .margin({ top: 12 });
    }
    .width(LayoutConst.MATCH_PARENT)
  }

  private testSingleton(): void {
    let classManager1 = ClassManager.getInstance();
    let classManager2 = ClassManager.getInstance();
    classManager1.setClassName('class1');
    LogUtil.i(TAG, `getClassName: ${classManager2.getClassName()}`);

    let userManager1 = UserManager.getInstance();
    let userManager2 = UserManager.getInstance();
    userManager1.setUserName('luck');
    LogUtil.i(TAG, `getUserName: ${userManager2.getUserName()}`);
  }

  private testInheritSingleton(): void {
    let aSingleton = ASingleton.getInstance();
    let bSingleton = BSingleton.getInstance();

    LogUtil.e(TAG, `aSingleton === aSingleton: ${aSingleton === bSingleton}`);
  }
}