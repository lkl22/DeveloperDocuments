@Component
export struct GrandsonComponent {
  @Consume age: number;

  build() {
    Column() {
      Text(`age: ${this.age}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold);
      Button('grandson button')
        .onClick(this.changeValue.bind(this));
    }
    .width('100%')
    .margin({ top: 12 });
  }

  changeValue() {
    this.age += 1;
  }
}