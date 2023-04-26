@Component
export struct ChildComponent {
  build() {
    Column() {
      Text('nihao').fontSize(50)
        .fontWeight(FontWeight.Bold)
    }.width('100%')
  }
}