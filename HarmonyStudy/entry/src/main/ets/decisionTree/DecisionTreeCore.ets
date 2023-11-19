import { TreeNode } from './TreeNode';

export class DecisionTree<Task, Ctx> {
  rootNode: TreeNode<Task, Ctx>;

  treeMap: Map<Task, TreeNode<Task, Ctx>>;

  constructor(rootNode: TreeNode<Task, Ctx>, treeMap: Map<Task, TreeNode<Task, Ctx>>) {
    this.rootNode = rootNode;
    this.treeMap = treeMap;
  }

  async start(task?: Task, context?: Ctx): Promise<void> {
    let execNode = this.rootNode;
    if (task) {
      let node = this.treeMap.get(task);
      if (!node) {
        throw new Error(`[start] ${task} not in tree.`);
      }
      execNode = node;
    }

    let result = execNode.action();

  }
}