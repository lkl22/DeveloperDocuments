export type ActionFunc<Task, Ctx> = (context?: Ctx) => Promise<Task> | Task;

export type LeafActionFunc<Ctx> = (context?: Ctx) => Promise<void> | void;

export type Action<Task, Ctx> = ActionFunc<Task, Ctx> | LeafActionFunc<Ctx>;

export interface AddChildNode<Task, Ctx> {
  nonLeaf(task: Task, action: ActionFunc<Task, Ctx>): AddChildNode<Task, Ctx>;

  leaf(task: Task, action: LeafActionFunc<Ctx>): AddChildNode<Task, Ctx>;
}

export class TreeNode<Task, Ctx> implements AddChildNode<Task, Ctx> {
  task: Task;

  action: Action<Task, Ctx>;

  childNode: Map<Task, TreeNode<Task, Ctx>> = new Map();

  constructor(task: Task, action: Action<Task, Ctx>) {
    this.task = task;
    this.action = action;
  }

  leaf(task: Task, action: LeafActionFunc<Ctx>): AddChildNode<Task, Ctx> {
    return this.addChild(task, action);
  }

  nonLeaf(task: Task, action: ActionFunc<Task, Ctx>): AddChildNode<Task, Ctx> {
    return this.addChild(task, action);
  }

  private addChild(task: Task, action: Action<Task, Ctx>): AddChildNode<Task, Ctx> {
    if (this.childNode.has(task)) {
      throw `${this.task} has child node: ${task}.`;
    }
    this.childNode.set(task, new TreeNode(task, action));
    return this;
  }
}