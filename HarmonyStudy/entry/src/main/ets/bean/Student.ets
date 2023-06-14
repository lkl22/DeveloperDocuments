import { SchoolClass } from './SchoolClass';

export class Student {
  name: string;
  age: number;
  schoolClass: SchoolClass;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}