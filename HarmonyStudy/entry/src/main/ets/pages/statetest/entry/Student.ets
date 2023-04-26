@Observed
class Hobby {
  name: string;

  constructor(name: string) {
    this.name = name;
  }
}

class Student {
  name: string;
  age: number;
  // 属性监听只能监听一层，内嵌对象，需要@Observed装饰
  hobby: Hobby;

  constructor(name: string, age: number, hobby: Hobby) {
    this.name = name;
    this.age = age;
    this.hobby = hobby;
  }
}

export { Student, Hobby };