import { ChildComponent } from './ChildComponent'

// 必须在 src/main/resources/base/profile/main_pages.json 里注册
// A page configured in 'main_pages.json' must have one and only one '@Entry' decorator.
@Entry
@Component
export struct StateTestPage {
  build() {
    Column() {
      ChildComponent()
    }
  }
}