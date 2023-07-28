import { CommonDialog } from '../../component/dialog/CommonDialog';
import { LayoutConst } from '@study/common-ui'

@Entry
@Component
export struct AsyncTestPage {
  @State select: number = 2;
  private fruits: string[] = ['apple1', 'orange2', 'peach3', 'grape4', 'banana5'];
  private selectedDate: Date = new Date("2010-1-1");
  private selectTime: Date = new Date('2020-12-25T08:30:00');

  build(): void {
    Column({ space: 10 }) {
      Button('AlertDialog')
        .onClick((event: ClickEvent) => {
          this.testAlertDialog();
        })
      Button('DatePickerDialog')
        .onClick((event: ClickEvent) => {
          this.testDatePickerDialog();
        })
      Button('TimePickerDialog')
        .onClick((event: ClickEvent) => {
          this.testTimePickerDialog();
        })
      Button('TextPickerDialog')
        .onClick((event: ClickEvent) => {
          this.testTextPickerDialog();
        })
      Button('CustomDialog')
        .onClick((event: ClickEvent) => {
          this.testCustomDialog();
        })
    }
    // .backgroundColor('#f00')
    // .height(LayoutConst.MATCH_PARENT)
    .padding({
      top: 16,
      bottom: 16
    })
    .width(LayoutConst.MATCH_PARENT);
  }

  private testAlertDialog(): void {
    AlertDialog.show({
      title: 'title',
      message: 'text',
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      gridCount: 4,
      offset: { dx: 0, dy: -30 },
      primaryButton: {
        value: 'cancel',
        fontColor: '#f00',
        backgroundColor: '#00f',
        action: () => {
          console.info('Callback when the first button is clicked')
        }
      },
      secondaryButton: {
        value: 'ok',
        action: () => {
          console.info('Callback when the second button is clicked')
        }
      },
      cancel: () => {
        console.info('Closed callbacks')
      }
    });
  }

  private testDatePickerDialog(): void {
    DatePickerDialog.show({
      start: new Date("2000-1-1"),
      end: new Date("2100-12-31"),
      selected: this.selectedDate,
      lunar: true,
      onAccept: (value: DatePickerResult) => {
        this.selectedDate.setFullYear(value.year, value.month, value.day)
        console.info("DatePickerDialog:onAccept()" + JSON.stringify(value))
      },
      onCancel: () => {
        console.info("DatePickerDialog:onCancel()")
      },
      onChange: (value: DatePickerResult) => {
        console.info("DatePickerDialog:onChange()" + JSON.stringify(value))
      }
    });
  }

  private testTimePickerDialog(): void {
    TimePickerDialog.show({
      selected: this.selectTime,
      useMilitaryTime: true,
      onAccept: (value: TimePickerResult) => {
        this.selectTime.setHours(value.hour, value.minute)
        console.info("TimePickerDialog:onAccept()" + JSON.stringify(value))
      },
      onCancel: () => {
        console.info("TimePickerDialog:onCancel()")
      },
      onChange: (value: TimePickerResult) => {
        console.info("TimePickerDialog:onChange()" + JSON.stringify(value))
      }
    });
  }

  private testTextPickerDialog(): void {
    TextPickerDialog.show({
      range: this.fruits,
      selected: this.select,
      onAccept: (value: TextPickerResult) => {
        // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
        this.select = value.index
        console.info("TextPickerDialog:onAccept()" + JSON.stringify(value))
      },
      onCancel: () => {
        console.info("TextPickerDialog:onCancel()")
      },
      onChange: (value: TextPickerResult) => {
        console.info("TextPickerDialog:onChange()" + JSON.stringify(value))
      }
    });
  }

  @State textValue: string = ''
  @State inputValue: string = 'click me'
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CommonDialog({
      cancel: this.onCancel,
      confirm: this.onAccept,
      textValue: $textValue,
      inputValue: $inputValue
    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  // 在自定义组件即将析构销毁时将dialogControlle删除和置空
  aboutToDisappear() {
    delete this.dialogController, // 删除dialogController
    this.dialogController = undefined // 将dialogController置空
  }

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  private testCustomDialog(): void {
    if (this.dialogController != undefined) {
      this.dialogController.open()
    }
  }
}