import { BaseSingleton } from '@study/common-func';

export class UserManager extends BaseSingleton {
  private userName;

  public setUserName(userName: string): void {
    this.userName = userName;
  }

  public getUserName(): string {
    return this.userName;
  }
}