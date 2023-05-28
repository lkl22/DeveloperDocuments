import Singleton from './Singleton';

export class ClassManager extends Singleton {
  private className;

  public setClassName(className: string): void {
    this.className = className;
  }

  public getClassName(): string {
    return this.className;
  }
}