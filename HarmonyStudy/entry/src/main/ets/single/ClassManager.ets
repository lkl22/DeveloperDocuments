import { BaseSingleton } from '@study/common-func';

export class ClassManager extends BaseSingleton {
  private className;

  public setClassName(className: string): void {
    this.className = className;
  }

  public getClassName(): string {
    return this.className;
  }
}