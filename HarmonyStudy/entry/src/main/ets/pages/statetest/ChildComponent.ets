import { Student, Hobby } from './entry/Student';
import { GrandsonComponent } from './GrandsonComponent';

@Component
export struct ChildComponent {
  @Prop name: string;
  @Link nickName: string;
  @Link student: Student;
  @ObjectLink hobby: Hobby;

  build() {
    Column() {
      Text('name: ' + this.name)
        .fontSize(20)
        .fontWeight(FontWeight.Bold);
      Text("nickName: " + this.nickName)
        .fontSize(20)
        .fontWeight(FontWeight.Bold);
      Text("student: " + JSON.stringify(this.student))
        .fontSize(20)
        .fontWeight(FontWeight.Bold);
      Text("student hobby: " + this.hobby.name)
        .fontSize(20)
        .fontWeight(FontWeight.Bold);
      Button('child button')
        .onClick(this.changeValue.bind(this));
      GrandsonComponent();
    }
    .width('100%')
    .margin({ top: 12 });
  }

  changeValue() {
    this.name = 'child';
    this.nickName = 'child nickName';

    this.student.name = "child student";
    this.hobby.name = "child student hobby";
  }
}