import Singleton from './Singleton';

export class UserManager extends Singleton {
  private userName;

  public setUserName(userName: string): void {
    this.userName = userName;
  }

  public getUserName(): string {
    return this.userName;
  }
}