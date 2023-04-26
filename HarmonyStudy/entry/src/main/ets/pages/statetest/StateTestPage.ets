import { Student, Hobby } from './entry/Student';
import { ChildComponent } from './ChildComponent';

// 必须在 src/main/resources/base/profile/main_pages.json 里注册
// A page configured in 'main_pages.json' must have one and only one '@Entry' decorator.
@Entry
@Component
export struct StateTestPage {
  @State name: string = 'name';
  @State nickName: string = 'nickName';
  @Provide age: number = 1;
  @State student: Student = new Student('li', 2, new Hobby('篮球'));

  build() {
    Column() {
      ChildComponent({ name: this.name, nickName: $nickName, student: $student, hobby: this.student.hobby });
      Button('page button')
        .onClick(this.changedStateValue.bind(this))
        .margin({ top: 12 });
    }
  }

  changedStateValue() {
    this.name = 'parent';
    this.nickName = 'parent nickName';
    this.age += 1;

//    this.student.name = 'hello';
//    this.student.age = 99;
    this.student.hobby.name = '足球';
  }
}