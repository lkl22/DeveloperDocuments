@CustomDialog
export struct CommonDialog {
  @Link textValue: string
  @Link inputValue: string
  controller: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后
  cancel: () => void
  confirm: () => void

  build() {
    Column() {
      Text('Change text')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: '', text: this.textValue })
        .height(60)
        .width('90%')
        .onChange((value: string) => {
          this.textValue = value
        })
      Text('Whether to change a text?')
        .fontSize(16)
        .margin({ bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            this.inputValue = this.textValue
            this.controller.close()
            this.confirm()
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }
}