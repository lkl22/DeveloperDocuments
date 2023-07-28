import { School } from '../../bean/School';
import { SchoolClass } from '../../bean/SchoolClass';
import { Student } from '../../bean/Student';
import { LayoutConst } from '@study/common-ui';

const TAG = 'AppStoreTest2';

@Entry
@Component
struct AppStoreTest2 {
  @StorageLink("appStoreTest") appStoreTest: string = ''
  @StorageLink("appStoreTest1") appStoreTest1: Student = new Student('lisi', 18);

  build(): void {
    Column() {
      Text(this.appStoreTest)
        .margin({ top: 8 })
      Text(JSON.stringify(this.appStoreTest1))
        .margin({ top: 8 })
      Button('change app store')
        .margin({ top: 8 })
        .onClick((event?: ClickEvent) => {
          AppStorage.Set("appStoreTest", this.appStoreTest + '1');
          if (!this.appStoreTest1.schoolClass) {
            this.appStoreTest1.schoolClass = new SchoolClass('一班');
          } else if (!this.appStoreTest1.schoolClass.school) {
            this.appStoreTest1.schoolClass.school = new School('重点高中');
          } else {
            this.appStoreTest1.schoolClass.school.name = '重点高中';
          }

          AppStorage.Set("appStoreTest1", this.appStoreTest1);
        })
    }
    .width(LayoutConst.MATCH_PARENT)
    .justifyContent(FlexAlign.Center)
  }
}