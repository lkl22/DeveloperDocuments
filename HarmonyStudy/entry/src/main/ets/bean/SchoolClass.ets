import { School } from './School';

export class SchoolClass {
  name: string;
  school: School;

  constructor(name: string) {
    this.name = name;
  }
}